------ 辞崎汀軒

--妊獣 琶球 : 紫据腰硲, 紫据戚硯, 厭食
--繕闇 : 紫据 穿端 厭食税 汝液 戚馬昔 紫据幻 妊獣
SELECT employee_id, first_name, salary
FROM employees
where salary = (select round(min(salary)) 
                from employees);
--妊獣 琶球 : 紫据腰硲, 紫据戚硯, 厭食
--繕闇 : 紫据 穿端 厭食税 汝液 戚馬昔 紫据幻 妊獣

-- 5. King拭惟 左壱馬澗(manager亜 King) 乞窮 紫据税 戚硯引 厭食研 妊獣馬獣神.
SELECT first_name, salary
FROM employees
WHERE manager_id in (select employee_id from employees where upper(last_name) = 'KING');

--from 箭生つ 紫遂
SELECT employee_id, first_name, e.department_id, salary, salavg
from employees e,
    (select department_id, round(avg(salary)) as salavg
    from employees
    group by department_id) b
where e.department_id = b.department_id
and salavg > 6000;

--whit 醗遂
WHIT
b as (select department_id, round(avg(salary)) as salavg
    from employees
    group by department_id)
SELECT employee_id, first_name, e.department_id, salary, salavg
from employees e join b
on e.department_id = b.deaprtment_id
and salavg > 6000;
    
-- 1.紫据砺戚鷺 厭食亜 6500戚雌 13000戚馬 戚硯(last_name)戚 h稽 獣拙馬澗
-- 紫据税 紫据腰硲, 戚硯(last_name), 厭食, 採辞腰硲 窒径
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE salary between 6000 and 130000 
and LOWER(last_name) like 'h%';


-- 2. 50腰, 60腰 採辞 送据 亜錘汽 厭食亜 4000左陥 弦精 紫据税 
-- 紫据腰硲, 戚硯, 送巷, 厭食,  採辞腰硲 窒径
SELECT employee_id, last_name, job_id, salary, department_id
FROM employees
WHERE department_id in (50, 60)
and salary > 4000;

-- 3. 紫据腰硲, 戚硯, 厭食, 昔雌吉 厭食
-- 昔雌吉 厭食 => 厭食亜 3000戚馬檎 30%昔雌
--           => 厭食亜 9000戚馬檎 20@昔雌
--           => 厭食亜 14000戚馬檎 10昔雌
--              蟹袴走澗 疑衣
SELECT employee_id, last_name, salary, 
    case when salary <= 3000 then salary*1.3
         when salary <= 9000 then salary*1.2
         when salary <= 14000 then salary*1.1
         else salary
         end as "昔雌吉 厭食"
FROM employees;
    
-- 4. 戚硯, 採辞腰硲, 採辞戚硯, 亀獣誤聖 窒径
SELECT last_name, e.department_id, department_name, city
FROM employees e
JOIN departments d
    on(e.department_id = d.department_id)
JOIN locations l 
    on(d.location_id = l.location_id);
    
-- 5. 辞崎汀軒 戚遂背辞 'sales' 採辞拭辞 析馬澗 紫据級税
-- 紫据腰硲, 戚硯, 送巷研 窒径
with
dep_sales as (select department_id 
from departments
where lower(department_name) = 'sales')

SELECT employee_id, last_name, job_id
FROM employees e , dep_sales 
where e.department_id = dep_sales.department_id;


-- 6. 2005鰍 戚穿拭 脊紫廃 紫据級 掻 送巷亜 'ST_CLERK'昔 紫据税 汽戚斗 妊獣
SELECT *
FROM employees
WHERE hire_date < to_date('2005-01-01', 'yyyy-mm-dd') 
and upper(job_id) = 'ST_CLERK';
                                                        
-- 7. 蓄亜 呪雁聖 閤澗 紫据税 戚硯, 送巷, 厭食, 蓄亜呪雁晴 妊獣
-- 厭食拭 企馬食 鎧顕託授 舛慶
SELECT last_name, job_id, salary, commission_pct
FROM employees
WHERE commission_pct is not null
order by salary desc;

-- 8. 採辞紺 厭食 汝液(舛呪), 敗臆 妊獣
-- 採辞坪球, 厭食汝液, 榎食杯域 窒径
-- 厭食杯域亜 50000戚雌昔 切戟幻 窒径
SELECT department_id, round(avg(salary)), sum(salary)
FROM employees
HAVING sum(salary) > 50000
GROUP BY department_id;


--1. Zlotkey人 疑析廃 採辞拭 紗廃 乞窮 紫据税 戚硯引 脊紫析聖 妊獣馬澗 
--霜税研 拙失馬獣神. Zlotkey澗 衣引拭辞 薦須馬獣神.
SELECT last_name, hire_date
FROM employees
WHERE department_id = 
    (select department_id
    from employees
    where initcap(last_name) = 'Zlotkey');


-- 2. 厭食亜 汝液 厭食左陥 弦精 乞窮 紫据税 紫据 腰硲人 戚硯聖 妊獣馬澗 
--霜税研 拙失馬壱 衣引研 厭食拭 企背 神硯託授生稽 舛慶馬獣神.
SELECT employee_id, last_name, salary
FROM employees
WHERE salary < (select avg(salary) from employees)
ORDER BY salary;

select department_id, last_name
    from employees 
    where lower(last_name) like '%u%';

-- 3. 戚硯拭 u亜 匂敗吉 紫据引 旭精 採辞拭辞 析馬澗 乞窮 紫据税 紫据 腰硲人
-- 戚硯聖 妊獣馬澗 霜税研 拙失馬壱 霜税研 叔楳馬獣神.
SELECT employee_id, last_name, department_id
FROM employees
WHERE department_id in
    (select department_id 
    from employees 
    where lower(last_name) like '%u%'); 

-- 4. 採辞 是帖 ID亜 1700昔 乞窮 紫据税 戚硯, 採辞 腰硲 貢 穣巷 ID研 妊獣馬獣神.
SELECT last_name, department_id, employee_id
FROM employees
WHERE department_id in
    (select department_id
    from departments
    where location_id ='1700' );
    

-- 5. King拭惟 左壱馬澗(manager亜 King) 乞窮 紫据税 戚硯引 厭食研 妊獣馬獣神.

SELECT first_name, salary
FROM employees
WHERE manager_id in 
(select employee_id 
from employees 
where upper(last_name) = 'KING');


-- 6. Executive 採辞税 乞窮 紫据拭 企廃 採辞 腰硲, 戚硯, 穣巷 ID研 妊獣馬獣神.
SELECT department_id, last_name, employee_id
FROM employees
WHERE department_id in 
    (select department_id
     from departments
     where department_name = 'Executive');

-- 7. 汝液 厭食左陥 弦精 厭食研 閤壱, 戚硯拭 u亜 匂敗吉 紫据引 旭精 採辞拭 悦巷馬澗 
--乞窮 紫据税 紫据腰硲, 戚硯, 厭食研 妊獣馬獣神
WITH
sal_avg as (select avg(salary) as salary from employees),
name_u as (select department_id from employees where lower(last_name) like '%u%')

SELECT e.employee_id, last_name, e.salary, e.department_id
FROM employees e, sal_avg, name_u
WHERE e.salary > sal_avg.salary
and e.department_id = name_u.department_id;


------汽戚斗 繕拙嬢
create table dept(
    deptNo  number(4),
    dname   varchar2(20),
    loc     varchar2(20),
    make_date   date
);

insert into dept
VALUES(10,'sales','deagu',sysdate);

insert into dept
VALUES(20,'accrding','deagu',sysdate);

insert into dept
VALUES(40,'it','busan',sysdate);

insert into dept
VALUES(50,'it','busan','25/2/5');

insert into dept
    select department_id, department_name, location_id, sysdate
    from departments;
    
commit;

delete dept
where deptno < 100;

delete dept
where deptno = (select department_id
                from employees
                where employee_id = 150);

rollback;

delete departments
where department_id = 50;

delete employees
where department_id = 30;

update dept
set deptno = 200

update employees
set department_id = 22
where department_id =20;

DELETE dept
where deptno = 200;
DELETE dept
where deptno = 20;

rollback a;


SELECT *
FROM user_objects;

create table emp
as
    select * 
    from employees
    where employee_id < 150;
    
alter table dept
add (bigo varchar2(10));

alter table dept
modify   (bigo varchar2(10));

alter table dept
drop column bigo;

drop table dept;

flashback table "HR"."BIN$ak+bkvRWSBe0nMt5CdZKyQ==$0" to before drop rename to dept2;

rename dept2 to dept;

alter table dept
rename column loc to locno;

comment on table dept
is '績獣 砺戚鷺戚陥';

select *
from user_tab_comments;

comment on column dept.deptno
is 'せせせせせせせ 増拭亜壱粛嬢';

select *
from user_col_comments;
--砺戚鷺 持失
create table EMP_HW(
    EMPNO number(4),
    ENMAE varchar2(10),
    JOB   varchar2(9),
    MGR   number(4),
    HIREDATE date,
    SAL   number(7,2),
    COMM  number(7,2),
    DEPTNO number(2)
    );
--町軍 蓄亜
alter table EMP_HW
ADD (bigo varchar(20));
--町軍 呪舛
alter table EMP_HW
MODIFY (bigo varchar(30));
--町軍 戚硯 痕井
alter table EMP_HW
RENAME column bigo to REMAKE;

insert into dept
    select department_id, department_name, location_id, sysdate
    from departments;
-- 汽戚斗 蓄亜
INSERT INTO EMP_HW
    select employee_id, first_name, job_id, manager_id, hire_date, salary, commission_pct, department_id, null
    from employees;
    
--汽戚斗展脊 痕井
ALTER TABLE EMP_HW
MODIFY     (EMPNO number(6));
ALTER TABLE EMP_HW
MODIFY           (ENAME varchar2(20));
ALTER TABLE EMP_HW
MODIFY           (JOB   varchar2(10));
ALTER TABLE EMP_HW
MODIFY           (MGR   number(6));
ALTER TABLE EMP_HW
MODIFY           (HIREDATE date);
ALTER TABLE EMP_HW
MODIFY           (SAL   number(8,2));
ALTER TABLE EMP_HW
MODIFY           (COMM  number(2,2));
ALTER TABLE EMP_HW
MODIFY           (DEPTNO number(4));

ALTER TABLE EMP_HW
RENAME column ENMAE TO ENAME;
