for %%G in (*.sql) do sqlcmd /S SYDSCLP100P /d EverestPortalDB -U ECPUser -P Ecp@123 -i"%%G"
 pause
sqlcmd /S SYDSCLP100P /d EverestPortalDB  -U ECPUser -P Ecp@123 -s, -W -Q "SELECT * FROM dbo.Qclog" > DeploymentQCResults.txt
 pause