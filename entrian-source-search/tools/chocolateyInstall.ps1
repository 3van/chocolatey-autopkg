$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:chocolateyPackageName
  fileType      = 'exe'
  url           = 'https://entrian.com/source-search/Entrian-Source-Search-1.8.4-Setup.exe'
  checksum      = '20794051C3900D065C97221478438C0925AAC66BC7EAC2AFF636A801A9652CC6'
  checksumType  = 'sha256'
  silentArgs    = "/SILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).InnoInstall.log`""
  validExitCodes= @(0)
  softwareName  = 'Entrian Source Search*'
}

$pp = Get-PackageParameters
if ($pp.UseInf) {
  if (Test-Path "$($pp.UseInf)") {
    Write-Host "Using existing configuration file at '$($pp.UseInf)'"
    $packageArgs['silentArgs'] = "$($packageArgs['silentArgs']) /LOADINF=`"$($pp.UseInf)`""
  }
  else {
    Write-Host "Creating new configuration file at '$($pp.UseInf)'"
    $packageArgs['silentArgs'] = "$($packageArgs['silentArgs']) /SAVEINF=`"$($pp.UseInf)`""
  }
}

Install-ChocolateyPackage @packageArgs
