col owner for a20
col CONSTRAINT_NAME for a30
col CONSTRAINT_TYPE for a12 head CONSTRAINT|TYPE
col table_name for a30
col SEARCH_CONDITION for a40
col R_OWNER for a30
col R_CONSTRAINT_NAME for a30
set lines 300 pages 100
col index_name for a25
col COLUMN_NAME for a25

SELECT
    cons.owner,
    cons.constraint_name,
    constraint_type,
    cons.table_name,
    search_condition,
    column_name,
    status,
    index_name
FROM
    dba_constraints  cons,
    dba_cons_columns col
WHERE
        cons.constraint_name = col.constraint_name
    AND cons.owner = col.owner
        AND cons.owner = '&Owner'
            AND cons.table_name = '&table_name'
ORDER BY
    constraint_name;