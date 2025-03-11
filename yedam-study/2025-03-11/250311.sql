------ ��������

--ǥ�� �ʵ� : �����ȣ, ����̸�, �޿�
--���� : ��� ��ü �޿��� ��� ������ ����� ǥ��
SELECT employee_id, first_name, salary
FROM employees
where salary = (select round(min(salary)) 
                from employees);
--ǥ�� �ʵ� : �����ȣ, ����̸�, �޿�
--���� : ��� ��ü �޿��� ��� ������ ����� ǥ��

-- 5. King���� �����ϴ�(manager�� King) ��� ����� �̸��� �޿��� ǥ���Ͻÿ�.
SELECT first_name, salary
FROM employees
WHERE manager_id in (select employee_id from employees where upper(last_name) = 'KING');

--from ������ ���
SELECT employee_id, first_name, e.department_id, salary, salavg
from employees e,
    (select department_id, round(avg(salary)) as salavg
    from employees
    group by department_id) b
where e.department_id = b.department_id
and salavg > 6000;

--whit Ȱ��
WHIT
b as (select department_id, round(avg(salary)) as salavg
    from employees
    group by department_id)
SELECT employee_id, first_name, e.department_id, salary, salavg
from employees e join b
on e.department_id = b.deaprtment_id
and salavg > 6000;
    
-- 1.������̺� �޿��� 6500�̻� 13000���� �̸�(last_name)�� h�� �����ϴ�
-- ����� �����ȣ, �̸�(last_name), �޿�, �μ���ȣ ���
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE salary between 6000 and 130000 
and LOWER(last_name) like 'h%';


-- 2. 50��, 60�� �μ� ���� ��� �޿��� 4000���� ���� ����� 
-- �����ȣ, �̸�, ����, �޿�,  �μ���ȣ ���
SELECT employee_id, last_name, job_id, salary, department_id
FROM employees
WHERE department_id in (50, 60)
and salary > 4000;

-- 3. �����ȣ, �̸�, �޿�, �λ�� �޿�
-- �λ�� �޿� => �޿��� 3000���ϸ� 30%�λ�
--           => �޿��� 9000���ϸ� 20@�λ�
--           => �޿��� 14000���ϸ� 10�λ�
--              �������� ����
SELECT employee_id, last_name, salary, 
    case when salary <= 3000 then salary*1.3
         when salary <= 9000 then salary*1.2
         when salary <= 14000 then salary*1.1
         else salary
         end as "�λ�� �޿�"
FROM employees;
    
-- 4. �̸�, �μ���ȣ, �μ��̸�, ���ø��� ���
SELECT last_name, e.department_id, department_name, city
FROM employees e
JOIN departments d
    on(e.department_id = d.department_id)
JOIN locations l 
    on(d.location_id = l.location_id);
    
-- 5. �������� �̿��ؼ� 'sales' �μ����� ���ϴ� �������
-- �����ȣ, �̸�, ������ ���
with
dep_sales as (select department_id 
from departments
where lower(department_name) = 'sales')

SELECT employee_id, last_name, job_id
FROM employees e , dep_sales 
where e.department_id = dep_sales.department_id;


-- 6. 2005�� ������ �Ի��� ����� �� ������ 'ST_CLERK'�� ����� ������ ǥ��
SELECT *
FROM employees
WHERE hire_date < to_date('2005-01-01', 'yyyy-mm-dd') 
and upper(job_id) = 'ST_CLERK';
                                                        
-- 7. �߰� ������ �޴� ����� �̸�, ����, �޿�, �߰������� ǥ��
-- �޿��� ���Ͽ� �������� ����
SELECT last_name, job_id, salary, commission_pct
FROM employees
WHERE commission_pct is not null
order by salary desc;

-- 8. �μ��� �޿� ���(����), �Բ� ǥ��
-- �μ��ڵ�, �޿����, �ݿ��հ� ���
-- �޿��հ谡 50000�̻��� �ڷḸ ���
SELECT department_id, round(avg(salary)), sum(salary)
FROM employees
HAVING sum(salary) > 50000
GROUP BY department_id;


--1. Zlotkey�� ������ �μ��� ���� ��� ����� �̸��� �Ի����� ǥ���ϴ� 
--���Ǹ� �ۼ��Ͻÿ�. Zlotkey�� ������� �����Ͻÿ�.
SELECT last_name, hire_date
FROM employees
WHERE department_id = 
    (select department_id
    from employees
    where initcap(last_name) = 'Zlotkey');


-- 2. �޿��� ��� �޿����� ���� ��� ����� ��� ��ȣ�� �̸��� ǥ���ϴ� 
--���Ǹ� �ۼ��ϰ� ����� �޿��� ���� ������������ �����Ͻÿ�.
SELECT employee_id, last_name, salary
FROM employees
WHERE salary < (select avg(salary) from employees)
ORDER BY salary;

select department_id, last_name
    from employees 
    where lower(last_name) like '%u%';

-- 3. �̸��� u�� ���Ե� ����� ���� �μ����� ���ϴ� ��� ����� ��� ��ȣ��
-- �̸��� ǥ���ϴ� ���Ǹ� �ۼ��ϰ� ���Ǹ� �����Ͻÿ�.
SELECT employee_id, last_name, department_id
FROM employees
WHERE department_id in
    (select department_id 
    from employees 
    where lower(last_name) like '%u%'); 

-- 4. �μ� ��ġ ID�� 1700�� ��� ����� �̸�, �μ� ��ȣ �� ���� ID�� ǥ���Ͻÿ�.
SELECT last_name, department_id, employee_id
FROM employees
WHERE department_id in
    (select department_id
    from departments
    where location_id ='1700' );
    

-- 5. King���� �����ϴ�(manager�� King) ��� ����� �̸��� �޿��� ǥ���Ͻÿ�.

SELECT first_name, salary
FROM employees
WHERE manager_id in 
(select employee_id 
from employees 
where upper(last_name) = 'KING');


-- 6. Executive �μ��� ��� ����� ���� �μ� ��ȣ, �̸�, ���� ID�� ǥ���Ͻÿ�.
SELECT department_id, last_name, employee_id
FROM employees
WHERE department_id in 
    (select department_id
     from departments
     where department_name = 'Executive');

-- 7. ��� �޿����� ���� �޿��� �ް�, �̸��� u�� ���Ե� ����� ���� �μ��� �ٹ��ϴ� 
--��� ����� �����ȣ, �̸�, �޿��� ǥ���Ͻÿ�
WITH
sal_avg as (select avg(salary) as salary from employees),
name_u as (select department_id from employees where lower(last_name) like '%u%')

SELECT e.employee_id, last_name, e.salary, e.department_id
FROM employees e, sal_avg, name_u
WHERE e.salary > sal_avg.salary
and e.department_id = name_u.department_id;


------������ ���۾�
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
is '�ӽ� ���̺��̴�';

select *
from user_tab_comments;

comment on column dept.deptno
is '�������������� ��������;�';

select *
from user_col_comments;
--���̺� ����
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
--Į�� �߰�
alter table EMP_HW
ADD (bigo varchar(20));
--Į�� ����
alter table EMP_HW
MODIFY (bigo varchar(30));
--Į�� �̸� ����
alter table EMP_HW
RENAME column bigo to REMAKE;

insert into dept
    select department_id, department_name, location_id, sysdate
    from departments;
-- ������ �߰�
INSERT INTO EMP_HW
    select employee_id, first_name, job_id, manager_id, hire_date, salary, commission_pct, department_id, null
    from employees;
    
--������Ÿ�� ����
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
