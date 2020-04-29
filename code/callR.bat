@echo off 

set arg1=%1
REM set arg2=%2
REM set arg3=%3
REM set arg4=%4

cmd /c start /min Rscript E:\\NCHC\\project_small\\change_terminal_background\\code\\ver02_ver01_clean.R -t %arg1%

pause