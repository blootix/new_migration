
echo "district:"

set /p dist=veuillez ecrire:

sqlldr district%dist%/district%dist%@MIG12C direct=true  errors=2000  control=f24_t_d.ctl  log=f24_t_d.log

pause