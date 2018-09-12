echo "district:"

set /p dist=veuillez ecrire:

sqlldr district%dist%/district%dist%@MIG12C direct=true  errors=2000  control=b2.ctl  log=b2.log

pause
