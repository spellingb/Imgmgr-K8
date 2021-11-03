[CmdletBinding()]
param (
    [Parameter()]
    [string]
    [ValidateSet('dev','prod')]
    $environment
)
$here = (Get-Location).Path
if ($environment){
    $subfolder = $environment
} else {
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
}
$config = '{0}\.kube\{1}\kubeconfig_top-lab15-capstone-{1}' -f $here, $subfolder
if ( Test-Path $config ) {
    if($ENV:KUBECONFIG){
        $ENV:KUBECONFIG="{0};{1}" -f  $ENV:KUBECONFIG, $config
    }else {
        $ENV:KUBECONFIG= $config
    }
}


