select * from ( select ss.value, sn.name, ss.sid
 from gv$sesstat ss, gv$statname sn
 where ss.statistic# = sn.statistic#
 and sn.name like '%opened cursors current%'
 order by value desc) where rownum < 11 ;