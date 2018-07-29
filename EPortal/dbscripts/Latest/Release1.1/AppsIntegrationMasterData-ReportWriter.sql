UPDATE r 
SET r.Description = w.WriterDescription
FROM ReportWriter r
join irp.Writer w on r.code = w.WriterCode