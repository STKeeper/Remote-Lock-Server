🔒 Remote Lock Server

A lightweight PowerShell HTTP server that lets you remotely lock your Windows workstation from any device on your network.

PowerShell
Windows
License

English | 中文

✨ Features

• 🖱️ One-tap screen lock via web browser
• 🌙 Clean, dark-themed mobile-friendly UI
• 📱 Auto-detects device type (iPhone, Android, Windows, Mac, Linux)
• 📝 Logs every lock event with timestamp, IP, and device info
• ⚡️ Zero dependencies — pure PowerShell

📋 Requirements

• Windows 10 / 11 / Server
• PowerShell 5.1+
• Administrator privileges (required for HttpListener)

🚀 Quick Start

1. Clone this repo:
git clone https://github.com/STKeeper/Remote-Lock-Server.git
cd Remote-Lock-Server
2. Run as Administrator:
powershell -ExecutionPolicy Bypass -File lock-server.ps1
3. Open a browser on any device in the same network:
http://<YOUR_PC_IP>:9876
4. Tap Lock Screen 🔒

⏰ Auto-Start (Optional)

Run on login via scheduled task:

$action = New-ScheduledTaskAction -Execute "powershell.exe" `
  -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File C:\Scripts\lock-server.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -TaskName "LockServer" -Action $action -Trigger $trigger -RunLevel Highest

📄 Logs

All events are logged to lock-server.log:

2026-03-05 22:30:15 [LOCK] Time: 2026-03-05 22:30:15 | IP: 192.168.1.50 | Device: iPhone (...) | Result: SUCCESS | Count: #1

🔥 Firewall

Allow port 9876 if other devices can't connect:

New-NetFirewallRule -DisplayName "Lock Server" -Direction Inbound -Port 9876 -Protocol TCP -Action Allow

📜 License

MIT

───