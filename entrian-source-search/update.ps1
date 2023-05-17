import-module au
$releases = 'https://entrian.com/blog/category/ChangeLog/feed/'
$pkgUrl   = 'https://entrian.com/source-search/Entrian-Source-Search-VERSION-Setup.exe'

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.Url32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }

        ".\legal\VERIFICATION.txt" = @{
          "(?i)(^\s*latest:).*"   = "`${1} $($Latest.Url32)"
          "(?i)(^\s*checksum:).*" = "`${1} $($Latest.Checksum32)"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regex = ([xml]$download_page.Content).rss.channel.item.title | Select-String -Pattern "Entrian Source Search ([0-9.]+):.*"
    $version = $regex.Matches.Groups[1].Value

    return @{
        Url32 = $pkgUrl.Replace("VERSION",$version)
        Version = $version
    }
}

try {
  update -ChecksumFor 32
}
catch {
  if ($_ -match 'Could not establish trust relationship') {
    "ignore"
  }
  else { throw $_ }
}