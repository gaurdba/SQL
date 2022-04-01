col start_exec for a20
col end_exec for a20
col session_id for 99999999
col inst_id for 9999
col sesssion_serial# for 999999999

SELECT
    to_char(MIN(sample_time), 'DD-Mon-YYYY HH24:MI:SS') start_exec,
    to_char(MAX(sample_time), 'DD-Mon-YYYY HH24:MI:SS') end_exec,
    session_id,
    inst_id,
    session_serial#,
    sql_id,
    MAX(temp_space_allocated / 1024 / 1024)             temp_mb
FROM
    gv$active_session_history
GROUP BY
    session_id,
    inst_id,
    session_serial#,
    sql_id
ORDER BY
    temp_mb DESC
FETCH FIRST 10 ROWS ONLY;
