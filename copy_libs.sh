# We assume build.sh was run and all compiled files are in chromium/src/out/Default

set -e

move_libs() {
    # $1: executable path
    # $2: output directory path
    mkdir -p "$2"

   # Since these binaries are linked dynamically, we need to include all
    # their dependencies in our release directory.
    # So now we search for all of these files and also copy them
    ldd "$1" | grep "=>" | awk '{print $3}' | grep "$(pwd)" | while read line ; do cp -u "$line" "$2" ; done

    # Add the executable to the release directory
    cp -u "$1" "$2"
}

# clear previous release, if present
rm -rf out || true

# copy all required files to out
# once for ruleset_converter, once for subresource_indexing_tool and once for subresource_filter_tool
move_libs chromium/src/out/Default/ruleset_converter out
move_libs chromium/src/out/Default/subresource_indexing_tool out
move_libs chromium/src/out/Default/subresource_filter_tool out
