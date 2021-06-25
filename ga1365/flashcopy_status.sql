set line 200
col STANDBYDB format a30
col SYNC_STATUS format a20
col STANDBYDB_ROLE format a25
col START_SYNC_FLAG for a15
col STOP_SYNC_FLAG for a15
select * from PREF_OWNER.PREF_SYNC_FLAGS Where lower(STANDBYDB) like lower(nvl('%&STANDBYDB%',STANDBYDB));
