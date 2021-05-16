# --- Chia Inputs --------------------------------------------------------------------------------------------------------------------------------------------
# --- Documentation: https://github.com/Chia-Network/chia-blockchain/wiki/CLI-Commands-Reference#create ------------------------------------------------------
$memoryBufferSize =         '4000'
$farmerPublicKey =          ''
$poolPublicKey =            ''
$fingerprint =              ''
$tmpDir =                   'C:\Chia\temp'
$tmp2Dir =                  'C:\Chia\temp2'
$finalDir =                 'C:\Chia\final'

# --- Pushover Inputs (optional) ----------------------------------------------------------------------------------------------------------------------------
$pushoverUserKey =          ''
$pushoverApiTokenKey =      ''

# --- Functions ----------------------------------------------------------------------------------------------------------------------------------------------
function CreateDirectoryIfNotExist
{
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Path
    )

    if (!(Test-Path $Path))
    {
        New-Item -ItemType 'Directory' -Path $Path
    }
}

function CleanUpDirectory
{
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Path
    )

    if (Test-Path $Path)
    {
        foreach ($file in Get-ChildItem -Path $Path)
        {
            Remove-Item -Path $file.FullName -Force -ErrorAction 'SilentlyContinue'
        }
    }
}

function GetLatestChiaPath
{
    $chiaPath = $env:LOCALAPPDATA
    $chiaPath = Join-Path $chiaPath 'chia-blockchain'
    
    foreach ($dir in Get-ChildItem -Path $chiaPath -Directory)
    {
        if ($dir.Name -cmatch '^app-[0-9.]+$')
        {
            $chiaPath = $dir.FullName
        }
    }

    return $chiaPath
}

function SendPushoverMessage
{
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Title,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $Message
    )

    $parameters = @{}
    $parameters.Add('token', $pushoverUserKey)
    $parameters.Add('user', $pushoverApiTokenKey)
    $parameters.Add('title', $Title)
    $parameters.Add('message', $Message)
    
    $null = Invoke-RestMethod -Uri 'https://api.pushover.net/1/messages.json' -Method 'POST' -Body $parameters -ContentType 'application/x-www-form-urlencoded' -TimeoutSec 5
}

# --- Main spawn point  --------------------------------------------------------------------------------------------------------------------------------------
# Create directories
CreateDirectoryIfNotExist -Path $tmpDir
CreateDirectoryIfNotExist -Path $tmp2Dir
CreateDirectoryIfNotExist -Path $finalDir

# Clean up temporary directories
CleanUpDirectory -Path $tmpDir
CleanUpDirectory -Path $tmp2Dir

# Get and set chia.exe path
$latestChiaPath = GetLatestChiaPath
$exeFilePath = Join-Path $latestChiaPath 'resources\app.asar.unpacked\daemon'
$exeName = 'chia.exe'

Set-Location $exeFilePath
$exeFullPath = Join-Path $exeFilePath $exeName

# Create plot
$chiaArgs = @(
    'plots', `
    'create', `
    '-k 32', `
    '-n 1', `
    "-b $memoryBufferSize", `
    "-f $farmerPublicKey", `
    "-p $poolPublicKey", `
    "-a $fingerprint", `
    "-t $tmpDir", `
    "-2 $tmp2Dir", `
    "-d $finalDir", `
    '-r 2', `
    '-u 128' `
    )

Start-Process -FilePath $exeFullPath -ArgumentList $chiaArgs -Wait -NoNewWindow -PassThru

# Send pushover finish message
if ($pushoverUserKey -cmatch '^[a-z0-9]+$' -and $pushoverApiTokenKey -cmatch '^[a-z0-9]+$')
{
    $title = (Get-CimInstance -ClassName Win32_ComputerSystem).Name
    $message = 'CHIA plotting finished'

    SendPushoverMessage -Title $title -Message $message
}

# Wait for user to close the powershell window
Write-Host -NoNewLine 'Press ESC to exit ...'
Do 
{
    $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
} 
While ( $key.Character -ne [ConsoleKey]::Escape )