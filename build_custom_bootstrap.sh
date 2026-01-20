#!/bin/bash
set -e -u -o pipefail

# --- Configuration ---
# These are set to your specifications.
export TERMUX_APP__PACKAGE_NAME="com.vault.fide"
export TERMUX_APP_TYPE="f-droid"
export BOOTSTRAP_ARCHITECTURES="aarch64"
export TERMUX_GENERATOR_HOME="$(pwd)"

# Switch to the script's directory, which is the repository root in the CI environment.
cd "$(realpath "$(dirname "$0")")"

# --- Source functions from the original project ---
source "$TERMUX_GENERATOR_HOME/scripts/termux_generator_utils.sh"
source "$TERMUX_GENERATOR_HOME/scripts/termux_generator_steps.sh"

# --- Main Steps ---
echo "[*] Cleaning up previous artifacts..."
clean_artifacts

echo "[*] Downloading source repositories for '$TERMUX_APP_TYPE'..."
download

echo "[*] Applying patches and custom package name to bootstraps..."
patch_bootstraps

echo "[*] Building bootstrap for architecture: $BOOTSTRAP_ARCHITECTURES..."
build_bootstraps

echo "[*] Moving the final bootstrap archive..."
# The final name is derived from the variables for consistency.
FINAL_BOOTSTRAP_NAME="bootstrap-${TERMUX_APP__PACKAGE_NAME}-${BOOTSTRAP_ARCHITECTURES}.zip"
mv "termux-packages-main/bootstrap-${BOOTSTRAP_ARCHITECTURES}.zip" "$FINAL_BOOTSTRAP_NAME"

echo "[*] Cleaning up downloaded source files..."
rm -rf termux-packages-main termux-apps-main

echo "[+] Done. Your custom bootstrap is: $FINAL_BOOTSTRAP_NAME"