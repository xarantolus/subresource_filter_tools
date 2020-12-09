# subresource_filter_tools
This is a repository for building the `subresource_filter_tools` part of the [The Chromium Project](https://www.chromium.org/Home).

Currently only builds for Linux x64 are supported. The `build_linux.sh` script runs without problems on [Ubuntu on WSL](https://ubuntu.com/wsl) though, which means that you could also run them on a Windows 10 machine.

### Scripts
* `build_linux.sh`: uses ninja to build `subresource_filter_tools`
* `copy_libs.sh`: copies binaries and required libraries to a directory called `out/`
* `generate_everything.sh`: runs the two scripts above and then packages the output into a zip file. If you want to build for yourself, start this one.

## Use-Case 
These tools allow generating custom ad block filters for browsers that support it, such as [Bromite](https://www.bromite.org/custom-filters) (Android).

## Why
I needed some of these tools for my related project, but couldn't find any recent precompiled binaries.
If you want some AdBlock filter lists for Bromite and possibly other browsers, see [that project](https://github.com/xarantolus/filtrite).

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
