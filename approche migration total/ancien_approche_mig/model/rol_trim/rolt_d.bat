
echo "district:"

set /p dist=veuillez ecrire:

sqlldr district%dist%/district%dist%@MIG12C  direct=true  errors=2000  control=rolt_d.ctl  log=rolt_d.log

pause
