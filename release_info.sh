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

echo "$ file subresource_indexing_tool"
file subresource_indexing_tool

echo 
echo 

echo "$ file subresource_filter_tool"
file subresource_filter_tool

echo 
echo 

echo "$ sha256sum -b * > SHA256SUMS"
echo -n "\`\`\`"
