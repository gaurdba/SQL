SELECT  NVL (username, 'SYS-BKGD') username, sess.SID, SUM (VALUE) sess_mem
    FROM v$session sess, v$sesstat stat, v$statname NAME
   WHERE sess.SID = stat.SID
     AND stat.statistic# = NAME.statistic#
     AND NAME.NAME LIKE 'session % memory'
GROUP BY username, sess.SID,rownum
ORDER BY sess_mem Desc
/
