set heading off
spool oem_clean_alert.sql
select  'exec sysman.em_severity.delete_current_severity(''' ||
t.target_guid || ''',''' ||
metric_guid || ''',''' ||
key_value || ''')' em_severity
from sysman.mgmt_targets t
inner join
sysman.mgmt_current_severity s
on
t.target_guid = s.target_guid ;

spool off
@oem_clean_alert.sql
commit;
set heading on
