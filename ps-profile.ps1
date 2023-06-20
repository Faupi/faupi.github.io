$OH_MY_POSH_CACHED = "$env:POSH_THEMES_PATH\faupi-cached.omp.json"

curl https://faupi.net/faupi.omp.json > "$OH_MY_POSH_CACHED.dl" --silent --max-time 5
if($LASTEXITCODE -eq 0){
    # Copy the downloaded theme only if it was downloaded okay
    Copy-Item -Path "$OH_MY_POSH_CACHED.dl" -Destination "$OH_MY_POSH_CACHED"
}
oh-my-posh init pwsh --config "$OH_MY_POSH_CACHED" | Invoke-Expression

function gco { git checkout $args }
function gc { git commit $args }
function gs { git status $args }
function gd { git diff $args }
