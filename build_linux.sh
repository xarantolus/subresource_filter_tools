set -e # exit on error

output() {
    echo "--------------------------------------------------------------------------------"
    echo "$@"
    echo "--------------------------------------------------------------------------------"
}

# Basically follow https://chromium.googlesource.com/chromium/src/+/master/docs/linux/build_instructions.md

# --- At first, we want to have all tools installed

output "Start installing tools..."

# the "python" command, which must be python2, is needed for install-build-deps.sh
apt install -y python2 git # we also need git
alias python=python2 # this doesn't necessarily work for non-shell stuff
ln -sf "$(which python2)" /usr/bin/python # which is why we need this symlink

output "Checking depot_tools..."

if [ -d "depot_tools" ]; then
    cd depot_tools
    git reset --hard HEAD # in case anything was saved here
    git pull origin "$CURRENT_BRANCH" 
    cd ..
else
    # Install depot_tools
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi
# make them available for further build steps
export PATH="$PATH:$(pwd)/depot_tools"

output "All tools are installed"

# --- Now everything needed for the build should be installed

output "Getting ready to fetch code"

# Now start cloning
mkdir -p chromium && cd chromium

output "Even if this next command outputs errors, it might still work. The script will exit if not."

# This is the command that is used to initially fetch the source code
# It does not work if the repo has already been downloaded - which is why whe need the fallback option
fetch --nohooks --no-history chromium || failed=1 && output "\"fetch\" failing doesn't matter.\nUsing \"gclient sync\" to download updates, repo likely has already been downloaded" 
if [ $failed -eq 1 ]; then
  # fallback to sync command to get latest changes. If that one doesn't work, then we're out of luck
  # The -D flag removes any unused/unnecessary parts of the repository that are no longer needed
  gclient sync -D || (output "OK, running \"gclient sync\" also failed.\nYou should probably remove both the chromium/ and depot_tools/ directory and start over." && exit 1)
fi


output "Done fetching code"

cd src

output "Pulling..."
git pull

output "Installing additional build dependencies..."

# Install additional build dependencies
./build/install-build-deps.sh --no-prompt

output "Running preparation steps..."

# Run hooks
gclient runhooks

rm -rf out/Default || true 

output "Generating build target..."

# Setting up the build: Generate required build files
gn gen out/Default --args='target_cpu="x64" target_os="linux" enable_nacl=false is_component_build=false is_debug=false'

output "Starting build..."

# Build subresource_filter_tools, as that's the part we're interested in
autoninja -C out/Default subresource_filter_tools 

output "Finished build."

cd ..
cd ..
