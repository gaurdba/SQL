REM     ORACLE - Licence Management Services
REM              Oracle Review Lite Script
REM
REM     Usage:
REM
REM        - Use SQL*PLUS to connect to the database with any user with following privileges
REM               - CREATE SESSION
REM               - SELECT ANY TABLE
REM               - SELECT ANY DICTIONARY (for Oracle 9i or higher)
REM          Hint: SYS or SYSTEM are good choices
REM          Example:
REM               sqlplus system/password@orcl1prod
REM
REM        - Run the script:
REM               @ReviewLite2.7.sql
REM
REM        - To customize Review Lite functionality, set the following parameters:
REM               - SCRIPT_OO to collect all or options only
REM               - SCRIPT_TS to set filenames to be standard or with timestamp
REM          at the section below this header. The last definition of each parameter will dictate the customization
REM
REM
REM
REM     Change History
REM     Date:     Rev:    Author:           Description:
REM     MM/DD/YY
REM     03/04/05  1.0                      Database Options Script
REM     08/07/05  2.0     Andres Herrera   Added Users defined, HWM, devices and conc
REM     10/03/05  2.1     Fernando LLanos  Database CPU count, Standby configuration
REM     10/06/05  2.1     Andres Herrera   Revision and formating
REM     10/09/06  2.2     Ellice Siytiu    Added OEM repository check, changed spatial query
REM     11/13/06  2.2     Ellice Siytiu    Added new options queries (Data Mining, Database Vault,
REM                                        Audit Vault, CONTENT DATABASE, RECORDS DATABASE)
REM     05/01/07  2.2     esiytiu          changed USER_SDO_GEOM_METADATA to ALL_SDO_GEOM_METADATA
REM     05/01/07  2.2     esiytiu          RAC analysis changed from counting host to instances
REM     07/24/07  2.3.1   esiytiu          additional ',' added to Segments query to fix "exceed length" error
REM     10/25/07  2.3.1   beparu           Added the section for automatic processing option
REM     12/28/07  2.4.1   esiytiu          Segment query - added count, min and max name instead of details;
REM                                        Added new query for OEM 10g that checks SYSMAN.MGMT% tables and for packs;
REM                                        Removed nested Select from Content query;
REM                                        Added select from DBA_REGISTRY to identify spatial over locator.
REM     02/23/08  2.5     sserban          Added usage notes; Added cpu_count isdefault;
REM                                        Check and modify OUTPUT_PATH to end with / or \;
REM     04/22/08  2.5.1   sserban          Added mgmt_licenses and mgmt_targets queries for OEM 10g;
REM                                        Marked the 2 OEM sections: prior and after 10g
REM     11/11/08  2.5.2   sserban          Fixed bug: missing '"' after mgmt_license_definitions.pack_display_label
REM     02/06/09  2.5.3   beparu           Altered linesize for sessions file
REM                                        Added V$PARAMETER Query for RAC - CLUSTER_DATABASE
REM                                        Added PARALLEL SERVER query to RAC queries
REM     03/12/09  2.5.4   sserban          Added License Agreement
REM                                        Removed DBA_REGISTRY query for version 9i_r2 (9.2)
REM                                        Added V$PARAMETER query for diag+tuning packs in 11g databases:
REM                                              CONTROL_MANAGEMENT_PACK_ACCESS
REM                                        Added VPROMPT specified in the program documentation, notice files or readme files. Such third party
PROMPT technology is licensed to you under the terms of the third party technology license agreement
PROMPT specified in the program documentation, notice files or readme files and not
PROMPT under the terms of this agreement.
PROMPT
PROMPT You may not:
PROMPT - use the programs for your own internal data processing or for any commercial or
PROMPT   production purposes, or use the programs for any purpose except the purpose
PROMPT   stated herein;
PROMPT - remove or modify any program markings or any notice of Oracle's or Oracle's
PROMPT   licensors' proprietary rights;
PROMPT - make the programs available in any manner to any third party for use in the third
PROMPT   party's business operations, without our prior written consent;
PROMPT - use the programs to provide third party training or rent or lease the programs or
PROMPT   use the programs for commercial time sharing or service bureau use;
PROMPT - assign this agreement or give or transfer the programs or an interest in them to
PROMPT   another individual or entity;
PROMPT - cause or permit reverse engineering (unless required by law for interoperability),
PROMPT   disassembly or decompilation of the programs (the foregoing prohibition includes
PROMPT   but is not limited to review of data structures or similar materials produced by
PROMPT   programs);
PROMPT - disclose results of any program benchmark tests without our prior written consent;
PROMPT - use any Oracle name, trademark or logo without our prior written consent.
PROMPT
PROMPT * Disclaimer of Warranty
PROMPT ORACLE DOES NOT GUARANTEE THAT THE PROGRAMS WILL PERFORM
PROMPT ERROR-FREE OR UNINTERRUPTED. TO THE EXTENT NOT PROHIBITED BY
PROMPT LAW, THE PROGRAMS ARE PROVIDED "AS IS" WITHOUT WARRANTY OF
PROMPT ANY KIND AND THERE ARE NO WARRANTIES, EXPRESS OR IMPLIED, OR
PROMPT CONDITIONS, INCLUDING WITHOUT LIMITATION, WARRANTIES OR
PROMPT CONDITIONS OF MERCHANTABILITY, NONINFRINGEMENT OR FITNESS FOR
PROMPT A PARTICULAR PURPOSE THAT APPLY TO THE PROGRAMS.
PROMPT
PROMPT * No Right to Technical Support
PROMPT You acknowledge and agree that Oracle’s technical support organization will not provide
PROMPT you with technical support for the programs licensed under this agreement.
PROMPT
PROMPT * End of Agreement
PROMPT You may terminate this agreement by destroying all copies of the programs. We have the
PROMPT right to terminate your right to use the programs at any time upon notice to you, in which
PROMPT case you shall destroy all copies of the programs.
PROMPT
PROMPT * Entire Agreement
PROMPT You agree that this agreement is the complete agreement for the programs and supersedes
PROMPT all prior or contemporaneous agreements or representations, written or oral, regarding
PROMPT such programs. If any term of this agreement is found to be invalid or unenforceable, the
PROMPT remaining provisions will remain effective and such term shall be replaced with a term
PROMPT consistent with the purpose and intent of this agreement.
PROMPT
PROMPT * Limitation of Liability
PROMPT IN NO EVENT SHALL ORACLE BE LIABLE FOR ANY INDIRECT, INCIDENTAL,
PROMPT SPECIAL, PUNITIVE OR CONSEQUENTIAL DAMAGES, OR ANY LOSS OF
PROMPT PROFITS, REVENUE, DATA OR DATA USE, INCURRED BY YOU OR ANY
PROMPT THIRD PARTY. ORACLE’S ENTIRE LIABILITY FOR DAMAGES ARISING OUT
PROMPT OF OR RELATED TO THIS AGREEMENT, WHETHER IN CONTRACT OR TORT
PROMPT OR OTHERWISE, SHALL IN NO EVENT EXCEED ONE THOUSAND U.S.
PROMPT DOLLARS (U.S. $1,000).
PROMPT
PROMPT * Export
PROMPT Export laws and regulations of the United States and any other relevant local export laws
PROMPT and regulations apply to the programs. You agree that such export control laws govern
PROMPT your use of the programs (including technical data) provided under this agreement, and
PROMPT you agree to comply with all such export laws and regulations (including "deemed
PROMPT export" and "deemed re-export" regulations). You agree that no data, information,
PROMPT and/or program (or direct product thereof) will be exported, directly or indirectly, in
PROMPT violation of any export laws, nor will they be used for any purpose prohibited by these
PROMPT laws including, without limitation, nuclear, chemical, or biological weapons proliferation,
PROMPT or development of missile technology.
PROMPT
PROMPT * Other
PROMPT 1. This agreement is governed by the substantive and procedural laws of the State of
PROMPT    California. You and we agree to submit to the exclusive jurisdiction of, and venue in,
PROMPT    the courts of San Francisco or Santa Clara counties in California in any dispute
PROMPT    arising out of or relating to this agreement.
PROMPT 2. You may not assign this agreement or give or transfer the programs or an interest in
PROMPT    them to another individual or entity. If you grant a security interest in the programs,
PROMPT    the secured party has no right to use or transfer the programs.
PROMPT 3. Except for actions for breach of Oracle’s proprietary rights, no action, regardless of
PROMPT    form, arising out of or relating to this agreement may be brought by either party more
PROMPT    than two years after the cause of action has accrued.
PROMPT 4. Oracle may audit your use of the programs. You agree to cooperate with Oracle's
PROMPT    audit and provide reasonable assistance and access to information. Any such audit
PROMPT    shall not unreasonably interfere with your normal business operations. You agree
PROMPT    that Oracle shall not be responsible for any of your costs incurred in cooperating with
PROMPT    the audit.
PROMPT 5. The relationship between you and us is that of licensee/licensor. Nothing in this
PROMPT    agreement shall be construed to create a partnership, joint venture, agency, or
PROMPT    employment relationship between the parties. The parties agree that they are acting
PROMPT    solely as independent contractors hereunder and agree that the parties have no
PROMPT    fiduciary duty to one another or any other special or implied duties that are not
PROMPT    expressly stated herein. Neither party has any authority to act as agent for, or to incur
PROMPT    any obligations on behalf of or in the name of the other.
PROMPT 6. This agreement may not be modified and the rights and restrictions may not be altered
PROMPT    or waived except in a writing signed by authorized representatives of you and of us.
PROMPT 7. Any notice required under this agreement shall be provided to the other party in
PROMPT    writing.
PROMPT
PROMPT * Contact Information
PROMPT Should you have any questions concerning your use of the programs or this agreement,
PROMPT please contact:
PROMPT
PROMPT License Management Services at:
PROMPT http://www.oracle.com/us/corporate/license-management-services/index.html
PROMPT Oracle America, Inc.
PROMPT 500 Oracle Parkway
PROMPT Redwood City, CA 94065
PROMPT
PROMPT ===============================================================

SPOOL OFF

HOST&SCRIPT_TS more lms_license_agreement.txt

-- PROMT FOR LICENSE AGREEMENT ACCEPTANCE
DEFINE LANSWER=N
SET TERMOUT ON
ACCEPT&SCRIPT_TS LANSWER FORMAT A1 PROMPT 'Accept License Agreement? (y\n): '

HOST&SCRIPT_TS rm   lms_license_agreement.txt
HOST&SCRIPT_TS del  lms_license_agreement.txt

-- FORCE "divisor is equal to zero" AND SQLERROR EXIT IF NOT ACCEPTED
-- WILL ALSO CONTINUE IF SCRIPT_TS SUBSTITUTION VARIABLE IS NOT NULL
SET TERMOUT OFF
WHENEVER SQLERROR EXIT
select 1/decode('&LANSWER', 'Y', null, 'y', null, decode('&SCRIPT_TS', null, 0, null)) as " " from dual;
WHENEVER SQLERROR CONTINUE
SET TERMOUT ON

alter session set NLS_LANGUAGE='AMERICAN';
alter session set NLS_TERRITORY='AMERICA';
alter session set NLS_DATE_FORMAT='YYYY-MM-DD_HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY-MM-DD_HH24:MI:SS';

SET TERMOUT OFF
SET TAB OFF
SET TRIMOUT OFF
SET TRIMSPOOL OFF
SET PAGESIZE 5000
SET LINESIZE 300


-- Get SYSDATE
col C0 new_val SYSDATE_START
select SYSDATE C0 from dual;

-- Get host_name and instance_name
col C1 new_val INSTANCE_NAME
col C2 new_val HOST_NAME
-- Oracle7
SELECT min(machine) C2 FROM v$session WHERE type = 'BACKGROUND';
SELECT name    C1 FROM v$database;
-- Oracle8 and higher
SELECT instance_name C1, host_name C2 FROM v$instance;

col C3 new_val OUTPUT_PATH
select '&&HOST_NAME'||'_'||'&&INSTANCE_NAME'||
       decode('&SCRIPT_TS', null, null, '_'||to_char(to_date('&SYSDATE_START', 'YYYY-MM-DD_HH24:MI:SS'), 'YYYY.MM.DD.HH24.MI.SS')) C3 from DUAL;

HOST mkdir &&OUTPUT_PATH

-- Establish separator character for output path
col PATH_SEPARATOR new_val PATH_SEPARATOR
select decode(instr('&&OUTPUT_PATH', '/'), 0,
       decode(instr('&&OUTPUT_PATH', '\'), 0, '/', '\'), '/') as PATH_SEPARATOR
from dual;
-- If case, append separator at the end of otput path
col OUTPUT_PATH new_val OUTPUT_PATH
select decode(instr('&&OUTPUT_PATH', '&&PATH_SEPARATOR', -1),
              length('&&OUTPUT_PATH'), '&&OUTPUT_PATH', '&&OUTPUT_PATH&&PATH_SEPARATOR&&OUTPUT_PATH._') OUTPUT_PATH
from dual;

SET TERMOUT ON

spool&SCRIPT_OO &&OUTPUT_PATH.summary.csv
PROMPT HOST_NAME: &&HOST_NAME., INSTANCE_NAME: &&INSTANCE_NAME.
SHOW USER
PROMPT OUTPUT PATH AND FILENAME PATTERN IS is &&OUTPUT_PATH*.csv

REM Setting Format output...

SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET TERMOUT ON
SET PAUSE OFF

col parameter     format a40
COL Options       format a40
COL value         format a10
COL CPU           format a10
COL HOST_NAME     format a40 wrap
COL Instance_name format a15

SELECT 'LMS ReviewLite &SCRIPT_RELEASE. output file created at: ' || '&SYSDATE_START' FROM DUAL;

PROMPT
PROMPT DB CPU COUNT
PROMPT ==========================================================
SELECT 'DATABASE CPU COUNT: ' || value ||
       decode(ISDEFAULT, 'TRUE', ' (ISDEFAULT)', ' (IS NOT DEFAULT !!!: '|| ISDEFAULT ||')')
       from V$PARAMETER where UPPER(name) like '%CPU_COUNT%';
PROMPT
PROMPT CPU Count as set on the database, could have been modified manually.
PROMPT Please verify using CPU Query and also check for Hyper Threading and
PROMPT Multi-core technology in the server.

PROMPT
PROMPT
PROMPT STAND BY SERVER CONFIGURATION
PROMPT ==========================================================
SELECT 'Standby values for Client: ' ||value from V$PARAMETER where UPPER(name) like '%FAL_CLIENT%';
SELECT 'Standby values for Server: ' ||value from V$PARAMETER where UPPER(name) like '%FAL_SERVER%';
PROMPT IF NO INFORMATION SHOWED THEN DB DOES NOT HAVE A STANDBY DB
PROMPT
PROMPT

SET HEADING ON
SET FEEDBACK ON
COL "Distinct username" FORMAT A30
PROMPT USERS CREATED AND CREATION DATE
PROMPT ==========================================================

SELECT&SCRIPT_OO DISTINCT USERNAME as "Distinct username", Created as "Created" FROM DBA_USERS ORDER BY CREATED ASC;


SPOOL OFF


SPOOL &&OUTPUT_PATH.version.csv

SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET PAGESIZE 5000
SET LINESIZE 300

PROMPT DATABASE VERSION
PROMPT -------------------------------------------

PROMPT AUDIT_ID,BANNER,HOST_NAME,INSTANCE_NAME,SYSDATE

SELECT
0                  ||','||
'"'||BANNER||'"'   ||','||
'&&HOST_NAME'      ||','||
'&&INSTANCE_NAME'  ||','||
'&SYSDATE_START'   ||','
FROM V$VERSION;


prompt DATABASE PATCHES
prompt -------------------------------------------;
prompt AUDIT_ID,ACTION_TIME#ACTION#NAMESPACE#VERSION#ID#COMMENTS,HOST_NAME,INSTANCE_NAME,SYSDATE
select
      '0,"'              ||
      ACTION_TIME        ||'#'||
      ACTION             ||'#'||
      NAMESPACE          ||'#'||
      VERSION            ||'#'||
      ID                 ||'#'||
      COMMENTS           ||
      '"'                ||','||
      '&&HOST_NAME'      ||','||
      '&&INSTANCE_NAME'  ||','||
      '&SYSDATE_START'   ||','
  from SYS.REGISTRY$HISTORY
  order by ACTION_TIME;

SPOOL OFF


-- Prepare to select EXPIRY_DATE only from versions > 7
define EXPIRY_DATE_DYN=''''''
col C4 new_val EXPIRY_DATE_DYN
-- This will work only on Oracle8 and higher
SELECT min(EXPIRY_DATE) C, 'EXPIRY_DATE' C4 FROM DBA_USERS;
col C4 clear


SPOOL&SCRIPT_OO &&OUTPUT_PATH.users.csv

SET HEADING OFF
SET FEEDBACK ON
SET VERIFY OFF
SET PAGESIZE 5000
SET LINESIZE 300

PROMPT
PROMPT USERS CREATED
PROMPT -------------------------------------------

COL username format a18
COL userid format a7
COL default_Tablespace format a13
COL temporary_Tablespace format a13
COL profile format a10

PROMPT AUDIT_ID,USERNAME,USER_ID,DEFAULT_TABLESPACE,TEMPORARY_TABLESPACE,CREATED,PROFILE,EXPIRY_DATE,HOST_NAME,INSTANCE_NAME,SYSDATE

SELECT&SCRIPT_OO DISTINCT
0                     ||','||
USERNAME              ||','||
USER_ID               ||','||
DEFAULT_TABLESPACE    ||','||
TEMPORARY_TABLESPACE  ||','||
CREATED               ||','||
PROFILE               ||','||
&EXPIRY_DATE_DYN.     ||','||
'&&HOST_NAME'         ||','||
'&&INSTANCE_NAME'     ||','||
'&SYSDATE_START'      ||','
FROM DBA_USERS;

SPOOL OFF

SPOOL&SCRIPT_OO &&OUTPUT_PATH.parameter.csv
SET HEADING OFF
SET FEEDBACK ON
SET VERIFY OFF
SET PAGESIZE 5000
SET LINESIZE 300

COL VALUE format a10
COL ISDEFAULT format a7
COL DESCRIPTION format a60

PROMPT
PROMPT DATABASE PARAMETER
PROMPT -------------------------------------------

PROMPT AUDIT_ID,NAME,VALUE,ISDEFAULT,DESCRIPTION,HOST_NAME,INSTANCE_NAME,SYSDATE

SELECT&SCRIPT_OO
0                  ||','||
NAME               ||','||
VALUE              ||','||
ISDEFAULT          ||','||
DESCRIPTION        ||','||
'&&HOST_NAME'      ||','||
'&&INSTANCE_NAME'  ||','||
'&SYSDATE_START'   ||','
FROM V$PARAMETER
WHERE UPPER(NAME) = 'CPU_COUNT';

SPOOL OFF

SPOOL &&OUTPUT_PATH.segments.csv
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET PAGESIZE 5000
SET LINESIZE 300

COL segment_type format a10
col segment_name format a30
COL OWNER format a10
COL Partition_name format a15

PROMPT
PROMPT PARTITIONED DBA SEGMENTS (not applicable for release 7)
PROMPT -------------------------------------------------------

PROMPT AUDIT_ID,OWNER,SEGMENT_TYPE,SEGMENT_NAME,PARTITION_COUNT,PARTITION_MIN,PARTITION_MAX,HOST_NAME,INSTANCE_NAME,SYSDATE

SELECT
0                    ||','||
OWNER                ||','||
OBJECT_TYPE          ||','||
OBJECT_NAME          ||','||
COUNT(*)             ||','||
MIN(SUBOBJECT_NAME)  ||','||
MAX(SUBOBJECT_NAME)  ||','||
'&&HOST_NAME'        ||','||
'&&INSTANCE_NAME'    ||','||
'&SYSDATE_START'     ||','
FROM DBA_OBJECTS
WHERE OBJECT_TYPE LIKE '%PARTITION%'
GROUP BY OWNER, OBJECT_TYPE, OBJECT_NAME
ORDER BY 1;

SPOOL OFF

SPOOL&SCRIPT_OO &&OUTPUT_PATH.license.csv
SET HEADING OFF
SET FEEDBACK ON
SET VERIFY OFF
SET PAGESIZE 5000
SET LINESIZE 300

PROMPT
PROMPT
PROMPT LICENSE INFORMATION
PROMPT -------------------------------------------

PROMPT
PROMPT AUDIT_ID,SESSIONS_MAX,SESSIONS_WARNING,SESSIONS_CURRENT,SESSIONS_HIGHWATER,USERS_MAX,HOST_NAME,INSTANCE_NAME,SYSDATE

select&SCRIPT_OO
0                     ||','||
SESSIONS_MAX          ||','||
SESSIONS_WARNING      ||','||
SESSIONS_CURRENT      ||','||
SESSIONS_HIGHWATER    ||','||
USERS_MAX             ||','||
'&&HOST_NAME'         ||','||
'&&INSTANCE_NAME'     ||','||
'&SYSDATE_START'      ||','
FROM V$LICENSE;

SPOOL OFF


SPOOL&SCRIPT_OO &&OUTPUT_PATH.session.csv
SET HEADING OFF
SET FEEDBACK ON
SET VERIFY OFF
SET PAGESIZE 5000
SET LINESIZE 500

define LOGON_TIME_=NULL
col LOGON_TIME_ new_val LOGON_TIME_
select LOGON_TIME, 'LOGON_TIME' as LOGON_TIME_ from V$SESSION where rownum=1;

PROMPT
PROMPT
PROMPT SESSIONS INFORMATION
PROMPT -------------------------------------------

PROMPT
PROMPT AUDIT_ID,SID,USER#,USERNAME,COMMAND,S.STATUS,SERVER,SCHEMANAME,OSUSER,PROCESS,MACHINE,TERMINAL,PROGRAM,TYPE,MODULE,ACTION,CLIENT_INFO,LAST_CALL_ET,LOGON_TIME,HOST_NAME,INSTANCE_NAME,SYSDATE

select&SCRIPT_OO
0                     || ',' ||
SID                   || ',' ||
SERIAL#               || ',"'||
USERNAME              ||'","'||
COMMAND               ||'","'||
STATUS                ||'","'||
SERVER                ||'","'||
SCHEMANAME            ||'","'||
OSUSER                ||'","'||
PROCESS               ||'","'||
MACHINE               ||'","'||
TERMINAL              ||'","'||
PROGRAM               ||'","'||
TYPE                  ||'","'||
MODULE                ||'","'||
ACTION                ||'","'||
CLIENT_INFO           ||'","'||
LAST_CALL_ET          ||'","'||
&LOGON_TIME_          ||'",' ||
'&&HOST_NAME'         || ',' ||
'&&INSTANCE_NAME'     || ',' ||
'&SYSDATE_START'      || ','
FROM V$SESSION;

SPOOL OFF

SPOOL &&OUTPUT_PATH.v_option.csv
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET PAGESIZE 5000
SET LINESIZE 300

PROMPT
PROMPT DATABASE OPTIONS
PROMPT -------------------------------------------

PROMPT AUDIT_ID,PARAMETER,VALUE,HOST_NAME,INSTANCE_NAME,SYSDATE

SELECT DISTINCT
0                 ||','||
PARAMETER         ||','||
VALUE             ||','||
'&&HOST_NAME'     ||','||
'&&INSTANCE_NAME' ||','||
'&SYSDATE_START'  ||','
FROM V$OPTION;

SPOOL OFF

SPOOL &&OUTPUT_PATH.dba_feature.csv

SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET PAGESIZE 5000
SET LINESIZE 500

Column name format a45
Column detected_usages format 9999

PROMPT
PROMPT
PROMPT 10g DBA_FEATURE_USAGE_STATISTICS
PROMPT -------------------------------------------

PROMPT

PROMPT AUDIT_ID,DBID,NAME,VERSION,DETECTED_USAGES,TOTAL_SAMPLES,CURRENTLY_USED,FIRST_USAGE_DATE,LAST_USAGE_DATE,AUX_COUNT,FEATURE_INFO,LAST_SAMPLE_DATE,LAST_SAMPLE_PERIOD,SAMPLE_INTERVAL,DESCRIPTION,HOST_NAME,INSTANCE_NAME,SYSDATE

SELECT
0                     ||',"' ||
DBID                  ||'","'||
NAME                  ||'","'||
VERSION               ||'","'||
DETECTED_USAGES       ||'","'||
TOTAL_SAMPLES         ||'","'||
CURRENTLY_USED        ||'","'||
FIRST_USAGE_DATE      ||'","'||
LAST_USAGE_DATE       ||'","'||
AUX_COUNT             ||'","'||
''                    ||'","'|| -- skip FEATURE_INFO clob
LAST_SAMPLE_DATE      ||'","'||
LAST_SAMPLE_PERIOD    ||'","'||
SAMPLE_INTERVAL       ||'","'||
DESCRIPTION           ||'","'||
'&&HOST_NAME'         ||'","'||
'&&INSTANCE_NAME'     ||'","'||
'&SYSDATE_START'      ||'",'
from DBA_FEATURE_USAGE_STATISTICS
where  detected_usages > 0 and
( name like '%ADDM%'
or name like '%Automatic Database Diagnostic Monitor%'
or name like '%Automatic Workload Repository%'
or name like '%AWR%'
or name like '%Baseline%'
or (name like '%Compression%' and name not like '%HeapCompression%')  -- (#46352) - Ignore HeapCompression in dba fus)
or name like '%Data Guard%'
or name like '%Data Mining%'
or name like '%Database Replay%'
or name like '%EM%'
or name like '%Encrypt%'
or name like '%Exadata%'
or name like '%Flashback Data Archive%'
or name like '%Label Security%'
or name like '%OLAP%'
or name like '%Pack%'
or name like '%Partitioning%'
or name like '%Real Application Clusters%'
or name like '%SecureFile%'
or name like '%Spatial%'
or name like '%SQL Monitoring%'
or name like '%SQL Performance%'
or name like '%SQL Profile%'
or (name like '%SQL Tuning%' and name not like 'Automatic SQL Tuning Advisor') -- (#46989) - Ignore Automatic SQL Tuning Advisor in DBA FUS
or name like '%SQL Access Advisor%'
or name like '%Vault%')
order by name;

SPOOL OFF



SPOOL &&OUTPUT_PATH.options.csv
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET PAGESIZE 5000
SET LINESIZE 300



PROMPT
PROMPT *** PARTITIONING
PROMPT ======================================================================

SET HEADING OFF

SELECT 'ORACLE PARTITIONING INSTALLED: '||value from v$option where
parameter='Partitioning';

SET FEEDBACK ON
SET HEADING ON
COL OWNER        FORMAT A20 WRAP
COL SEGMENT_TYPE FORMAT A18 WRAP
COL SEGMENT_NAME FORMAT A30 WRAP

SELECT distinct OWNER, OBJECT_TYPE as SEGMENT_TYPE, OBJECT_NAME as SEGMENT_NAME, min(created) min_created, min(last_ddl_time) min_last_dll_time
  FROM DBA_OBJECTS
  WHERE OBJECT_TYPE LIKE '%PARTITION%'
  group by OWNER, OBJECT_TYPE, OBJECT_NAME
  ORDER BY 1, 2, 3;


PROMPT Partitioned objects on RECYCLEBIN

select OWNER, ORIGINAL_NAME, OBJECT_NAME, TYPE, CREATETIME, DROPTIME, PARTITION_NAME, SPACE, CAN_UNDROP
  from DBA_RECYCLEBIN
  where TYPE not like '%Partition%'
    and (OWNER, OBJECT_NAME) in (select OWNER, OBJECT_NAME from DBA_RECYCLEBIN where TYPE like '%Partition%')
union all
select OWNER, ORIGINAL_NAME, OBJECT_NAME, TYPE, CREATETIME, DROPTIME, PARTITION_NAME, SPACE, CAN_UNDROP
  from DBA_RECYCLEBIN
  where TYPE like '%Partition%';

PROMPT IF NO ROWS ARE RETURNED, THEN PARTITIONING IS NOT BEING USED.
PROMPT
PROMPT IF ROWS ARE RETURNED, CHECK THAT BOTH OWNER AND SEGMENT ARE
PROMPT ORACLE CREATED. IF NOT, THEN PARTITIONING IS BEING USED.
PROMPT

SET HEADING OFF
SET FEEDBACK OFF



PROMPT
PROMPT *** OLAP
PROMPT ======================================================================

SELECT 'ORACLE OLAP INSTALLED: '|| value from v$option where parameter='OLAP';

PROMPT
PROMPT
PROMPT CHECKING TO SEE IF OLAP IS INSTALLED / USED...

select value from v$option where parameter = 'OLAP';

PROMPT
PROMPT If the value is TRUE then the OLAP option IS INSTALLED
PROMPT If the value is FALSE then the OLAP option IS NOT INSTALLED
PROMPT If NO rows are selected then the option is NOT being used.

PROMPT
PROMPT
PROMPT CHECKING TO SEE IF THE OLAP OPTION IS BEING USED...
PROMPT
PROMPT CHECKING FOR OLAP CUBES...
PROMPT

SET HEADING ON
SET FEEDBACK OFF

SELECT
   count(*) "OLAP CUBES"
FROM
   olapsys.dba$olap_cubes
WHERE
   OWNER <>'SH' ;

PROMPT
PROMPT IF THE COUNT IS > 0 THEN CHECK THE WORKSPACES BEING USED
PROMPT IF THE COUNT IS = 0 THEN THE OLAP OPTION IS NOT BEING USED
PROMPT IF THE TABLE DOES NOT EXIST (ORA-00942) ...THEN THE OLAP CUBES ARE NOT BEING USED
PROMPT

PROMPT CHECKING FOR ANALYTICAL WORK SPACES...
PROMPT

SELECT count(*) "Analytical Workspaces"
FROM   dba_aws;

PROMPT
PROMPT IF THE COUNT IS >1 THEN CHECK WORKSPACES AND ITS OWNER
PROMPT IF THE COUNT IS 0 OR 1 THEN ANALYTICAL WORKSPACES ARE NOT BEING USED
PROMPT IF THE TABLE DOES NOT EXIST (ORA-00942) ...THEN ANALYTICAL WORKSPACES ARE NOT BEING USED

PROMPT
PROMPT CHECKING FOR ANALYTICAL WORKSPACE OWNERS...
PROMPT

SET HEADING ON
SET FEEDBACK ON

SELECT OWNER, AW_NUMBER, AW_NAME, PAGESPACES, GENERATIONS FROM
DBA_AWS;

PROMPT
PROMPT NOTE: A positive result FROM either QUERY indicates the use of the OLAP option.
PROMPT    Check the Workspace owners to detemine if Workspaces are Oracle created.
PROMPT



PROMPT
PROMPT *** RAC (REAL APPLICATION CLUSTERS)
PROMPT ======================================================================

SET HEADING OFF
SET FEEDBACK OFF
SELECT 'ORACLE RAC INSTALLED: '||value from v$option where
parameter in ('Real Application Clusters','Parallel Server');

SET HEADING ON

PROMPT
PROMPT CHECKING TO SEE IF RAC IS INSTALLED AND BEING USED...
PROMPT RAC (Real Application Clusters) = Former OPS (Oracle Parallel Server)
PROMPT

SELECT name, value
FROM   gv$parameter
WHERE  name = 'cluster_database';

PROMPT
PROMPT Checking V$PARAMETER (for DB version 9.0.1 and above)
PROMPT If the value returned is TRUE, then RAC/OPS is being used.
PROMPT even if the following query only returns one row.

SELECT instance_name, host_name
FROM   gv$instance
ORDER BY instance_name;

PROMPT
PROMPT If only one row is returned and DB version is 11.2 then it might be an Oracle RAC One Node configuration.
PROMPT In some cases, customer can be running the Online Relocation feature and 2 instances are legally running for the Oracle RAC One Node database
PROMPT In the other cases, if more than one row is returned, then RAC/OPS IS being used for this database.
PROMPT



PROMPT
PROMPT *** LABEL SECURITY
PROMPT ======================================================================

SET HEADING OFF
SET FEEDBACK OFF

SELECT 'ORACLE LABEL SECURITY INSTALLED: '||value from v$option where
parameter='Label Security';

PROMPT
PROMPT
PROMPT CHECKING TO SEE IF LABEL SECURITY IS INSTALLLED / USED...

select value
from   v$option
where  parameter = 'Oracle Label Security';

PROMPT
PROMPT If the value is TRUE then the LABEL SECURITY OPTION IS installed
PROMPT If the value is FALSE then the LABEL SECURITY OPTION IS NOT installed
PROMPT If NO rows are selected then the option is NOT being used
PROMPT
PROMPT

PROMPT CHECKING TO SEE IF THE LABEL SECURITY OPTION IS BEING USED....
PROMPT

select count(*) from lbacsys.lbac$polt where owner <> 'SA_DEMO';

PROMPT
PROMPT If the COUNT > 0 then the LABEL SECURITY OPTION IS being used
PROMPT If the COUNT IS = 0 then the LABEL SECURITY OPTION IS NOT being used
PROMPT If TABLE DOES NOT EXIST (ORA-00942) ...Then LABEL SECURITY OPTION IS NOT being used
PROMPT



PROMPT
PROMPT *** OEM (ORACLE ENTERPRISE MANAGER)
PROMPT =====================================================================*

PROMPT
PROMPT CHECKING FOR OEM VERSIONS PRIOR TO 10g
PROMPT -------------------------------------------

SET HEADING ON
SET FEEDBACK OFF

PROMPT
PROMPT CHECKING TO SEE IF OEM PROGRAMS ARE RUNNING
PROMPT DURING THE MEASUREMENT PERIOD...
PROMPT

SET FEEDBACK on

SELECT DISTINCT
   program
FROM
   v$session
WHERE
   upper(program) LIKE '%XPNI.EXE%'
   OR upper(program) LIKE '%VMS.EXE%'
   OR upper(program) LIKE '%EPC.EXE%'
   OR upper(program) LIKE '%TDVAPP.EXE%'
   OR upper(program) LIKE 'VDOSSHELL%'
   OR upper(program) LIKE '%VMQ%'
   OR upper(program) LIKE '%VTUSHELL%'
   OR upper(program) LIKE '%JAVAVMQ%'
   OR upper(program) LIKE '%XPAUTUNE%'
   OR upper(program) LIKE '%XPCOIN%'
   OR upper(program) LIKE '%XPKSH%'
   OR upper(program) LIKE '%XPUI%';

PROMPT
PROMPT CHECKING FOR OEM REPOSITORIES...
PROMPT

   SET SERVEROUTPUT ON

      DECLARE
      cursor1 integer;
   v_count number(1);
      v_schema dba_tables.owner%TYPE;
      v_version varchar2(10);
      v_component varchar2(20);
      v_i_name varchar2(10);
      v_h_name varchar2(30);
      stmt varchar2(200);
      rows_processed integer;

      CURSOR schema_array IS
      SELECT owner
      FROM dba_tables WHERE table_name = 'SMP_REP_VERSION';

      CURSOR schema_array_v2 IS
      SELECT owner
      FROM dba_tables WHERE table_name = 'SMP_VDS_REPOS_VERSION';

      BEGIN
         DBMS_OUTPUT.PUT_LINE ('.');
         DBMS_OUTPUT.PUT_LINE ('OEM REPOSITORY LOCATIONS');

         select instance_name,host_name into v_i_name, v_h_name from
            v$instance;
            DBMS_OUTPUT.PUT_LINE ('Instance: '||v_i_name||' on host: '||v_h_name);

            OPEN schema_array;
            OPEN schema_array_v2;

            cursor1:=dbms_sql.open_cursor;

            v_count := 0;

            LOOP -- this loop steps through each valid schema.
            FETCH schema_array INTO v_schema;
            EXIT WHEN schema_array%notfound;
            v_count := v_count + 1;
            dbms_sql.parse(cursor1,'select c_current_version, c_component from
            '||v_schema||'.smp_rep_version', dbms_sql.native);
            dbms_sql.define_column(cursor1, 1, v_version, 10);
            dbms_sql.define_column(cursor1, 2, v_component, 20);

            rows_processed:=dbms_sql.execute ( cursor1 );

            loop -- to step through cursor1 to find console version.
            if dbms_sql.fetch_rows(cursor1) >0 then
            dbms_sql.column_value (cursor1, 1, v_version);
            dbms_sql.column_value (cursor1, 2, v_component);
            if v_component = 'CONSOLE' then
            dbms_output.put_line ('Schema '||rpad(v_schema,15)||' has a repository
            version '||v_version);
            exit;

            end if;
            else
               exit;
            end if;
            end loop;

            END LOOP;

            LOOP -- this loop steps through each valid V2 schema.
            FETCH schema_array_v2 INTO v_schema;
            EXIT WHEN schema_array_v2%notfound;

            v_count := v_count + 1;
            dbms_output.put_line ( 'Schema '||rpad(v_schema,15)||' has a repository
            version 2.x' );
            end loop;

            dbms_sql.close_cursor (cursor1);
            close schema_array;
            close schema_array_v2;
            if v_count = 0 then
            dbms_output.put_line ( 'There are NO OEM repositories with version prior to 10g on this instance.');
            end if;
   end;
/

prompt
prompt If NO ROWS are returned then OEM is not being used.
prompt If ROWS are returned, then OEM is being utilized.
prompt

PROMPT
PROMPT CHECKING FOR OEM VERSIONS 10g OR HIGHER
PROMPT -------------------------------------------

col OEM_PACK       format A40 wrap
col PACK_ACCESS_GRANTED format A19
col PACK_ACCESS_AGREED  format A19
col TABLE_NAME_    format A40 wrap
col C_             format A24 wrap

define OEMOWNER=SYSMAN
col OEMOWNER new_val OEMOWNER format a30 wrap
col OEM_PACK format a75 wrap
select 'OEM REPOSITORY SCHEMA:' C_, owner as OEMOWNER from dba_tables where table_name = 'MGMT_ADMIN_LICENSES';


prompt
prompt GATHERING MANAGEMENT PACK ACCESS SETTINGS
prompt === OEM 10g Database Control
prompt

select distinct
       a.pack_display_label as OEM_PACK,
       decode(b.pack_name, null, 'NO', 'YES') as PACK_ACCESS_GRANTED,
       PACK_ACCESS_AGREED
  from &&OEMOWNER..MGMT_LICENSE_DEFINITIONS a,
       &&OEMOWNER..MGMT_ADMIN_LICENSES      b,
      (select decode(count(*), 0, 'NO', 'YES') as PACK_ACCESS_AGREED
        from &&OEMOWNER..MGMT_LICENSES where upper(I_AGREE)='YES') c
  where a.pack_label = b.pack_name   (+)
  order by 1, 2;

col I_AGREE format a10 wrap
prompt OEM PACK ACCESS AGREEMENTS
select USERNAME, TIMESTAMP, I_AGREE
  from &&OEMOWNER..MGMT_LICENSES
  order by TIMESTAMP;


col TARGET_NAME    format a30 wrap
prompt OEM MANAGED DATABASES
select TARGET_NAME, HOST_NAME, LOAD_TIMESTAMP
  from &&OEMOWNER..MGMT_TARGETS
  where TARGET_TYPE = 'oracle_database'
  order by TARGET_NAME;


prompt
prompt GATHERING MANAGEMENT PACK ACCESS SETTINGS
prompt === OEM 10g Grid Control; OEM Grid Control 11g; OEM 11g Database Control
prompt

SET PAGESIZE 5000
SET LINESIZE 314

col HOST_NAME               format A30 wrap
col TARGET_NAME             format A50 wrap
col TARGET_TYPE             format A30 wrap
col TARGET_TYPE_D           format A30 wrap
col PARENT_TARGET_NAME      format A50 wrap
col PARENT_TARGET_TYPE      format A30 wrap
col PACK_LABEL              format A20 wrap
col OEM_PACK                format A60 wrap
col PACK_ACCESS_GRANTED     format A19 wrap
col PACK_ACCESS_AGREED      format A19 wrap
col PACK_ACCESS_AGREED_DATE format A23 wrap
col PACK_ACCESS_AGREED_BY   format A21 wrap

select
       tg.host_name,
       tg.target_type,
       tt.type_display_name as target_type_d,
       tg.target_name,
       ld.pack_label,
       ld.pack_display_label as oem_pack,
       decode(lt.pack_name  , null, 'NO', 'YES') as pack_access_granted,
       decode(lc.target_guid, null, 'NO', 'YES') as pack_access_agreed,
       lc.confirmed_time                         as pack_access_agreed_date,
       lc.confirmed_by                           as pack_access_agreed_by
  from              &&OEMOWNER..MGMT_TARGETS                  tg
    left outer join &&OEMOWNER..MGMT_TARGET_TYPES             tt on tg.target_type = tt.target_type
         inner join &&OEMOWNER..MGMT_LICENSE_DEFINITIONS      ld on tg.target_type = ld.target_type
    left outer join &&OEMOWNER..MGMT_LICENSED_TARGETS         lt on tg.target_guid = lt.target_guid and ld.pack_label = lt.pack_name
    left outer join &&OEMOWNER..MGMT_LICENSE_CONFIRMATION     lc on tg.target_guid = lc.target_guid
  order by tg.host_name, tt.type_display_name, tg.target_name, ld.pack_display_label;

SET LINESIZE 200


COL VALUE_ format a18
prompt
prompt CHECKING CONTROL_MANAGEMENT_PACK_ACCESS and ENABLE_DDL_LOGGING INSTANCE PARAMETERS (11g or higher)
prompt

select name, value as value_, isdefault
  from V$PARAMETER
  where UPPER(name) like '%CONTROL_MANAGEMENT_PACK_ACCESS%'
  or UPPER(name) like '%ENABLE_DDL_LOGGING%'                -- (#43257)
  order by 1;


prompt
prompt CHECKING FOR USE OF SQL PROFILES
prompt If the number returned is > 0, SQL Profiles are IN USE - this means TUNING PACK must be licensed
select count(*) from  dba_sql_profiles where lower(status) like 'enabled';

prompt GATHERING DETAILS FROM SQL PROFILES USAGE
Select name, created, last_modified, description, type, status from dba_sql_profiles;

SET HEADING OFF
SET FEEDBACK OFF



PROMPT
PROMPT *** SPATIAL
PROMPT ======================================================================

SELECT 'ORACLE SPATIAL INSTALLED: '||value from v$option where
parameter='Spatial';

SET HEADING ON
SET FEEDBACK ON

PROMPT
PROMPT CHECKING TO SEE IF SPATIAL FUNCTIONS ARE BEING USED...
PROMPT

select count(*) "SDO_GEOM_METADATA_TABLE"  -- (#46727)
from MDSYS.SDO_GEOM_METADATA_TABLE;

PROMPT
PROMPT If value returned is 0, then SPATIAL is NOT being used.
PROMPT If value returned is > 0, then SPATIAL OR LOCATOR IS being used.
PROMPT
PROMPT For version 10g and higher, check DBA_FEATURE_USAGE_STATISTICS
PROMPT whether Spatial is currently used.
PROMPT
PROMPT For version 9i and below, confirm with the customer
PROMPT whether Spatial or Locator is being used.
PROMPT

SET HEADING OFF
SET FEEDBACK OFF



PROMPT
PROMPT *** DATA MINING
PROMPT ======================================================================

SELECT 'ORACLE DATA MINING INSTALLED: '||value from v$option where
parameter like '%Data Mining';

SET HEADING ON
SET FEEDBACK ON

PROMPT
PROMPT CHECKING TO SEE IF DATA MINING IS BEING USED:
PROMPT

PROMPT FOR 9i DATABASE:
PROMPT
select count(*) "Data_Mining_Model" from odm.odm_mining_model;

PROMPT
PROMPT FOR 10g v1 DATABASE:
PROMPT
select count(*) "Data_Mining_Objects" from dmsys.dm$object;
select count(*) "Data_Mining_Models" from dmsys.dm$model;
PROMPT
PROMPT FOR 10g v2 DATABASE:
PROMPT
select count(*) "Data_Mining_Objects" from dmsys.dm$p_model;
PROMPT
PROMPT FOR 11g DATABASE:
PROMPT
select count(*) from SYS.MODEL$;

prompt If no rows are returned, then Data Mining is NOT being used.
prompt If rows are returned then Data Mining IS being used.
prompt
PROMPT Gathering Data Mining Models details (11g and above)
select OWNER, MODEL_NAME, MINING_FUNCTION, ALGORITHM, CREATION_DATE, BUILD_DURATION, MODEL_SIZE
  from SYS.DBA_MINING_MODELS
  order by OWNER, MODEL_NAME;



PROMPT
PROMPT *** DATABASE VAULT
PROMPT ======================================================================

PROMPT
PROMPT CHECKING TO SEE IF DATABASE VAULT SCHEMAS ARE INSTALLED...

SET HEADING OFF
SET FEEDBACK OFF

select decode(upper(max(username)), 'DVSYS', 'Audit Vault Schema DVSYS exist', 'Audit Vault schema DVSYS does not exist')
  from dba_users where UPPER(username)='DVSYS';

select decode(upper(max(username)), 'DVF', 'Audit Vault Schema DVF exist', 'Audit Vault schema DVF does not exist')
  from dba_users where UPPER(username)='DVF';

SET FEEDBACK ON

PROMPT
PROMPT Checking if there are Database Vault Realms created...
PROMPT
SELECT decode(count(*), 0, 'No realms were created', count(*) ||' Realms were created')
FROM DVSYS.DBA_DV_REALM;

PROMPT 
col FEATURE_INFO_ clear

col VALUE_ format a100 wrap
col NAME_  format a30  wrap

select name NAME_, value as value_, isdefault
  from V$PARAMETER
  where UPPER(name)  like '%LOG_ARCHIVE_DEST%'
    and UPPER(value) like '%COMPRESSION=ENABLE%'
  order by 1;

prompt If any rows are returned, then ADVANCED COMPRESSION OPTION is in use
prompt

col VALUE_ clear
col NAME_  clear

prompt
prompt
prompt * Checking for "Data Pump Compression" feature usage

SET LINESIZE 500
col FEATURE_INFO_ format a350 wrap

select
       VERSION,
       NAME,
       CURRENTLY_USED,
       LAST_USAGE_DATE,
       LAST_SAMPLE_DATE,
       to_char(FEATURE_INFO) feature_info_
from dba_feature_usage_statistics
where name = 'Oracle Utility Datapump (Export)'
  order by 1, 2;

SET LINESIZE 200

prompt If FEATURE_INFO column contains "Compression used: N times" and N is not 0 (zero) then ADVANCED COMPRESSION OPTION is in use
prompt

col FEATURE_INFO_ clear

PROMPT
PROMPT END OF SCRIPT
PROMPT
PROMPT
PROMPT *****************************************************
PROMPT *****************************************************
PROMPT *****************************************************
PROMPT *****                                           *****
PROMPT *****     Please ignore the section below.      *****
PROMPT ***** It is used for automatic processing only. *****
PROMPT *****                                           *****
PROMPT *****************************************************
PROMPT *****************************************************
PROMPT *****************************************************
PROMPT
PROMPT
PROMPT
PROMPT

-------------------------------------------
-------------------------------------------
-- Second stage, output for GREP command --
-------------------------------------------
-------------------------------------------

SET HEADING OFF
SET FEEDBACK OFF
--SET COLSEP ','
SET PAGESIZE 5000
SET LINESIZE 500
SET VERIFY OFF

col C3 new_val GREP_PREFIX noprint
SELECT 'GREP'||'ME>>,&&HOST_NAME.,&&INSTANCE_NAME.,' || '&SYSDATE_START' || ',&&HOST_NAME.,' || name as C3 FROM v$database;

prompt &&GREP_PREFIX.,REVIEW_LITE,VERSION,,,&SCRIPT_RELEASE.,


-- V$VERSION - DB Version
-------------------------
define OPTION_NAME=V$VERSION
define OPTION_QUERY=NULL
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  FROM V$VERSION;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,"'||
        BANNER           ||'",'
  FROM V$VERSION;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942, 0);


-- V$OPTION - DB Options Installed
----------------------------------
define OPTION_NAME=V$OPTION
define OPTION_QUERY=NULL
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  FROM V$OPTION;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,"'||
        PARAMETER    ||'","'||
        VALUE        ||'",'
  FROM V$OPTION;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942, 0);


-- 10g DBA_FEATURE_USAGE_STATISTICS (10g and higher)
----------------------------------------------------
define OPTION_NAME=DBA_FEATURE_USAGE_STATISTICS
define OPTION_QUERY=10g
define OPTION_QUERY_COLS=NAME,VERSION,DETECTED_USAGES,TOTAL_SAMPLES,CURRENTLY_USED,FIRST_USAGE_DATE,LAST_USAGE_DATE,LAST_SAMPLE_DATE,SAMPLE_INTERVAL
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  FROM DBA_FEATURE_USAGE_STATISTICS;

select '&&GREP_PREFIX.,&OPTION_NAME.~HEADER,&OPTION_QUERY.~HEADER,&&OCOUNT.,count,&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. > 0;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,"'||
        NAME               || '","'||
        VERSION            || '","'||
        DETECTED_USAGES    || '","'||
        TOTAL_SAMPLES      || '","'||
        CURRENTLY_USED     || '","'||
        FIRST_USAGE_DATE   || '","'||
        LAST_USAGE_DATE    || '","'||
        LAST_SAMPLE_DATE   || '","'||
        SAMPLE_INTERVAL    || '",'
  FROM DBA_FEATURE_USAGE_STATISTICS;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",') || '&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. in (-942, 0);


-- DBA_REGISTRY (9i_r2 and higher)
----------------------------------
define OPTION_NAME=DBA_REGISTRY
define OPTION_QUERY=>=9i_r2
define OPTION_QUERY_COLS=COMP_NAME,VERSION,STATUS,MODIFIED,SCHEMA
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  from DBA_REGISTRY;

select '&&GREP_PREFIX.,&OPTION_NAME.~HEADER,&OPTION_QUERY.~HEADER,&&OCOUNT.,count,&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. > 0;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        '"' || COMP_NAME || '",' || VERSION || ',' || STATUS || ',' || MODIFIED || ',' || SCHEMA || ','
  from DBA_REGISTRY;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",') || '&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. in (-942, 0);


-- GV$PARAMETER
--------------------------------------------
define OPTION_NAME=GV$PARAMETER
define OPTION_QUERY=NULL
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  FROM GV$PARAMETER
  where  upper(name) like '%CPU_COUNT%'
      or upper(name) like '%FAL_CLIENT%'
      or upper(name) like '%FAL_SERVER%'
      or upper(name) like '%CLUSTER%'
      or upper(name) like '%CONTROL_MANAGEMENT_PACK_ACCESS%'
      or upper(name) like '%ENABLE_DDL_LOGGING%'
      or upper(name) like '%COMPATIBLE%'
      or upper(name) like '%LOG_ARCHIVE_DEST%'
  ;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,"'||
        INST_ID      ||'","'||
        NAME         ||'","'||
        VALUE        ||'","'||
        ISDEFAULT    ||'","'||
        DESCRIPTION  ||'",'
  FROM GV$PARAMETER
  where  upper(name) like '%CPU_COUNT%'
      or upper(name) like '%FAL_CLIENT%'
      or upper(name) like '%FAL_SERVER%'
      or upper(name) like '%CLUSTER%'
      or upper(name) like '%CONTROL_MANAGEMENT_PACK_ACCESS%'
      or upper(name) like '%ENABLE_DDL_LOGGING%'
      or upper(name) like '%COMPATIBLE%'
      or upper(name) like '%LOG_ARCHIVE_DEST%'
  order by NAME, INST_ID;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942, 0);



-- *** PARTITIONING
-- ====================================================================
define OPTION_NAME=PARTITIONING
define OPTION_QUERY=PARTITIONED_SEGMENTS
define OPTION_QUERY_COLS=OWNER,SEGMENT_TYPE,SEGMENT_NAME,MIN_CREATED,MIN_LAST_DLL_TIME
define OCOUNT=-942

col OCOUNT new_val OCOUNT noprint

select ltrim(rtrim(to_char(count(distinct OWNER||','||OBJECT_TYPE||','||OBJECT_NAME)))) as OCOUNT
  FROM DBA_OBJECTS
  WHERE OBJECT_TYPE LIKE '%PARTITION%';

select ltrim(rtrim(to_char(count(*)))) as OCOUNT
from (
select distinct
        OWNER||','||OBJECT_TYPE||','||OBJECT_NAME||','||min(CREATED)||','||min(LAST_DDL_TIME)||','
  from  DBA_OBJECTS
  where OBJECT_TYPE LIKE '%PARTITION%'
  group by OWNER, OBJECT_TYPE, OBJECT_NAME
     );


select '&&GREP_PREFIX.,&OPTION_NAME.~HEADER,&OPTION_QUERY.~HEADER,&&OCOUNT.,count,&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. > 0;

select distinct
        '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        OWNER||','||OBJECT_TYPE||','||OBJECT_NAME||','||min(CREATED)||','||min(LAST_DDL_TIME)||','
  from  DBA_OBJECTS
  where OBJECT_TYPE LIKE '%PARTITION%'
  group by OWNER, OBJECT_TYPE, OBJECT_NAME
  ;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",') || '&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. in (-942, 0);



-- List of partitioned segments to be ignored because they are automatically created with Analytical Workspaces
define OPTION_QUERY=OLAP_AWS_SEGMENTS
define OPTION_QUERY_COLS=AW_OWNER,AW_NAME,AW_VERSION,SEGMENT_TYPE,OWNER,SEGMENT_NAME,TABLE_NAME
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint


select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  from (
select distinct
       c.owner as aw_owner,
       c.aw_name,
       c.aw_version,
       d.object_type,
       d.owner,
       d.object_name,
       d.object_name as table_name
  from dba_aws      c
  join dba_objects  d on c.owner = d.owner and 'AW$'||c.aw_name = d.object_name
  where d.object_type like '%PARTITION%'
union all
select distinct
       e.owner as aw_owner,
       e.aw_name,
       e.aw_version,
       g.object_type,
       g.owner,
       g.object_name,
       f.table_name
  from dba_aws            e
  join dba_lobs           f on e.owner = f.owner and 'AW$'||e.aw_name = f.table_name
  join dba_objects        g on f.owner = g.owner and f.segment_name = g.object_name
  where g.object_type like '%PARTITION%'
union all
select distinct
       e.owner as aw_owner,
       e.aw_name,
       e.aw_version,
       g.object_type,
       g.owner,
       g.object_name,
       f.table_name
  from dba_aws            e
  join dba_indexes        f on e.owner = f.table_owner and 'AW$'||e.aw_name = f.table_name
  join dba_objects        g on f.owner = g.owner and f.index_name = g.object_name
  where g.object_type like '%PARTITION%'
  order by owner, aw_name, object_type, object_name
);

select '&&GREP_PREFIX.,&OPTION_NAME.~HEADER,&OPTION_QUERY.~HEADER,&&OCOUNT.,count,&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. > 0;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
       aw_owner      ||','||
       aw_name       ||','||
       aw_version    ||','||
       object_type   ||','||
       owner         ||','||
       object_name   ||','||
       table_name    ||','
from (
select distinct
       c.owner as aw_owner,
       c.aw_name,
       c.aw_version,
       d.object_type,
       d.owner,
       d.object_name,
       d.object_name as table_name
  from dba_aws      c
  join dba_objects  d on c.owner = d.owner and 'AW$'||c.aw_name = d.object_name
  where d.object_type like '%PARTITION%'
union all
select distinct
       e.owner as aw_owner,
       e.aw_name,
       e.aw_version,
       g.object_type,
       g.owner,
       g.object_name,
       f.table_name
  from dba_aws            e
  join dba_lobs           f on e.owner = f.owner and 'AW$'||e.aw_name = f.table_name
  join dba_objects        g on f.owner = g.owner and f.segment_name = g.object_name
  where g.object_type like '%PARTITION%'
union all
select distinct
       e.owner as aw_owner,
       e.aw_name,
       e.aw_version,
       g.object_type,
       g.owner,
       g.object_name,
       f.table_name
  from dba_aws            e
  join dba_indexes        f on e.owner = f.table_owner and 'AW$'||e.aw_name = f.table_name
  join dba_objects        g on f.owner = g.owner and f.index_name = g.object_name
  where g.object_type like '%PARTITION%'
  order by owner, aw_name, object_type, object_name
);


select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",') || '&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. in (-942, 0);


--Partitioned objects on RECYCLEBIN
define OPTION_QUERY=PARTITION_OBJ_RECYCLEBIN
define OPTION_QUERY_COLS=OWNER,ORIGINAL_NAME,OBJECT_NAME,TYPE,CREATETIME,DROPTIME,PARTITION_NAME,SPACE,CAN_UNDROP
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint

select ltrim(rtrim(to_char(count(*)))) as OCOUNT
from (
  select OWNER, ORIGINAL_NAME, OBJECT_NAME, TYPE, CREATETIME, DROPTIME, PARTITION_NAME, SPACE, CAN_UNDROP
    from DBA_RECYCLEBIN
    where TYPE not like '%Partition%'
      and (OWNER, OBJECT_NAME) in (select OWNER, OBJECT_NAME from DBA_RECYCLEBIN where TYPE like '%Partition%')
  union all
  select OWNER, ORIGINAL_NAME, OBJECT_NAME, TYPE, CREATETIME, DROPTIME, PARTITION_NAME, SPACE, CAN_UNDROP
    from DBA_RECYCLEBIN
    where TYPE like '%Partition%'
);

select '&&GREP_PREFIX.,&OPTION_NAME.~HEADER,&OPTION_QUERY.~HEADER,&&OCOUNT.,count,&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. > 0;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        OWNER           ||','||
        ORIGINAL_NAME   ||','||
        OBJECT_NAME     ||','||
        TYPE            ||','||
        CREATETIME      ||','||
        DROPTIME        ||','||
        PARTITION_NAME  ||','||
        SPACE           ||','||
        CAN_UNDROP      ||','
  from (
  select OWNER, ORIGINAL_NAME, OBJECT_NAME, TYPE, CREATETIME, DROPTIME, PARTITION_NAME, SPACE, CAN_UNDROP
    from DBA_RECYCLEBIN
    where TYPE not like '%Partition%'
      and (OWNER, OBJECT_NAME) in (select OWNER, OBJECT_NAME from DBA_RECYCLEBIN where TYPE like '%Partition%')
  union all
  select OWNER, ORIGINAL_NAME, OBJECT_NAME, TYPE, CREATETIME, DROPTIME, PARTITION_NAME, SPACE, CAN_UNDROP
    from DBA_RECYCLEBIN
    where TYPE like '%Partition%'
  );

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",') || '&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. in (-942, 0);



-- *** OLAP
-- ====================================================================
-- CUBES
define OPTION_NAME=OLAP
define OPTION_QUERY=CUBES_COUNT
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  FROM  OLAPSYS.DBA$OLAP_CUBES
  WHERE OWNER <>'SH';

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        count(*) ||','
  FROM  OLAPSYS.DBA$OLAP_CUBES
  WHERE OWNER <>'SH';

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942);

-- ANALYTIC WORKSPACES
define OPTION_NAME=OLAP
define OPTION_QUERY=ANALYTIC_WORKSPACES
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  FROM DBA_AWS;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        OWNER        ||','||
        AW_NUMBER    ||','||
        AW_NAME      ||','||
        PAGESPACES   ||','||
        GENERATIONS  ||','
  FROM DBA_AWS;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942, 0);



-- *** RAC (REAL APPLICATION CLUSTERS)
-- ====================================================================
define OPTION_NAME=RAC
define OPTION_QUERY=GV$INSTANCE
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  FROM GV$INSTANCE;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        instance_name    ||','||
        host_name        ||','||
        INST_ID          ||','
  FROM GV$INSTANCE;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942, 0);



-- *** LABEL SECURITY
-- ====================================================================
define OPTION_NAME=LABEL_SECURITY
define OPTION_QUERY=LBAC$POLT_COUNT
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  FROM  LBACSYS.LBAC$POLT
  WHERE OWNER <> 'SA_DEMO';

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        count(*) ||','
  FROM  LBACSYS.LBAC$POLT
  WHERE OWNER <> 'SA_DEMO';

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942);



-- *** OEM (ORACLE ENTERPRISE MANAGER)
-- ===================================================================*
-- Check for running known OEM Programs
define OPTION_NAME=OEM
define OPTION_QUERY=RUNNING_PROGRAMS
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(distinct program)))) as OCOUNT
  FROM V$SESSION
  WHERE
      upper(program) LIKE '%XPNI.EXE%'
   OR upper(program) LIKE '%VMS.EXE%'
   OR upper(program) LIKE '%EPC.EXE%'
   OR upper(program) LIKE '%TDVAPP.EXE%'
   OR upper(program) LIKE 'VDOSSHELL%'
   OR upper(program) LIKE '%VMQ%'
   OR upper(program) LIKE '%VTUSHELL%'
   OR upper(program) LIKE '%JAVAVMQ%'
   OR upper(program) LIKE '%XPAUTUNE%'
   OR upper(program) LIKE '%XPCOIN%'
   OR upper(program) LIKE '%XPKSH%'
   OR upper(program) LIKE '%XPUI%';

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,"'||
        PROGRAM   ||'",'
  FROM V$SESSION
  WHERE
      upper(program) LIKE '%XPNI.EXE%'
   OR upper(program) LIKE '%VMS.EXE%'
   OR upper(program) LIKE '%EPC.EXE%'
   OR upper(program) LIKE '%TDVAPP.EXE%'
   OR upper(program) LIKE 'VDOSSHELL%'
   OR upper(program) LIKE '%VMQ%'
   OR upper(program) LIKE '%VTUSHELL%'
   OR upper(program) LIKE '%JAVAVMQ%'
   OR upper(program) LIKE '%XPAUTUNE%'
   OR upper(program) LIKE '%XPCOIN%'
   OR upper(program) LIKE '%XPKSH%'
   OR upper(program) LIKE '%XPUI%';

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942, 0);

-- PL/SQL anonymous block to Check for known OEM tables
DECLARE
    cursor1 integer;
    v_count number(1);
    v_schema dba_tables.owner%TYPE;
    v_version varchar2(10);
    v_component varchar2(20);
    v_i_name varchar2(10);
    v_h_name varchar2(30);
    stmt varchar2(200);
    rows_processed integer;

    CURSOR schema_array IS
    SELECT owner
    FROM dba_tables WHERE table_name = 'SMP_REP_VERSION';

    CURSOR schema_array_v2 IS
    SELECT owner
    FROM dba_tables WHERE table_name = 'SMP_VDS_REPOS_VERSION';

BEGIN
    --DBMS_OUTPUT.PUT_LINE ('.');
    --DBMS_OUTPUT.PUT_LINE ('OEM REPOSITORY LOCATIONS');

    SELECT instance_name,host_name INTO v_i_name, v_h_name FROM v$instance;

    --DBMS_OUTPUT.PUT_LINE ('Instance: '||v_i_name||' on host: '||v_h_name);

    OPEN schema_array;
    OPEN schema_array_v2;

    cursor1 := dbms_sql.open_cursor;
    v_count := 0;

    LOOP -- this loop steps through each valid schema.
       FETCH schema_array INTO v_schema;
       EXIT WHEN schema_array%notfound;
       v_count := v_count + 1;
       dbms_sql.parse(cursor1,'select c_current_version, c_component from'||v_schema||'.smp_rep_version', dbms_sql.native);
       dbms_sql.define_column(cursor1, 1, v_version, 10);
       dbms_sql.define_column(cursor1, 2, v_component, 20);

       rows_processed:=dbms_sql.execute ( cursor1 );

       loop -- to step through cursor1 toual where &&OCOUNT. in (-942);


-- 10gv2
define OPTION_NAME=DATA_MINING
define OPTION_QUERY=10gv2.DM$P_MODEL
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  from DMSYS.DM$P_MODEL;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        count(*) || ','
  from DMSYS.DM$P_MODEL;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942);


-- 11g
define OPTION_NAME=DATA_MINING
define OPTION_QUERY=11g.DM$P_MODEL
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  from SYS.MODEL$;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        count(*) || ','
  from SYS.MODEL$;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942);


-- 11g and higher
define OPTION_NAME=DATA_MINING
define OPTION_QUERY=11g+.DBA_MINING_MODELS
define OPTION_QUERY_COLS=OWNER,MODEL_NAME,MINING_FUNCTION,ALGORITHM,CREATION_DATE,BUILD_DURATION,MODEL_SIZE
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint

select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  from SYS.DBA_MINING_MODELS;

select '&&GREP_PREFIX.,&OPTION_NAME.~HEADER,&OPTION_QUERY.~HEADER,&&OCOUNT.,count,&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. > 0;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        OWNER           ||','||
        MODEL_NAME      ||','||
        MINING_FUNCTION ||',"'||
        ALGORITHM       ||'",'||
        CREATION_DATE   ||','||
        BUILD_DURATION  ||','||
        MODEL_SIZE      ||','
  from SYS.DBA_MINING_MODELS
  order by OWNER, MODEL_NAME
  ;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",') || '&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. in (-942, 0);



-- *** DATABASE VAULT
-- ====================================================================
select '&&GREP_PREFIX.,DATABASE_VAULT,DVSYS_SCHEMA,'||count(*)||',count,'||MAX(username)||','
  from dba_users where UPPER(username)='DVSYS';

select '&&GREP_PREFIX.,DATABASE_VAULT,DVF_SCHEMA,'||count(*)||',count,'||MAX(username)||','
  from dba_users where UPPER(username)='DVF';


define OPTION_NAME=DATABASE_VAULT
define OPTION_QUERY=DBA_DV_REALM
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  from DVSYS.DBA_DV_REALM;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        count(*) || ','
  from DVSYS.DBA_DV_REALM;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942);



-- *** AUDIT VAULT
-- ===================================================================*
select '&&GREP_PREFIX.,AUDIT_VAULT*,AVSYS_SCHEMA,'||count(*)||',count,'||MAX(username)||','
  from dba_users where UPPER(username)='AVSYS';



-- *** CONTENT DATABASE and RECORDS DATABASE
-- ====================================================================
select '&&GREP_PREFIX.,CONTENT_AND_RECORDS,CONTENT_SCHEMA,'||count(*)||',count,'||MAX(username)||','
  from dba_users where UPPER(username)='CONTENT';

-- CONTENT
define OPTION_NAME=CONTENT_DATABASE
define OPTION_QUERY=ODM_DOCUMENT
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  from ODM_DOCUMENT;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        count(*) || ','
  from ODM_DOCUMENT;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942);

-- RECORDS
define OPTION_NAME=RECORDS_DATABASE
define OPTION_QUERY=ODM_RECORD
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  from ODM_RECORD;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        count(*) || ','
  from ODM_RECORD;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942);



-- *** ADVANCED SECURITY
-- ====================================================================
define OPTION_NAME=ADVANCED_SECURITY
define OPTION_QUERY=SESSION_SCAN
col    OCOUNT new_val OCOUNT noprint
SELECT COUNT(AUTHENTICATION_TYPE||','||SID||','||OSUSER||',"'||NETWORK_SERVICE_BANNER||'",') as OCOUNT
  FROM V$SESSION_CONNECT_INFO
 WHERE LOWER(NETWORK_SERVICE_BANNER) like '%authentication service%'
    OR LOWER(NETWORK_SERVICE_BANNER) like '%encryption service%'
    OR LOWER(NETWORK_SERVICE_BANNER) like '%crypto_checksumming%';

SELECT '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        AUTHENTICATION_TYPE||','||SID||','||OSUSER||',"'||NETWORK_SERVICE_BANNER || '",'
  FROM V$SESSION_CONNECT_INFO
 WHERE LOWER(NETWORK_SERVICE_BANNER) like '%authentication service%'
    OR LOWER(NETWORK_SERVICE_BANNER) like '%encryption service%'
    OR LOWER(NETWORK_SERVICE_BANNER) like '%crypto_checksumming%';

SELECT '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  FROM DUAL WHERE &&OCOUNT. in (-942);

DEFINE OPTION_QUERY=COLUMN_ENCRYPTION
COL    OCOUNT new_val OCOUNT noprint
SELECT COUNT(*) as OCOUNT
  FROM DBA_ENCRYPTED_COLUMNS;

SELECT '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
       OWNER || ',' || TABLE_NAME || ',' ||COLUMN_NAME || ',' FROM DBA_ENCRYPTED_COLUMNS;

SELECT '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  FROM DUAL WHERE &&OCOUNT. in (-942);

DEFINE OPTION_QUERY=TABLESPACE_ENCRYPTION
COL    OCOUNT new_val OCOUNT noprint
SELECT COUNT(*) as OCOUNT
  FROM DBA_TABLESPACES
 WHERE ENCRYPTED ='YES';

SELECT '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
       TABLESPACE_NAME || ',' || ENCRYPTED ||','
  FROM DBA_TABLESPACES
 WHERE ENCRYPTED ='YES';

SELECT '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
       decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  FROM DUAL WHERE &&OCOUNT. in (-942);



-- *** OWB (ORACLE WAREHOUSE BUILDER)
-- ===================================================================*
define OPTION_NAME=OWB
define OPTION_QUERY=REPOSITORY

DECLARE

  CURSOR schema_array IS
  SELECT owner
  FROM dba_tables WHERE table_name = 'CMPSYSCLASSES';

  c_installed_ver   integer;
  rows_processed    integer;
  v_schema          dba_tables.owner%TYPE;
  v_schema_cnt      integer;
  v_version         varchar2(15);

BEGIN
  OPEN schema_array;
  c_installed_ver := dbms_sql.open_cursor;

  <<owb_schema_loop>>
  LOOP -- For each valid schema...
    FETCH schema_array INTO v_schema;
    EXIT WHEN schema_array%notfound;

    --Determine if current schema is valid (contains CMPInstallation_V view)
    dbms_sql.parse(c_installed_ver,'select installedversion from '|| v_schema || '.CMPInstallation_v where name = ''Oracle Warehouse Builder''',dbms_sql.native);
    dbms_sql.define_column(c_installed_ver, 1, v_version, 15);

    rows_processed:=dbms_sql.execute ( c_installed_ver );

      loop -- Find OWB version.
        if dbms_sql.fetch_rows(c_installed_ver) > 0 then
          dbms_sql.column_value (c_installed_ver, 1, v_version);
          v_schema_cnt := v_schema_cnt + 1;

          dbms_output.put_line ('.');
          dbms_output.put_line ('&&GREP_PREFIX.,&&OPTION_NAME.,&&OPTION_QUERY.'||',1,1,'||'Schema '||v_schema||' contains a version '||v_version||' repository');
        else
          exit;
        end if;
      end loop;
  end loop;
END;
/


-- *** ACTIVE DATA GUARD (introduced in 11g_r1)
-- ====================================================================
define OPTION_NAME=ACTIVE_DATA_GUARD
define OPTION_QUERY=11gr1
define OPTION_QUERY_COLS=COUNT,DBID,NAME,DB_UNIQUE_NAME,OPEN_MODE,DATABASE_ROLE,REMOTE_ARCHIVE,DATAGUARD_BROKER,GUARD_STATUS,PLATFORM_NAME
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint

select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  from (
  select
        a.DEST_ID        ||','||
        a.DEST_NAME      ||','||
        a.STATUS         ||','||
        a.TYPE           ||','||
        a.DATABASE_MODE  ||','||
        a.RECOVERY_MODE  ||',"'||
        a.DESTINATION    ||'",'||
        a.DB_UNIQUE_NAME ||','||
        b.VALUE          ||','
  from V$ARCHIVE_DEST_STATUS a, V$PARAMETER b
  where b.NAME = 'compatible' and b.VALUE like '11%'
    and a.RECOVERY_MODE like 'MANAGED%' and a.STATUS = 'VALID' and a.DATABASE_MODE = 'OPEN_READ-ONLY'
       );

select '&&GREP_PREFIX.,&OPTION_NAME.~HEADER,&OPTION_QUERY.~HEADER,&&OCOUNT.,count,&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. > 0;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,&&OCOUNT.,'||
        a.DEST_ID        ||','||
        a.DEST_NAME      ||','||
        a.STATUS         ||','||
        a.TYPE           ||','||
        a.DATABASE_MODE  ||','||
        a.RECOVERY_MODE  ||',"'||
        a.DESTINATION    ||'",'||
        a.DB_UNIQUE_NAME ||','||
        b.VALUE          ||','
  from V$ARCHIVE_DEST_STATUS a, V$PARAMETER b
  where b.NAME = 'compatible' and b.VALUE like '11%'
    and a.RECOVERY_MODE like 'MANAGED%' and a.STATUS = 'VALID' and a.DATABASE_MODE = 'OPEN_READ-ONLY'
  order by a.DEST_ID;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",') || '&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. in (-942, 0);


define OPTION_NAME=ACTIVE_DATA_GUARD
define OPTION_QUERY=V$DATABASE
define OPTION_QUERY_COLS=DBID,NAME,DB_UNIQUE_NAME,OPEN_MODE,DATABASE_ROLE,REMOTE_ARCHIVE,DATAGUARD_BROKER,GUARD_STATUS,PLATFORM_NAME
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint

select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  from (
  select
        DBID             ||','||
        NAME             ||','||
        DB_UNIQUE_NAME   ||','||
        OPEN_MODE        ||',"'||
        DATABASE_ROLE    ||'","'||
        REMOTE_ARCHIVE   ||'","'||
        DATAGUARD_BROKER ||'","'||
        GUARD_STATUS     ||'","'||
        PLATFORM_NAME    ||'",'
  from V$DATABASE
       );

select '&&GREP_PREFIX.,&OPTION_NAME.~HEADER,&OPTION_QUERY.~HEADER,&&OCOUNT.,count,&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. > 0;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        DBID             ||','||
        NAME             ||','||
        DB_UNIQUE_NAME   ||','||
        OPEN_MODE        ||',"'||
        DATABASE_ROLE    ||'","'||
        REMOTE_ARCHIVE   ||'","'||
        DATAGUARD_BROKER ||'","'||
        GUARD_STATUS     ||'","'||
        PLATFORM_NAME    ||'",'
  from V$DATABASE;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",') || '&OPTION_QUERY_COLS.,'
  from dual where &&OCOUNT. in (-942, 0);
------------------------------------------

-- V$LICENSE
define OPTION_NAME=EXTRA_INFO
define OPTION_QUERY=V$LICENSE
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  FROM V$LICENSE;

select&SCRIPT_OO '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        SESSIONS_MAX          ||','||
        SESSIONS_WARNING      ||','||
        SESSIONS_CURRENT      ||','||
        SESSIONS_HIGHWATER    ||','||
        USERS_MAX             ||','
  FROM V$LICENSE;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942, 0);


-- V$SESSION
define OPTION_NAME=EXTRA_INFO
define OPTION_QUERY=V$SESSION
define OCOUNT=-942
col OCOUNT new_val OCOUNT noprint
select ltrim(rtrim(to_char(count(*)))) as OCOUNT
  FROM V$SESSION;

select&SCRIPT_OO '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,count,'||
        SID          || ',' ||
        SERIAL#      || ',"'||
        USERNAME     ||'","'||
        COMMAND      ||'","'||
        STATUS       ||'","'||
        SERVER       ||'","'||
        SCHEMANAME   ||'","'||
        OSUSER       ||'","'||
        PROCESS      ||'","'||
        MACHINE      ||'","'||
        TERMINAL     ||'","'||
        PROGRAM      ||'","'||
        TYPE         ||'","'||
        MODULE       ||'","'||
        ACTION       ||'","'||
        CLIENT_INFO  ||'","'||
        LAST_CALL_ET ||'","'||
        LOGON_TIME   ||'",'
  FROM V$SESSION;

select '&&GREP_PREFIX.,&OPTION_NAME.,&OPTION_QUERY.,&&OCOUNT.,'||
        decode(&&OCOUNT., 0, 'count,', '"ORA-00942: table or view does not exist",')
  from dual where &&OCOUNT. in (-942, 0);


--------------------------------------------
PROMPT *** EXTRA INFO *** Troubleshooting
------------------------------------------

-- Check User Privileges, for troubleshooting
select '&&GREP_PREFIX.,USER_PRIVS,USER_SYS_PRIVS,,,'||
        USERNAME     || ',' ||
        PRIVILEGE    || ','
  FROM USER_SYS_PRIVS;

select '&&GREP_PREFIX.,USER_PRIVS,USER_ROLE_PRIVS,,,'||
        USERNAME     || ',' ||
        GRANTED_ROLE || ','
  FROM USER_ROLE_PRIVS;

select '&&GREP_PREFIX.,USER_PRIVS,ROLE_SYS_PRIVS,,,'||
        ROLE         || ',' ||
        PRIVILEGE    || ','
  FROM ROLE_SYS_PRIVS;


PROMPT

select 'LMS Review Lite Script runtime:' " ",
       (sysdate-to_date('&SYSDATE_START', 'YYYY-MM-DD_HH24:MI:SS'))*24*60*60 " ",
       'seconds' " "
  from dual;


PROMPT END OF SCRIPT
SPOOL OFF

EXIT

