# Assumption: We now have subresource_filter_tools_windows-x64.zip and subresource_filter_tools_linux-x64.zip
# in the same directory as the script is run in

rm -rf out > /dev/null 2>&1

mkdir -p out/linux  > /dev/null 2>&1
unzip subresource_filter_tools_linux-x64.zip -d out/linux > /dev/null 2>&1
mkdir -p out/windows > /dev/null 2>&1
unzip subresource_filter_tools_windows-x64.zip -d out/windows > /dev/null 2>&1

cd out/linux

CHROMIUM_COMMIT="$(cat chromium-version-*)"

echo "This release provides prebuilt executables/binaries of \`ruleset_converter\`, \`subresource_filter_tool\` and \`subresource_indexing_tool\` for \`x64\`/\`x86-64\`/\`amd64\`."
echo "These tools were built from the [latest available chromium commit](https://chromium.googlesource.com/chromium/src/+/$CHROMIUM_COMMIT)."
echo "There are builds for both Linux and Windows in the respective zip files."
echo ""

echo "### Info for Linux: "

echo ""

echo "\`\`\`"

cd ../..
echo "$ unzip -l subresource_filter_tools_linux-x64.zip"
unzip -l subresource_filter_tools_linux-x64.zip
cd out/linux

echo 
echo 

echo "$ file ruleset_converter"
file ruleset_converter

echo 
echo 

echo "$ file subresource_filter_tool"
file subresource_filter_tool

echo 
echo 

echo "$ file subresource_indexing_tool"
file subresource_indexing_tool

echo 
echo 

echo "$ sha256sum -b * > SHA256SUMS"
echo -n "\`\`\`"

echo ""
echo ""

cd ../windows

echo "### Info for Windows: "

echo ""

echo "\`\`\`"

cd ../..
echo "$ unzip -l subresource_filter_tools_windows-x64.zip"
unzip -l subresource_filter_tools_windows-x64.zip
cd out/windows

echo 
echo 

echo "$ file ruleset_converter.exe"
file ruleset_converter.exe

echo 
echo 

echo "$ file subresource_filter_tool.exe"
file subresource_filter_tool.exe

echo 
echo 

echo "$ file subresource_indexing_tool.exe"
file subresource_indexing_tool.exe

echo ""
echo ""
