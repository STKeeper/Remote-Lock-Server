🔒 远程锁屏服务器

一个轻量级的 PowerShell HTTP 服务器，让你可以通过局域网内的任何设备远程锁定 Windows 工作站。

PowerShell
Windows
License

English (http://readme.md/) | 中文

✨ 功能特点

• 🖱️ 浏览器一键锁屏
• 🌙 深色主题，适配移动端
• 📱 自动识别设备类型（iPhone、Android、Windows、Mac、Linux）
• 📝 记录每次锁屏的时间、IP、设备信息
• ⚡️ 零依赖，纯 PowerShell 实现

📋 系统要求

• Windows 10 / 11 / Server
• PowerShell 5.1+
• 管理员权限（HttpListener 需要）

🚀 快速开始

1. 克隆仓库：
git clone https://github.com/STKeeper/Remote-Lock-Server.git
cd Remote-Lock-Server
2. 以管理员身份运行：
powershell -ExecutionPolicy Bypass -File lock-server.ps1
3. 在同一局域网内的任意设备上打开浏览器：
http://<你的电脑IP>:9876
4. 点击 Lock Screen 🔒

⏰ 开机自启（可选）

通过计划任务实现：

$action = New-ScheduledTaskAction -Execute "powershell.exe" `
  -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File C:\Scripts\lock-server.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -TaskName "LockServer" -Action $action -Trigger $trigger -RunLevel Highest

📄 日志

操作记录保存在 lock-server.log：

2026-03-05 22:30:15 [LOCK] Time: 2026-03-05 22:30:15 | IP: 192.168.1.50 | Device: iPhone (...) | Result: SUCCESS | Count: #1

🔥 防火墙设置

如果其他设备无法访问，放行 9876 端口：

New-NetFirewallRule -DisplayName "Lock Server" -Direction Inbound -Port 9876 -Protocol TCP -Action Allow

📜 许可证

MIT

───