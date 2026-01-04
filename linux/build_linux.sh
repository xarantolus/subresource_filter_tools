#!/bin/bash
set -e # exit on error

output() {
    echo "--------------------------------------------------------------------------------"
    echo "$@"
    echo "--------------------------------------------------------------------------------"
}

# Basically follow https://chromium.googlesource.com/chromium/src/+/master/docs/linux/build_instructions.md

# --- At first, we want to have all tools installed

echo "::group::Install dependencies"

output "Start installing tools..."
apt-get install -y git

output "Checking depot_tools..."

if [ -d "depot_tools" ]; then
    cd depot_tools
    git reset --hard HEAD # in case anything was saved here
    git pull origin main
    cd ..
else
    # Install depot_tools
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi
# make them available for further build steps
export PATH="$PATH:$(pwd)/depot_tools"

output "Initializing depot_tools..."

# Explicitly ensure bootstrap
if [ -f "depot_tools/ensure_bootstrap" ]; then
    depot_tools/ensure_bootstrap
fi

gclient || (output "gclient initialization failed!" && exit 1)

output "All tools are installed and initialized"

echo "::endgroup::"

echo "::group::Fetch code"
# --- Now everything needed for the build should be installed

output "Getting ready to fetch code"

# Now start cloning
mkdir -p chromium && cd chromium

output "Even if this next command outputs errors, it might still work. The script will exit if not."

# This is the command that is used to initially fetch the source code
# It does not work if the repo has already been downloaded - which is why whe need the fallback option
fetch --no-history chromium || failed=1 && output "\"fetch\" failing doesn't matter.\nUsing \"gclient sync\" to download updates, repo likely has already been downloaded"
if [[ $failed -eq 1 ]]; then
  # fallback to sync command to get latest changes. If that one doesn't work, then we're out of luck
  # The -D flag removes any unused/unnecessary parts of the repository that are no longer needed
  gclient sync -D || (output "OK, running \"gclient sync\" also failed.\nYou should probably remove both the chromium/ and depot_tools/ directory and start over." && exit 1)
fi


cd src

output "Pulling..."

if [ -z "$CURRENT_BRANCH" ]; then
    CURRENT_BRANCH=main
fi

git pull origin "$CURRENT_BRANCH"

output "Done fetching code"

echo "::endgroup::"

echo "::group::Install additional build dependencies"

output "Installing additional build dependencies..."

# Install additional build dependencies
./build/install-build-deps.sh --no-prompt --no-syms --no-arm --no-nacl || true

echo "::endgroup::"

echo "::group::Run hooks"

output "Running preparation steps..."

# Run hooks
gclient runhooks

rm -rf out/Default || true

echo "::endgroup::"

echo "::group::Generate build files"

output "Generating build target..."

# Setting up the build: Generate required build files
gn gen out/Default --args='target_cpu="x64" target_os="linux" enable_nacl=false is_component_build=false is_debug=false blink_symbol_level=0'

echo "::endgroup::"

echo "::group::Build subresource_filter_tools"

output "Starting build..."

# Build subresource_filter_tools, as that's the part we're interested in
autoninja -C out/Default subresource_filter_tools

output "Finished build."

echo "::endgroup::"

cd ..
cd ..
