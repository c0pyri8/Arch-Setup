#!/usr/bin/env bash

# Exit on any error, undefined variable, or pipe failure
set -euo pipefail

# Get the directory where this wrapper script resides
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define execution sequence matching exact repository filenames
SCRIPTS=(
    "installer.sh"
    "installer-checks.sh"
    "swap-space.sh"
    "Customization.sh"
)

echo "=================================================="
echo "    Starting Arch Linux Master Installer Suite   "
echo "=================================================="

for script in "${SCRIPTS[@]}"; do
    TARGET_PATH="$SCRIPT_DIR/$script"

    echo ""
    echo "--------------------------------------------------"
    echo " [>] Executing: $script"
    echo "--------------------------------------------------"

    # Check if script exists
    if [[ ! -f "$TARGET_PATH" ]]; then
        echo " [!] ERROR: Required script '$script' not found in $SCRIPT_DIR." >&2
        exit 1
    fi

    # Ensure executable permissions are set
    if [[ ! -x "$TARGET_PATH" ]]; then
        echo " [*] Granting execute permissions to $script..."
        chmod +x "$TARGET_PATH"
    fi

    # Execute script and handle potential failures cleanly
    if "$TARGET_PATH"; then
        echo " [+] Successfully completed: $script"
    else
        echo " [!] ERROR: Execution failed on $script. Aborting setup." >&2
        exit 1
    fi
done

echo ""
echo "=================================================="
echo "    All scripts executed successfully!            "
echo "=================================================="

# --------------------------------------------------
#  Stealth History Cleanup Section
# --------------------------------------------------
echo " [*] Cleaning up session & shell execution history..."

# 1. Prevent current session from writing to history on exit
unset HISTFILE 2>/dev/null || true

# 2. Clear current in-memory history buffer
history -c 2>/dev/null || true

# 3. Truncate/remove standard shell history files for current user & root
for hist_file in "$HOME/.bash_history" "$HOME/.zsh_history" "$HOME/.bash__history" "/root/.bash_history" "/root/.zsh_history"; do
    if [[ -f "$hist_file" ]]; then
        cat /dev/null > "$hist_file" 2>/dev/null || true
    fi
done

# 4. Silence history logging if running under zsh or bash
if [ -n "${BASH_VERSION:-}" ]; then
    set +o history 2>/dev/null || true
fi

echo " [+] History completely wiped. System clean."

# Exit quietly
exit 0
