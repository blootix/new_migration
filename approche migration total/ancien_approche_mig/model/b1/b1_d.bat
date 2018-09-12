echo "district:"

set /p dist=veuillez ecrire:

sqlldr district%dist%/district%dist%@MIG12C  direct=true  errors=2000  control=b1_d.ctl  log=b1_d.log

pause
