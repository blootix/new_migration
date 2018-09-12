echo "district:"

set /p dist=veuillez ecrire:

sqlldr district%dist%/district%dist%@MIG12C direct=true  errors=2000  control=fabtrim22.ctl  log=fabtrim22.log

pause
