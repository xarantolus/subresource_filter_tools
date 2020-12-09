./build_linux.sh

./copy_libs.sh


cd out 
zip -9 -r "../subresource_filter_tools_linux-x64.zip" *
cd ..

rm -rf out
