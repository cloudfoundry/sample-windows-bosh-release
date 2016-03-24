#[IO.File]::WriteAllLines('/var/vcap/sys/log/say-hello/pre-start.stdout.log', 'Hello from pre-start')
 
 Write-Host "Hello from pre-start WROTE"
 Write-Host "We expect this to show up in /var/vcap/sys/log/job-name/pre-start-stdout.log automatically"
 
 Exit 0