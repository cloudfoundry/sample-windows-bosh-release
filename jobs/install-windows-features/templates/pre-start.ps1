param (
   [switch]$quiet = $false,
   [switch]$version = $false
)

$Logfile = "C:\pre-start-time.log"

function LogWrite {
   Param ([string]$logstring)
   $now = Get-Date -format s
   Add-Content $Logfile -value "[$now] $logstring"
   Write-Host "[$now] $logstring"
}

if ($version) {
    Write-Host "Version 0.122"
    exit
}

LogWrite "Clearing error: start"
$Error.Clear()
LogWrite "Clearing error: done"

LogWrite "Start: Test-WSMan -ErrorAction SilentlyContinue"
if (![bool](Test-WSMan -ErrorAction SilentlyContinue)) {
  LogWrite "Start: Enable-PSRemoting -Force"
  Enable-PSRemoting -Force
  LogWrite "Done: Enable-PSRemoting -Force"
}
LogWrite "Done: Test-WSMan -ErrorAction SilentlyContinue"

# Failure case: 1
# This is taken from the pre-start script of the Garden-Windows job in
# the garden-windows-bosh-release.
#
Configuration CFWindows {
  Node "localhost" {

    WindowsFeature IISWebServer {
      Ensure = "Present"
        Name = "Web-Webserver"
    }
    WindowsFeature WebSockets {
      Ensure = "Present"
        Name = "Web-WebSockets"
    }
    WindowsFeature WebServerSupport {
      Ensure = "Present"
        Name = "AS-Web-Support"
    }
    WindowsFeature DotNet {
      Ensure = "Present"
        Name = "AS-NET-Framework"
    }
    WindowsFeature HostableWebCore {
      Ensure = "Present"
        Name = "Web-WHC"
    }

    WindowsFeature ASPClassic {
      Ensure = "Present"
      Name = "Web-ASP"
    }
  }
}

LogWrite "Start: Install-WindowsFeature DSC-Service"
Install-WindowsFeature DSC-Service
LogWrite "Done: Install-WindowsFeature DSC-Service"

LogWrite "Start: CFWindows"
CFWindows
LogWrite "Done: CFWindows"

LogWrite "Start: Start-DscConfiguration -Wait -Path .\CFWindows -Force -Verbose"
Start-DscConfiguration -Wait -Path .\CFWindows -Force -Verbose
LogWrite "Done: Start-DscConfiguration -Wait -Path .\CFWindows -Force -Verbose"

# Failure case: 2
#
# Essentially the same as above, but invokes Install-WindowsFeature directly
# instead of using Start-DscConfiguration.

# $RequiredFeatures = @("Web-WebServer","Web-WebSockets","AS-Web-Support","AS-NET-Framework","Web-WHC","Web-ASP")

# LogWrite "Start: Checking required features"
# foreach ($feature in $RequiredFeatures) {
#   LogWrite "Start: Getting feature: $feature"
#   if ((Get-WindowsFeature -Name $feature).InstallState -ne 'Installed') {
#     LogWrite "Start: Installing feature: $feature"
#     Install-WindowsFeature $feature
#     LogWrite "Done: Installing feature: $feature"
#   } else {
#     LogWrite "Feature already installed: $feature"
#   }
#   LogWrite "Done: Getting feature: $feature"
# }
# LogWrite "Done: Checking required features"

# # </Failure 2>

# if ($Error) {
#     LogWrite "There are errors!!!"
#     Write-Host "Error summary:"
#     LogWrite "Error summary:"
#     foreach($ErrorMessage in $Error)
#     {
#       Write-Host $ErrorMessage
#       LogWrite $ErrorMessage
#     }
# }

# LogWrite "Finished"
