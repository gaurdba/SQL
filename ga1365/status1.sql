prompt
prompt ********  RMAN Database Backup Report *********
prompt
set serveroutput on size unlimited
declare
        l_days                  constant number := 2;
        l_place                 varchar2(400);
        l_db_name               aab_rman.rc_rman_backup_job_details.db_name%type;
        l_start_time            varchar2(40);
        l_end_time              varchar2(40);
        l_status                aab_rman.rc_rman_backup_job_details.status%type;
        l_time_taken_display    aab_rman.rc_rman_backup_job_details.time_taken_display%type;
        l_output_bytes_display  aab_rman.rc_rman_backup_job_details.output_bytes_display%type;
        l_output_device_type    aab_rman.rc_rman_backup_job_details.output_device_type%type;
        l_session_key           aab_rman.rc_rman_backup_job_details.session_key%type;
        l_session_recid         aab_rman.rc_rman_backup_job_details.session_recid%type;
        l_session_stamp         aab_rman.rc_rman_backup_job_details.session_stamp%type;

        l_operation             rab_rman.rc_rman_backup_subjob_details.operation%type;
        l_input_type            aab_rman.rc_rman_backup_subjob_details.input_type%type;

        l_command_level         varchar2(9);
        l_object_type           aab_rman.rc_rman_status.object_type%type;

        cursor bjd_cur
        (
                p_days in number
        )
        is
        select
                bjd.db_name,
                to_char(bjd.start_time, 'yyyy-mm-dd hh24:mi:ss'),
                to_char(bjd.end_time, 'yyyy-mm-dd hh24:mi:ss'),
                bjd.status,
                bjd.time_taken_display,
                bjd.output_bytes_display,
                bjd.output_device_type,
                bjd.session_key,
                bjd.session_recid,
                bjd.session_stamp
        from aab_rman.rc_rman_backup_job_details bjd
        where end_time > sysdate - p_days and (status like '%FAIL%' or status like '%WARNING%' or status like '%RUNNING%' or status like '%ERRORS%')
        order by  bjd.db_name, bjd.start_time;

begin
        l_place := 'Place 100';
        dbms_output.put_line(
                rpad('DB Name',8)
                ||' '||
                rpad('Start Time',18)
                ||' '||
                rpad('End Time',18)
                ||' '||
                rpad('Status',8)
                ||' '||
                rpad('Time Taken',8)
                ||' '||
                rpad('Output Size',8)
                ||' '||
                rpad('Type',8)
        );
        dbms_output.put_line(
                rpad('-',8,'-')
                ||' '||
                rpad('-',18,'-')
                ||' '||
                rpad('-',18,'-')
                ||' '||
                rpad('-',8,'-')
                ||' '||
                rpad('-',8,'-')
                ||' '||
                rpad('-',8,'-')
                ||' '||
                rpad('-',8,'-')
        );
        open bjd_cur (l_days);
        loop
                fetch bjd_cur
                into
                        l_db_name,
                        l_start_time,
                        l_end_time,
                        l_status,
                        l_time_taken_display,
                        l_output_bytes_display,
                        l_output_device_type,
                        l_session_key,
                        l_session_recid,
                        l_session_stamp
                ;
                exit when bjd_cur%notfound;
                dbms_output.put_line(
                        rpad(l_db_name ,8)
                        ||' '||
                        rpad(l_start_time ,18)
                        ||' '||
                        rpad(l_end_time ,18)
                        ||' '||
                        rpad(l_status ,8)
                        ||' '||
                        rpad(l_time_taken_display ,8)
                        ||' '||
                        rpad(l_output_bytes_display ,8)
                        ||' '||
                        rpad(l_output_device_type,8)
                );
                --
                --
                l_place := 'Place 300';
                if (l_status != 'COMPLETED') then
                        for bsjd_rec in (
                        select
                                operation,
                                input_type,
                                status
                        from aab_rman.rc_rman_backup_subjob_details
                        where session_stamp = l_session_stamp
                        ) loop
                        l_place := 'Place 400';
                        dbms_output.put_line(
                                '.'
                                ||' '||
                                rpad('Operation',20)
                                ||' '||
                                rpad('Input',20)
                                ||' '||
                                rpad('Status',20)
                        );
                        dbms_output.put_line(
                                '.'
                                ||' '||
                                rpad('-',20,'-')
                                ||' '||
                                rpad('-',20,'-')
                                ||' '||
                                rpad('-',20,'-')
                        );
                        dbms_output.put_line(
                                '.'
                                ||' '||
                                rpad(nvl(l_operation,'.') ,20)
                                ||' '||
                                rpad(nvl(l_input_type,'.') ,20)
                                ||' '||
                                rpad(nvl(l_status,'.') ,20)
                        );
                        end loop;
                        --
                        l_place := 'Place 500';
                        dbms_output.put_line(
                                '.  '||
                                rpad('Level' ,6)
                                ||' '||
                                rpad('Status' ,8)
                                ||' '||
                                rpad('Operation' ,20)
                                ||' '||
                                rpad('Object Type' ,20)
                        );
                        dbms_output.put_line(
                                '.  '||
                                rpad('-' ,6,'-')
                                ||' '||
                                rpad('-' ,8,'-')
                                ||' '||
                                rpad('-' ,20,'-')
                                ||' '||
                                rpad('-' ,20,'-')
                        );
                        for status_rec in (
                                select
                                        rpad('-', row_level, '-')||'>' command_level,
                                        operation,
                                        object_type,
                                        status
                                from aab_rman.rc_rman_status
                                where session_key = l_session_key
                                order by row_level, session_recid
                        ) loop
                                l_place := 'Place 600';
                                dbms_output.put_line(
                                        '.  '||
                                        rpad(nvl(status_rec.command_level,'.') ,6)
                                        ||' '||
                                        rpad(nvl(status_rec.status,'.') ,8)
                                        ||' '||
                                        rpad(nvl(status_rec.operation,'.') ,20)
                                        ||' '||
                                        rpad(nvl(status_rec.object_type,'.') ,20)
                                );
                        end loop;
                end if;
                end loop;
exception
        when OTHERS then
                dbms_output.put_line(l_place);
                raise;
end;
/


