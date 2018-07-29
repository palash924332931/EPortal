
 insert into reportfieldlist values ( 219, 'packexception' , 'PROBE Pack Exception' ,'deliverables', null)
 insert into reportfieldlist values ( 220, 'probe' , 'PROBE Mfr' , 'deliverables',null)

 insert into reportfieldsbymodule values (2, 219, 2) 
 insert into reportfieldsbymodule values (2, 220, 2)

 delete from reportfieldsbymodule where moduleid = 2 and fieldid in (51,52)

 delete from reportfieldsbymodule where moduleid = 1 and fieldid in (8)
 insert into reportfieldsbymodule values (1,5,2)