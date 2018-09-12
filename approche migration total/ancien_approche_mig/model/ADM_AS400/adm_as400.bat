echo "district:"

set /p dist=veuillez ecrire:

sqlldr district%dist%/district%dist%@MIG12C direct=true  errors=2000  control=adm_as400.ctl  log=adm_as400.log

pause
