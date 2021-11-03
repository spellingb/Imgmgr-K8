$here = (Get-Location).Path

if ((Get-Command -Name 'git' -CommandType Application -ErrorAction SilentlyContinue).Count -gt 0) {
    $gitTopLevel = & { git rev-parse --show-toplevel 2> $null }
    if ($gitTopLevel.Length -ne 0) {
        $gitBranch = (git branch | Where-Object { $_ -match "\*" }).Trimstart('* ')
        if ( $gitBranch -match 'Master' ) {
            $subfolder = 'common'
        } else {
            $subfolder = $gitBranch.TrimStart('ENV-')
        }
    }
}
$config = '{0}\config' -f $here, $subfolder
if ( Test-Path $config ) {
    $ENV:KUBECONFIG="{0};{1}" -f  $ENV:KUBECONFIG, $config
}


