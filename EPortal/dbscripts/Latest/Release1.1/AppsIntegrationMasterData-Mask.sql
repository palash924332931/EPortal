UPDATE d 
SET d.mask = 1
FROM Deliverables d
join DeliveryReport dr on dr.DeliverableId = d.DeliverableId
join irp.Report r on r.VersionTo = 32767 and r.ReportID = dr.ReportID
join irp.ReportParameter rp on rp.ReportID = r.ReportID and rp.Code = 'mask' and rp.VersionTo = 32767