# subresource_filter_tools
This is a repository for building the `subresource_filter_tools` part of [The Chromium Project](https://www.chromium.org/Home).

Currently supported are builds for both Linux and Windows on the x64 architecture. These scripts also run without problems on [Ubuntu on WSL](https://ubuntu.com/wsl), which means that you can also run both the Windows and Linux part on a Windows 10 machine.

You should run this on a SSD of sufficient size (because you'll end up with ~700k files that are ~22GB in size *per OS*, so basically twice that).

### Scripts for Linux
* `generate_everything.sh`: this is the script you want to run to build and package everything. At first it runs the install & build script, then copies all release files into a directory, which is then zipped. It automatically updates the code on subsequent builds and only creates a new release file if the build result changed. 
* `build_linux.sh`: installs all build tools (follows [this guide](https://chromium.googlesource.com/chromium/src/+/master/docs/linux/build_instructions.md)), then downloads the source code and builds `subresource_filter_tools`
* `copy_libs.sh`: copies binaries and their required libraries to an `out/` directory
* `release_info.sh`: generates the release info once the build finished

### Scripts for Windows
* `build_windows.ps1`: This scripts clones Chromium, installs dependencies and builds everything that's needed. Then it creates a release zip file. Please note that this script might do **PERMANENT CHANGES TO YOUR SYSTEM ENVIRONMENT**, so run it in a virtual machine or some other way to prevent it from doing so. Or just run it in GitHub Actions, which is what this script was made for

Please note that in both cases the initial download takes at least 30 minutes. The build is also quite slow. It might take about an hour or longer to download and build.

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
You can either head over to the releases section of this repository or [click this direct link for Linux](https://github.com/xarantolus/subresource_filter_tools/releases/latest/download/subresource_filter_tools_linux-x64.zip) or [this direct link for Windows](https://github.com/xarantolus/subresource_filter_tools/releases/latest/download/subresource_filter_tools_windows-x64.zip) to get the latest release.

These releases are built by GitHub Actions every week, so they should be up to date.

## License
The License applies to the files published in this repository.
It probably does **not** apply for releases, as they are a product of work others have done.
Also see the [Chromium license](https://chromium.googlesource.com/chromium/src/+/master/LICENSE)
