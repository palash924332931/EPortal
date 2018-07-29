 for %%G in (*.sql) do sqlcmd /S SYDSSQL151T /d UACC_DF5_AU9 -U ECP_TDW -P ECP_TDW -i"%%G"
 pause

sqlcmd -i  ColumnCheck_TDWProduct.sql -o DeploymentQCResults.txt /S SYDSSQL151T /d UACC_DF5_AU9 -U ECP_TDW -P ECP_TDW 
pause