set doc off
set timing off
set echo off
set scan on
set lines 180
set pages 1001
set verify off
set feedback off
variable name varchar2(30)
variable context number
variable schema varchar2(30)
variable table_name varchar2(30)
variable part2 varchar2(30)
variable dblink varchar2(30)
variable part1_type number
variable object_number number
whenever sqlerror exit 1
exec :name:='&1'
--select :name argument_received FROM dual;

-- resolve the name to schema.table
-- set autoprint on
begin
	DBMS_UTILITY.NAME_RESOLVE (
		name => :name,
		context => 2, -- context 2: works for schema.table, schema.synonym, queue, view
		schema => :schema,
		part1 => :table_name,
		part2 => :part2,
		dblink => :dblink,
		part1_type => :part1_type,
		object_number => :object_number
	);
	exception when others then
		raise_application_error(-20000, 'Usage: sqlplus -s <username> @statistics [schema_name.]object_name', true);
end;
/
-- get number of blocks in segment as an indication of how current object statistics are
variable segment_blocks number
begin
	/* this workaround is necessary, since there is no view ALL_SEGMENTS
	1. try DBA_SEGMENTS, if it fails
	2. try USER_SEGMENTS
	*/
	:segment_blocks:=NULL;
	begin
		execute immediate '
		SELECT blocks 
		FROM dba_segments 
		WHERE owner=:schema
		AND segment_name=:table_name'
		INTO :segment_blocks USING IN :schema, IN :table_name;
	EXCEPTION WHEN OTHERS THEN
		null;
	end;
	IF :segment_blocks IS NULL THEN
		begin
			-- user executing this script might have a table by the same name. 
			-- Join with all_objects makes sure
			-- that blocks for the right segment are retrieved
			-- if run neither with SELECT_CATALOG_ROLE nor as owner of the table
			-- then :segment_blocks remains NULL
			execute immediate '
			SELECT blocks 
			FROM user_segments s, all_objects ao, user_objects uo
			WHERE ao.owner=:schema
			AND s.segment_name=uo.object_name
			AND ao.object_id=uo.object_id
			AND ao.object_type=''TABLE''
			AND s.segment_name=:table_name'
			INTO :segment_blocks USING IN :schema, IN :table_name;
		EXCEPTION WHEN OTHERS THEN
			null;
		end;
	end if;
end;
/
variable host_name VARCHAR2(64)
begin
	/* this workaround is necessary, since the database user running this script may not have SELECT_CATALOG_ROLE
	   for access to V$INSTANCE
	   Info on host name will be missing in report header if this is the case.
	*/
	:host_name:=NULL;
	begin
		execute immediate '
		SELECT host_name 
		FROM v$instance'
		INTO :host_name;
	EXCEPTION WHEN OTHERS THEN
		null;
	end;
end;
/

PROMPT get database name and software release
variable version varchar2(30)
variable compatibility varchar2(30)
variable intval number
variable db_name varchar2(255)
variable instance varchar2(30)
variable result number
begin
	dbms_utility.db_version(:version, :compatibility);
	:result:=dbms_utility.get_parameter_value('db_name', :intval, :db_name);
	:result:=dbms_utility.get_parameter_value('instance_name', :intval, :instance);
end;
/

column TABLE_NAME heading "Table Owner|and Name" format a30 word_wrapped
column segment_name heading "Segment Name"
column tablespace_name heading "Tablespace" format a15
column chunk heading "Chunk"
column cache heading "Cache"
column retention heading "Retention"
column table_PARTITION_NAME heading "Table Partition Name" format a30
column index_PARTITION_NAME heading "Index Partition Name" format a30
column SUBPARTITION_NAME heading "SubPartition|Name" format a15
column NUM_ROWS heading "Number|of Rows" format 999,999,990
column BLOCKS heading "Blocks|(Statistics)" format 99,999,990
column SEGMENT_BLOCKS heading "Blocks|(Segment)" format 99,999,990
column EMPTY_BLOCKS heading "Empty|Blocks" format 999,990

column AVG_SPACE heading "Average|Space" format 9,990
column CHAIN_CNT heading "Chain|Count" format 990
column AVG_ROW_LEN heading "Average|Row Len" format 990
column COLUMN_NAME  heading "Column Name" format a30
column NULLABLE heading Null|able format a4
column NUM_DISTINCT heading "Distinct|Values" format 99,999,999,990
column NUM_NULLS heading "Number|Nulls" format 9,999,990
column NUM_BUCKETS heading "Number|Buckets" format 990
column DENSITY heading "Density" format 99D0000
column INDEX_NAME heading "Index Name" format a25
column INDEX_TYPE heading "Index|Type" format a8
column UNIQUENESS heading "Uni|que" format a3
column BLEV heading "B|Tree|Level" format 90
column LEAF_BLOCKS heading "Leaf|Blks" format 9,999,990
column DISTINCT_KEYS heading "Distinct|Keys" format 99,999,999,990
column AVG_LEAF_BLOCKS_PER_KEY heading "Average|Leaf|Blocks|Per Key" format 99,990
column AVG_DATA_BLOCKS_PER_KEY heading "Average|Data|Blocks|Per Key" format 99,990
column CLUSTERING_FACTOR heading "Cluster|Factor" format 99,999,990
column COLUMN_POSITION heading "Col|Pos" format 990
column col heading "Column|Details" format a24
column COLUMN_LENGTH heading "Col|Len" format 990
column GLOBAL_STATS heading "Global|Stats" format a6
column USER_STATS heading "User|Stats" format a5
column SAMPLE_SIZE heading "Sample|Size" format 9,999,990
column tablespace heading "Tablespace"
column last_analyzed heading "Last|Analyze" format a15

alter session set nls_date_language=american;
alter session set nls_date_format='dd.Mon yy hh24:mi';
--`set termout off
-- LOBs
-- column ALL_LOBS.TABLESPACE_NAME not available in Oracle9i, workaround:
-- make select dependent on version

define column_tablespace_name='NULL tablespace_name'
define and_clause='--'
define column_block_size='NULL block_size'
col from_tables new_value from_tables
--SELECT decode(substr(:version,1,1), '9', 'all_lobs l', 'all_lobs l, user_tablespaces ts') AS from_tables 
--FROM dual;
col column_block_size new_value column_block_size
--SELECT decode(substr(:version,1,1), '9', 'NULL block_size', 'ts.block_size/1024||'' KB'' block_size') AS column_block_size  FROM dual;
col and_clause new_value and_clause
--SELECT decode(substr(:version,1,1), '9', '--', 'and l.tablespace_name=ts.tablespace_name') AS and_clause FROM dual; 
col column_tablespace_name new_value column_tablespace_name
--SELECT decode(substr(:version,1,1), '9', 'NULL tablespace_name ', 'l.tablespace_name') AS column_tablespace_name FROM dual; 

--SELECT :schema || '.' || :table_name || '.stat' AS spool_file_name FROM dual;
set trimout on
set trimspool on
set termout on
-- database, instance, and release
set heading off
SELECT 'Database: '|| :db_name || '; Instance: '||:instance||'; ORACLE Release: ' || :version ||
	'; Platform: '||dbms_utility.port_string || nvl2(:host_name,'; Host name: ' ||:host_name, null)
FROM dual;
set heading on

select 
    owner ||' . ' || TABLE_NAME AS table_name,
    NUM_ROWS,
    BLOCKS,
    :segment_blocks AS segment_blocks,
    EMPTY_BLOCKS,
    AVG_SPACE,
    CHAIN_CNT,
    AVG_ROW_LEN,
    GLOBAL_STATS,
    USER_STATS,
    SAMPLE_SIZE,
    t.last_analyzed
from all_tables t
where 
    owner = :schema
and table_name = :table_name
/
--working
column degree format a6 heading "Degree"
column monitoring format a6 heading "Moni-|toring"
column buffer_pool format a7 heading "Buffer|Pool"
column cluster_name format a7 heading "Cluster"
column iot_type format a7 heading "IOT|Type"
column iot_name format a30 heading "IOT Name"
column block_size format a7 heading "Block-|size"
column tab_size format a9 heading "Size (MB)"
column percent_modified format 9999 heading "Modifi-|cations (%)"
select 
nvl(t.tablespace_name,'None') tablespace,
nvl2(ts.block_size, ts.block_size/1024||' KB','None') AS block_size,
CASE WHEN t.blocks IS NULL AND ts.block_size IS NOT NULL THEN 'No Statistics'
WHEN t.blocks IS NOT NULL and ts.block_size IS NULL THEN 'None'
ELSE to_char(round(t.blocks * ts.block_size/1048576,1))
END AS tab_size,
t.monitoring,
-- percentage of modified rows since last statistics gathering
CASE WHEN nvl(t.num_rows,0) > 0 THEN round((m.inserts + m.updates + m.deletes)/t.num_rows * 100,2)
ELSE null
END AS percent_modified,
nvl(t.buffer_pool,'None') buffer_pool,
trim(t.degree) degree,
t.cluster_name,
t.iot_type,
t.iot_name
from all_tables t, user_tablespaces ts, all_tab_modifications m
where 
    t.owner = :schema
and t.table_name = :table_name
and ts.tablespace_name(+)=t.tablespace_name
-- must use outer join since there may be no rows for the table in all_tab_modifications
and t.owner=m.table_owner(+)
and t.table_name=m.table_name(+)
/

select
    COLUMN_NAME,
	decode(t.DATA_TYPE,
		'NUMBER', t.DATA_TYPE|| 
			-- if scale is not null, open parenthesis
			decode(t.DATA_SCALE,NULL,NULL,'(') ||
			decode(t.DATA_PRECISION,NULL, 
				-- if precision is null and scale is null, then plain number
				-- else number(38,scale)
				decode(t.DATA_SCALE,NULL,NULL,38), 
				t.DATA_PRECISION) ||
			decode(t.DATA_SCALE,0,NULL,NULL,NULL,','||t.DATA_SCALE)
			||
			-- if scale is not null, close parenthesis
			decode(t.DATA_SCALE,NULL,NULL,')'),
		'VARCHAR2', t.DATA_TYPE||'('|| t.DATA_LENGTH||')',
		'CHAR', t.DATA_TYPE||'('|| t.DATA_LENGTH||')',
		t.data_type
	)
	||' '||
	decode(t.nullable,
              'N','NOT NULL',
              'n','NOT NULL',
              NULL) col,
    NUM_DISTINCT,
    DENSITY,
    NUM_BUCKETS,
    NUM_NULLS,
    GLOBAL_STATS,
    USER_STATS,
    SAMPLE_SIZE,
    t.last_analyzed
from all_tab_columns t
where 
    table_name = :table_name
and owner = :schema
order by column_id
/

-- additional info on index
-- add monitoring

column created heading "Created" format a15
column last_ddl_time heading "Last DDL" format a15
column index_owner_name heading "Index Owner|and Name" format a50 word_wrapped
column partitioned heading "Parti-|tioned" format a7
select 
    i.owner ||' . ' || i.INDEX_NAME AS index_owner_name,
    i.index_type,
    i.partitioned,
    o.created,
    o.last_ddl_time,
    i.last_analyzed,
    i.status,
    SAMPLE_SIZE,
    nvl2(i.tablespace_name,i.tablespace_name,'N/A') AS tablespace_name,
    nvl2(i.buffer_pool,i.buffer_pool,'N/A') AS buffer_pool,
    --decode(i.buffer_pool,NULL,'DEFAULT',i.buffer_pool) AS buffer_pool,
    trim(i.degree) degree
from 
    all_indexes i, all_objects o
where
    i.index_name=o.object_name 
and i.owner=o.owner
and i.table_name = :table_name
and i.table_owner = :schema
and o.object_type='INDEX'
/

-- index statistics
select 
    owner ||' . ' || INDEX_NAME AS index_owner_name,
    INDEX_TYPE,
    decode(UNIQUENESS,'UNIQUE','YES','NONUNIQUE','NO') UNIQUENESS,
    BLEVEL BLev,
    LEAF_BLOCKS,
    DISTINCT_KEYS,
    NUM_ROWS,
    AVG_LEAF_BLOCKS_PER_KEY,
    AVG_DATA_BLOCKS_PER_KEY,
    CLUSTERING_FACTOR,
    GLOBAL_STATS,
    USER_STATS
from 
    all_indexes
where 
    table_name = :table_name
and table_owner = :schema
/
break on index_owner_name
-- index structure
select
    i.index_owner ||' . ' || i.INDEX_NAME AS index_owner_name,
    i.COLUMN_NAME,
    i.COLUMN_POSITION,
	decode(t.DATA_TYPE,
		'NUMBER', t.DATA_TYPE|| 
			-- if scale is not null, open parenthesis
			decode(t.DATA_SCALE,NULL,NULL,'(') ||
			decode(t.DATA_PRECISION,NULL, 
				-- if precision is null and scale is null, then plain number
				-- else number(38,scale)
				decode(t.DATA_SCALE,NULL,NULL,38), 
				t.DATA_PRECISION) ||
			decode(t.DATA_SCALE,0,NULL,NULL,NULL,','||t.DATA_SCALE)
			||
			-- if scale is not null, close parenthesis
			decode(t.DATA_SCALE,NULL,NULL,')'),
		'VARCHAR2', t.DATA_TYPE||'('|| t.DATA_LENGTH||')',
		'CHAR', t.DATA_TYPE||'('|| t.DATA_LENGTH||')',
		t.data_type
	)
	||' '||
	decode(t.nullable,
              'N','NOT NULL',
              'n','NOT NULL',
              NULL) col
from 
    all_ind_columns i,
    all_tab_columns t
where 
    i.table_name = :table_name
and owner = :schema
and i.table_name = t.table_name
and i.column_name = t.column_name
and i.table_owner=t.owner
order by index_name,column_position
/

-- function based indexes
set long 10000
column column_expression format a20 word_wrapped
SELECT 
	i.index_owner ||' . ' || i.INDEX_NAME AS index_owner_name,
	i.column_position, i.column_expression
FROM all_ind_expressions i
where 
    i.table_name = :table_name
and i.table_owner = :schema
ORDER BY i.column_position
;
	



clear breaks


