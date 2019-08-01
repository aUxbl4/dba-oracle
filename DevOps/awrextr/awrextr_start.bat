@echo off
<#
remoute export awrdump for windows
v 1.00
by korolkov.a.s
start parameter
awrextr_start.bat .profile.11204.test  /home/oracle 100100 100101   
or full
awrextr_start.bat .profile.11204.test  /home/oracle 
#>

powershell -Command $pword = read-host "Enter password" -AsSecureString ; ^
                $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword) ; ^
                               [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) > .tmp_pass%~1.txt
set /p password=<.tmp_pass%~1.txt & del .tmp_pass%~1.txt

pscp.exe -pw %password% .\awrextr_scripts\awrextr_script.sh %~1":"
echo . ./awrextr_script.sh %~2 %~3 %~4 %~5 
plink.exe -batch -ssh -pw %password% %~1 ". ./awrextr_script.sh %~2 %~3 %~4 %~5"  
pscp.exe -pw %password% %~1:%~3/awrextr*.zip .\awrextr_dmp\ 
echo rm awrextr*.zip
plink.exe -batch -ssh -pw %password% %~1 "rm awrextr*.zip" 

exit /B
