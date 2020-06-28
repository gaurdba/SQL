SET LINES 300

COL owner FOR a30
COL object_name FOR a50
COL subobject_name FOR a50
col object_id for a20
SET VERIFY OFF
WITH obj AS (
    SELECT /*+ parallel(4) */
        current_obj#   object_id,
        COUNT(*) cnt
    FROM
        gv$active_session_history
    WHERE
        session_id = &1
        AND inst_id = &2
        AND session_serial# = &3
        AND sql_id = '&4'
    GROUP BY
        current_obj#
)
SELECT
    DECODE(TO_CHAR(obj.object_id),'0','Reading from Undo CurrObj#'||obj.object_id,obj.object_id) object_id,
    owner,
    object_name,
    subobject_name,
    obj.cnt
FROM
    dba_objects o,
    obj
WHERE
    o.object_id (+) = obj.object_id
ORDER BY
    cnt DESC;
