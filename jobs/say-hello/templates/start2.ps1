while ($true)
{
	Start-Sleep 15.0
	Write-Host "I am executing a BOSH JOB 2, HOMIE!!!!!!!!!!!"
	Write-Host "Checking on my environment variable MyEnvVar1, as defined in the monitfile"
	Write-Host $env:MyEnvVar1
	Write-Host "now reporting on ALL environment variables:"
	Get-ChildItem Env:
}
