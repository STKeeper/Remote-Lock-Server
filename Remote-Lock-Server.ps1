$logFile = "C:\Scripts\lock-server.log"
$lockCount = 0

function Write-Log($level, $msg) {
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$level] $msg"
    Add-Content -Path $logFile -Value $line
    Write-Host $line
}

function Send-Html($response, $html) {
    $response.ContentType = "text/html; charset=utf-8"
    $response.StatusCode = 200
    $body = [Text.Encoding]::UTF8.GetBytes($html)
    $response.OutputStream.Write($body, 0, $body.Length)
    $response.Close()
}

$style = "<style>body{font-family:system-ui;max-width:600px;margin:40px auto;padding:0 20px;background:#1a1a2e;color:#eee}.card{background:#16213e;border-radius:12px;padding:24px;margin:20px 0;box-shadow:0 4px 6px rgba(0,0,0,.3)}.success{border-left:4px solid #0f0}.label{color:#888;font-size:13px;margin-bottom:4px}.value{font-size:16px;margin-bottom:16px}h1{text-align:center;font-size:28px}.count{text-align:center;color:#888;font-size:14px}a{display:inline-block;margin-top:40px;padding:20px 48px;background:#e94560;color:#fff;text-decoration:none;border-radius:12px;font-size:22px;font-weight:bold}a:active{background:#c0392b}.info{color:#888;margin-top:30px;font-size:13px}.center{text-align:center}</style>"
$head = '<!DOCTYPE html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Lock Server</title>' + $style + '</head><body>'

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://+:9876/")
$listener.Start()
Write-Log "INFO" "Lock server started on port 9876 (PID: $PID) | Host: $env:COMPUTERNAME | User: $env:USERNAME"

while ($true) {
    $context = $listener.GetContext()
    $req = $context.Request
    $path = $req.Url.AbsolutePath
    $ip = $req.RemoteEndPoint.Address
    $ua = $req.UserAgent

    $device = switch -Regex ($ua) {
        "iPhone"  { "iPhone"; break }
        "iPad"    { "iPad"; break }
        "Android" { "Android"; break }
        "Windows" { "Windows PC"; break }
        "Mac"     { "Mac"; break }
        "Linux"   { "Linux"; break }
        default   { "Unknown" }
    }

    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $response = $context.Response

    if ($path -eq "/lock") {
        $lockCount++
        $result = "SUCCESS"
        try {
            rundll32.exe user32.dll,LockWorkStation
        } catch {
            $result = "FAILED: $_"
        }

        $logMsg = "Time: $time | IP: $ip | Device: $device ($ua) | Result: $result | Count: #$lockCount"
        Write-Log "LOCK" $logMsg

        $html = $head + "<h1>&#128274; Locked!</h1><div class='card success'>"
        $html += "<div class='label'>Time</div><div class='value'>$time</div>"
        $html += "<div class='label'>Source IP</div><div class='value'>$ip</div>"
        $html += "<div class='label'>Device</div><div class='value'>$device</div>"
        $html += "<div class='label'>Result</div><div class='value'>$result</div>"
        $html += "</div><div class='count'>Total locks: #$lockCount</div></body></html>"
        Send-Html $response $html
    } else {
        Write-Log "REQ" "Time: $time | IP: $ip | Device: $device | Path: $path (ignored)"

        $html = $head + "<div class='center'><h1>&#128421; Lock Server</h1>"
        $html += "<a href='/lock'>Lock Screen</a>"
        $html += "<div class='info'>$env:COMPUTERNAME | Port 9876</div></div></body></html>"
        Send-Html $response $html
    }
}
