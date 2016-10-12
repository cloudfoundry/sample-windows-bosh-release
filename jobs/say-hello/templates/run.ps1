cmd.exe /c 'reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /s'
Get-Content C:\windows\panther\unattendGC\*.log
Sart-Sleep -Seconds 10
Exit 0
