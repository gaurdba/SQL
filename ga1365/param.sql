col Parameter_Name for a37
set lines 350
col ISSES_MODIFIABLE for a12 head ISSes|MODIFIABLE
col ISSYS_MODIFIABLE for a12 head ISSYS|MODIFIABLE
col ISINSTANCE_MODIFIABLE for a12 head ISINSTANCE|MODIFIABL
col DESCRIPTION for a55 wrap
col DISPLAY_VALUE for a15
col db_name for a15
col value for a25
set pages 500
 select  instance_name,name Parameter_Name,value,DISPLAY_VALUE,ISSES_MODIFIABLE,ISSYS_MODIFIABLE,ISINSTANCE_MODIFIABLE,DESCRIPTION from gv$system_parameter p, gv$instance i where i.inst_id=p.inst_id and  lower(name) like nvl(lower('%&Parameter_Name%'),null) and value not like '%/%' order by Parameter_Name,p.inst_id;
set lines 120
