SET PAGESIZE 124
COL DB_NAME FORMAT A8
COL HOSTNAME FORMAT A12
COL LOG_ARCHIVED FORMAT 999999
COL LOG_APPLIED FORMAT 999999
COL LOG_GAP FORMAT 9999
COL APPLIED_TIME FORMAT A12
SELECT DB_NAME, HOSTNAME, LOG_ARCHIVED, LOG_APPLIED,APPLIED_TIME,
LOG_ARCHIVED-LOG_APPLIED LOG_GAP
FROM
(
SELECT NAME DB_NAME
FROM V$DATABASE
),
(
SELECT UPPER(SUBSTR(HOST_NAME,1,(DECODE(INSTR(HOST_NAME,'.'),0,LENGTH(HOST_NAME),
(INSTR(HOST_NAME,'.')-1))))) HOSTNAME
FROM V$INSTANCE
),
(
SELECT MAX(SEQUENCE#) LOG_ARCHIVED
FROM V$ARCHIVED_LOG WHERE DEST_ID=1 AND ARCHIVED='YES'
),
(
SELECT MAX(SEQUENCE#) LOG_APPLIED
FROM V$ARCHIVED_LOG WHERE DEST_ID=2 AND APPLIED='YES'
),
(
SELECT TO_CHAR(MAX(COMPLETION_TIME),'DD-MON/HH24:MI') APPLIED_TIME
FROM V$ARCHIVED_LOG WHERE DEST_ID=2 AND APPLIED='YES'
);