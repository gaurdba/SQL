selec session_id,inst_id,session_serial#,sql_id,max(PGA_ALLOCATED/1024/1024) PGA_Usage_MB
FROM
    gv$active_session_history
WHERE
    sample_time BETWEEN TO_DATE('&StartTime', 'DD-Mon-YYYY HH24:MI') AND TO_DATE('&EndTime', 'DD-Mon-YYYY HH24:MI')
    AND pga_allocated IS NOT NULL
GROUP BY
    session_id,
    inst_id,
    session_serial#,
    sql_id order by PGA_Usage_MB desc fetch first 10 rows only;
