
echo "district:"

set /p dist=veuillez ecrire:

sqlldr district%dist%/district%dist%@MIG12C  direct=true  errors=2000  control=d.ctl  log=d.log

pause
