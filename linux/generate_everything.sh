echo "::group::Setup"
set -e # exit on error

chmod +x *.sh

echo "::endgroup::"

# Well, at first we want to build these tools
# This also downloads/syncs/updates the required repositories
./build_linux.sh

echo "::group::Pack release"
# copy all tools we need to the out/ directory
./copy_libs.sh

cd chromium/src
GIT_COMMIT_SHORT=$(git rev-parse --short HEAD)
GIT_COMMIT=$(git rev-parse HEAD)
cd ../..

# Rename old SHA file (if present)
mv "SHA256SUMS" "SHA256SUMS.old" 2>&1 > /dev/null || true
trap "rm SHA256SUMS.old || true" EXIT

# Now we zip that directory
cd out 

# We definitely want to remove the out directory, no matter what
trap "rm -rf out" EXIT

# create the new SHA file - sort by filename
sha256sum -b * | sort -k2 > ../SHA256SUMS

# Compare to last SHA file to the current one 
# see https://stackoverflow.com/a/63976250

if cmp --silent -- "../SHA256SUMS" "../SHA256SUMS.old"; then
    echo "----------------------------------------------------------------------------------"
    echo "| This build has the exact same hashes as the last one.                          |"
    echo "| This means that there were no changes and there's no need to create a release. |"
    echo "----------------------------------------------------------------------------------"

    echo "::endgroup::"
    cd ..
    exit 0
else
  # We either had an error (because the file doesn't exist) or because they were different. Either way, we create the release

  ../test.sh

  # Start off by renaming an old release zip file
  mv "../subresource_filter_tools_linux-x64.zip" "../subresource_filter_tools_linux-x64.zip.old" 2>&1 > /dev/null || true

  # Write the current tag to a file
  echo "$GIT_COMMIT" > "chromium-version-$GIT_COMMIT_SHORT"

  echo "Generating release zip file..."
  # Zip all files in the out directory
  zip -9 -r "../subresource_filter_tools_linux-x64.zip" *

  ../release_info.sh > "../release.md"

  cd ..
  
  if [ "$RELEASE" == "true" ]
  then
    gh release create "$(date +%F-%H-%M)" -t "Automated build" -F "release.md" "subresource_filter_tools_linux-x64.zip" "SHA256SUMS"
  fi
fi

# now the zip file and SHA256SUMS is ready to be released
echo "::endgroup::"
