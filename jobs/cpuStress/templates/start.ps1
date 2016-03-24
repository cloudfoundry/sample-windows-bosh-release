while ($true)
{
	Start-Sleep 30.0
	Write-Host "I am executing a job which will peg the CPU at 100%"
	
	foreach ($loopnumber in 1..2147483647) {$result=1;foreach ($number in 1..2147483647) {$result = $result * $number};$result}
}
