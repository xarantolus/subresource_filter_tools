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

# Get or update code
mkdir -p chromium && cd chromium

echo "Even if this next command outputs errors, it might still work. The script will exit if not."

# if it's not already done, we fetch the repository. 
# Fetching fails if we already downloaded it,
# Which is when we need sync to update to the latest code

fetch --nohooks --no-history chromium || gclient sync

output "Done fetching code"

cd src

output "Installing additional build dependencies..."

# Install additional build dependencies
./build/install-build-deps.sh

output "Running preparation steps..."

# Run hooks
gclient runhooks

rm -rf out/Default || true 

output "Generating build target..."

# Setting up the build: Generate required build files
gn gen out/Default --args='target_cpu="x64" target_os="linux" enable_nacl=false'

output "Starting build..."

# Build subresource_filter_tools, as that's the part we're interested in
autoninja -C out/Default subresource_filter_tools 

output "Finished build."

cd ..
cd ..
