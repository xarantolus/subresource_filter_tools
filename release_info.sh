CHROMIUM_COMMIT="$(cat chromium-version-*)"

echo "This release provides prebuilt executables of \`ruleset_converter\`, \`subresource_filter_tool\` and \`subresource_indexing_tool\` for \`x64\`/\`x86-64\`/\`amd64\`."
echo "These tools were built from the [latest available chromium commit](https://chromium.googlesource.com/chromium/src/+/$CHROMIUM_COMMIT)."

echo ""

echo "\`\`\`"

cd ..
echo "$ unzip -l subresource_filter_tools_linux-x64.zip"
unzip -l subresource_filter_tools_linux-x64.zip
cd out

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
