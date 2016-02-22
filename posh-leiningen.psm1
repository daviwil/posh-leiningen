$PSModule = $ExecutionContext.SessionState.Module
$PSModuleRoot = $PSModule.ModuleBase
$leinBatPath = "$PSModuleRoot\lein.bat"

function Update-Leiningen
{
    # Remove an existing lein.bat
    rm -Force $leinBatPath -ErrorAction SilentlyContinue

    # Download the current version of lein.bat
    $webClient = New-Object System.Net.WebClient
    $downloadUrl = "https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein.bat"
    $webClient.DownloadFile($downloadUrl, $leinBatPath)
}

function Invoke-Leiningen {
    [CmdletBinding()]
    param(
        [ValidateSet(
            "change",
            "check",
            "clean",
            "classpath",
            "compile",
            "deploy",
            "deps",
            "do",
            "help",
            "install",
            "jar",
            "javac",
            "new",
            "plugin",
            "pom",
            "release",
            "repl",
            "retest",
            "run",
            "search",
            "show-profiles",
            "test",
            "trampoline",
            "uberjar",
            "update-in",
            "upgrade",
            "vcs",
            "version",
            "with-profile",
            "figwheel" <# Need a way to dynamically scrape available commands and use TabExpansion++ #>)]
        $Command,

        [Parameter(ValueFromRemainingArguments = $true)]
        $args
    )

    process {
        & $leinBatPath $Command @args
    }
}

# Ensure that lein.bat has been downloaded
if (![System.IO.File]::Exists($leinBatPath))
{
    Write-Verbose "Downloading lein.bat from GitHub..."

    Update-Leiningen

    Write-Verbose "Download complete.`r`n"
}

Set-Alias lein Invoke-Leiningen