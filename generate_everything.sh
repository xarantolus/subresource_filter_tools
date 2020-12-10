set -e # exit on error

# Well, at first we want to build these tools
# This also downloads/syncs/updates the required repositories
./build_linux.sh

# copy all tools we need to the out/ directory
./copy_libs.sh

cd chromium/src
GIT_COMMIT=$(git rev-parse --short HEAD)
cd ../..

echo "chromium tag: $GIT_COMMIT" >> "out/chromium-version-$GIT_COMMIT"

# Now we zip that directory
cd out 

sha256sum -b * > ../SHA256SUMS

zip -9 -r "../subresource_filter_tools_linux-x64.zip" *
cd ..

# and remove it, as it's no longer needed
rm -rf out

# now the zip file and SHA256SUMS is ready to be released
