# See https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/windows_build_instructions.md for the guide on what this does

Write-Output "::group::Init"

$WorkflowStartDir = (Get-Location).Path

# The C:\ drive has about 80 GB, the D: drive (default) only 12. We need about 25 GB, so we switch over
Set-Location C:\
function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    $out = (Join-Path $parent $name)
    return (New-Item -ItemType Directory -Path $out).FullName
}

Write-Output "::endgroup::"

Write-Output "::Installing Visual Studio Components"

Start-Process -Wait -NoNewWindow -FilePath cmd -ArgumentList "/c", '"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe"', "--add", "Microsoft.VisualStudio.Workload.NativeDesktop", "--add", "Microsoft.VisualStudio.Component.VC.ATLMFC", "--includeRecommended", "--includeOptional", "--passive", "--locale", "en-US"

Write-Output "::group::Install depot_tools"

$url = "https://storage.googleapis.com/chrome-infra/depot_tools.zip"
$zipName = "depot_tools.zip"

$targetDir = New-TemporaryDirectory

Write-Output "Created $targetDir for depot_tools"

# Download & unzip the file
# If we don't disable the progress bar, the download literally takes five minutes. If we disable it, it takes a second... WTF is going on Microsoft?
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $Url -OutFile $zipName -UseBasicParsing
Expand-Archive -Path $zipName -DestinationPath $targetDir

# Add depot_tools to $PATH, at least for this process
$ENV:Path = $targetDir + ";" + $ENV:Path

Write-Output "Finished downloading depot_tools"

Write-Output "::endgroup::"

Write-Output "::group::Set up gclient"

Write-Output "Let gclient download its dependencies on the first run"
Start-Process -Wait -NoNewWindow -FilePath cmd -ArgumentList "/c", "gclient"

# Make sure we have valid git settings
$gitMail = (git config --global user.email) | Out-String
if ($gitMail.Trim().Length -eq 0) {
    Write-Output "Setting up default git credentials"
    git config --global user.name "GitHub Actions"
    git config --global user.email "github-actions@github.com"    

    git config --global core.autocrlf false
    git config --global core.filemode false
    git config --global branch.autosetuprebase always
}


# Set variables as said in the guide          
$ENV:DEPOT_TOOLS_WIN_TOOLCHAIN = '0'
$ENV:vs2019_install = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise"

Write-Output "::endgroup::"

Write-Output "::group::Fetch chromium code"

Write-Output "Creating chromium directory"

New-Item -ItemType Directory -Force chromium
Set-Location chromium

Write-Output "Fetching chromium code"
fetch --no-history chromium

Set-Location src

Write-Output "::endgroup::"

Write-Output "::group::Run hooks"

New-Item -ItemType Directory -Force out/Default

Write-Output "Download more dependencies"
Start-Process -Wait -NoNewWindow -FilePath cmd -ArgumentList "/c", "gclient", "sync"

Write-Output "Run hooks"
Start-Process -Wait -NoNewWindow -FilePath cmd -ArgumentList "/c", "gclient", "runhooks"

Write-Output "::endgroup::"

Write-Output "::group::Generate build files"

Write-Output "Generating build files"

# First of all, we copy our args.gn file there
New-Item -Path out -Force -ItemType Directory
New-Item -Path out/Default -Force -ItemType Directory
Copy-Item "$WorkflowStartDir/args.gn" "out/Default/args.gn"

gn gen out/Default

Write-Output "::endgroup::"

Write-Output "::group::Build subresource_filter_tools"

autoninja -C out/Default subresource_filter_tools

Write-Output "::endgroup::"

Write-Output "::group::Generating release zip file"

Set-Location out/Default

$GIT_COMMIT = [string](git rev-parse HEAD).Trim()
$GIT_COMMIT_SHORT = [string](git rev-parse --short HEAD).Trim()

Write-Output "$GIT_COMMIT" > "chromium-version-$GIT_COMMIT_SHORT"

# Create ZIP file in workflow directory
Compress-Archive -Path ruleset_converter.exe, subresource_filter_tool.exe, subresource_indexing_tool.exe, "chromium-version-$GIT_COMMIT_SHORT" -DestinationPath "$WorkflowStartDir/subresource_filter_tools_windows-x64.zip"

Write-Output "::endgroup::"

Write-Output "::group::List chromium output directory"

Get-ChildItem -Recurse | Foreach-Object FullName

Write-Output "::endgroup::"
