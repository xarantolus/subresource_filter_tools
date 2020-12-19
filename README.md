# subresource_filter_tools
This is a repository for building the `subresource_filter_tools` part of [The Chromium Project](https://www.chromium.org/Home).

Currently only builds for Linux x64 are supported. These scripts run without problems on [Ubuntu on WSL](https://ubuntu.com/wsl) though, which means that you can also run them on a Windows 10 machine.

You should run this on an SSD of sufficient size (because you'll end up with ~700k files that are ~22GB in size).

### Scripts
* `generate_everything.sh`: this is the script you want to run to build and package everything. At first it runs the install & build script, then copies all release files info a directory, which is then zipped. It automatically updates the code on subsequent builds and only creates a new release file if the build result changed. 
* `build_linux.sh`: installs all build tools (follows [this guide](https://chromium.googlesource.com/chromium/src/+/master/docs/linux/build_instructions.md)), then downloads the source code and builds `subresource_filter_tools`
* `copy_libs.sh`: copies binaries and their required libraries to an `out/` directory
* `release_info.sh`: generates the release info once the build finished

Please note that the initial download takes at least 30 minutes, the build is also quite slow. It might take about an hour or longer to download and build.

## Use-Case
These tools allow generating custom ad block filters for browsers that support it, such as [Bromite](https://www.bromite.org/custom-filters) (Android).

I needed some of these tools for my related project, but couldn't find any recent precompiled binaries.
If you want some AdBlock filter lists for Bromite and possibly other browsers, see [the `filtrite` project](https://github.com/xarantolus/filtrite).

## How to use
See [this page](https://chromium.googlesource.com/chromium/src.git/+/master/components/subresource_filter/FILTER_LIST_GENERATION.md) <sup>[GitHub Mirror](https://github.com/chromium/chromium/blob/master/components/subresource_filter/FILTER_LIST_GENERATION.md)</sup> to find out how to use these tools.

If you want to use them for Bromite, check out [this page](https://www.bromite.org/custom-filters) for a nice guide.

TL;DR:

	ruleset_converter --input_format=filter-list \
		--output_format=unindexed-ruleset \
		--input_files=easyprivacy.txt,easylist.txt \
		--output_file=filters.dat

## Download
You can either head over to the releases section of this repository or [click this direct link](https://github.com/xarantolus/subresource_filter_tools/releases/latest/download/subresource_filter_tools_linux-x64.zip) to get the latest release.

## License
The License applies to the files published in this repository.
It probably does **not** apply for releases, as they are a product of work others have done.
Also see the [Chromium license](https://chromium.googlesource.com/chromium/src/+/master/LICENSE)
