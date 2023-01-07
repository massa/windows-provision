# install adk
$artifactUrl = 'https://download.microsoft.com/download/0/1/C/01CC78AA-B53B-4884-B7EA-74F2878AA79F/adk/adksetup.exe' # v1809
$artifactPath = "$env:TEMP\$(Split-Path -Leaf $artifactUrl)"

Write-Host 'Downloading the Windows Assessment and Deployment Kit (ADK) setup...'
(New-Object System.Net.WebClient).DownloadFile($artifactUrl, $artifactPath)

Write-Host 'Installing the ADK Deployment Tools...'
&$artifactPath /quiet /features OptionId.DeploymentTools | Out-String -Stream

Write-Host 'Creating the Windows System Image Manager shortcut in the Desktop...'
Import-Module C:\ProgramData\chocolatey\helpers\chocolateyInstaller.psm1
Install-ChocolateyShortcut `
    -ShortcutFilePath "$env:USERPROFILE\Desktop\Windows System Image Manager.lnk" `
    -TargetPath 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\WSIM\imgmgr.exe'

# install carbon.
choco install -y carbon
Import-Module Carbon

# install git and related applications.
choco install -y git --params '/GitOnlyOnPath /NoAutoCrlf /SChannel'
choco install -y gitextensions
choco install -y meld

# update $env:PATH with the recently installed Chocolatey packages.
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Update-SessionEnvironment

# configure git.
# see http://stackoverflow.com/a/12492094/477532
git config --global user.name 'Humberto Massa'
git config --global user.email 'humbertomassa@gmail.com'
git config --global http.sslbackend schannel
git config --global push.default simple
git config --global core.autocrlf false
git config --global core.longpaths true
git config --global diff.guitool meld
git config --global difftool.meld.path 'C:/Program Files (x86)/Meld/Meld.exe'
git config --global difftool.meld.cmd '\"C:/Program Files (x86)/Meld/Meld.exe\" \"$LOCAL\" \"$REMOTE\"'
git config --global merge.tool meld
git config --global mergetool.meld.path 'C:/Program Files (x86)/Meld/Meld.exe'
git config --global mergetool.meld.cmd '\"C:/Program Files (x86)/Meld/Meld.exe\" \"$LOCAL\" \"$BASE\" \"$REMOTE\" --auto-merge --output \"$MERGED\"'

winget install --id Microsoft.Powershell --source winget
winget install Microsoft.DotNet.SDK.7
dotnet tool install --global wix --version 4.0.0-rc.1
