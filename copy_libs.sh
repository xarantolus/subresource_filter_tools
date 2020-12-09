# We assume build.sh was run and all compiled files are in chromium/src/out/Default

set -e

move_libs() {
    # $1: executable path
    # $2: output directory path
    mkdir -p "$2"

    ldd "$1" | grep "=>" | awk '{print $3}' | grep "$(pwd)" | while read line ; do cp -u "$line" "$2" ; done

    cp -u "$1" "$2"
}

rm -rf out || true

move_libs chromium/src/out/Default/ruleset_converter out
move_libs chromium/src/out/Default/subresource_indexing_tool out
