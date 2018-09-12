echo "district:"

set /p dist=veuillez ecrire:

sqlldr district%dist%/district%dist%@MIG12C direct=true  errors=2000  control=FBANQM.ctl  log=FBANQM.log

pause
