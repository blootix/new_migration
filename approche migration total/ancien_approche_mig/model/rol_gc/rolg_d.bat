
echo "district:"

set /p dist=veuillez ecrire:

sqlldr district%dist%/district%dist%@MIG12C  direct=true  errors=2000  control=rolg_d.ctl  log=rolg_d.log

pause
