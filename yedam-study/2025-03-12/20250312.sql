select *
from user_constraints;

select *
from user_cons_colums;

alter table dept
add CONSTRAINT dept_deptno_pt primary key(deptno);

delete dept
where DNAME = 'accrding';

alter table dept
modify (dname varchar2(20) not null);

alter table dept
drop CONSTRAINT sys_c007036;

alter table dept
drop CONSTRAINT dept_deptno_pk;


--�⺻Ű ����(deptno)

alter table dept
add CONSTRAINT dept_deptno_pt primary key(deptno);

-- locno : not null ����
alter table dept
modify locno not null;



--��

create view vdept50
as select employee_id, first_name, salary, 
        salary * 12 as annsal
    from employees
    where department_id = 50;
    

--view �޿��� 10000�̻��� ��� ��, �̸�(maxsal_ve)
--��� �̸�(first_name), �Ի�����, ����, �μ��ڵ�, �μ��̸�, �޿�

create view maxsal_ve
as select employee_id, first_name, hire_date, e.department_id, department_name, salary,
    salary * 12 as annsal
    from employees e
    join departments d on(e.department_id = d.department_id)
    where salary >= 10000;

SELECT * FROM maxsal_ve;

DROP VIEW maxsal_ve;

SELECT employee_id, first_name, hire_date, department_id, department_name, salary;


create sequence dept_deptno_sq
    INCREMENT By 10
    start with 300
    MAXVALUE 1000
    NOCYCLE
    NOCACHE;
    
    insert into dept
    values (dept deptno_sq;
    
    drop sequence dept_deptno_sq;
    
create sequence dept_deptno_sq
    INCREMENT By 10
    start with 10
    MAXVALUE 1000
    NOCYCLE
    NOCACHE;
    
--�����ȣ, �̸�, �μ��ڵ�, �μ���, ��ġ�ڵ�
--synonym �̿�

CREATE SYNONYM empl
FOR employees;

SELECT employee_id, first_name, d.department_id, department_name, location_id
FROM empl e
join departments d on(e.department_id = d.department_id);



-- 1.������̺� �޿��� 6500�̻� 13000���� �̸�(last_name)�� h�� �����ϴ�
-- ����� �����ȣ, �̸�(last_name), �޿�, �μ���ȣ ���
SELECT employee_id, last_name, salary, department_id
FROM employees
where salary BETWEEN 6500 AND 13000
and lower(last_name) like '%h%';


-- 2. 50��, 60�� �μ� ���� ��� �޿��� 4000���� ���� ����� 
-- �����ȣ, �̸�, ����, �޿�,  �μ���ȣ ���
SELECT employee_id, last_name, job_id , salary, department_id
FROM employees
where salary > 4000
and department_id in (50,60);

-- 3. �����ȣ, �̸�, �޿�,  �λ�� �޿�
-- �λ�� �޿� => �޿��� 3000���ϸ� 30%�λ�
--           => �޿��� 9000���ϸ� 20@�λ�
--           => �޿��� 14000���ϸ� 10�λ�
--              �������� ����


-- 4. �̸�, �μ���ȣ, �μ��̸�, ���ø��� ���

-- 5. �������� �̿��ؼ� 'sales' �μ����� ���ϴ� �������
-- �����ȣ, �̸�, ������ ���

-- 6. 2005�� ������ �Ի��� ����� �� ������ 'ST_SLERK'�� ����� ������ ǥ��

-- 7. �߰� ������ �޴� ����� �̸�, ����, �޿�, �߰������� ǥ��
-- �޿��� ���Ͽ� �������� ����

-- 8. �μ��� �޿� ���(����), �Բ� ǥ��
-- �μ��ڵ�, �޿����, �ݿ��հ� ���
-- �޿��հ谡 50000�̻��� �ڷḸ ���

-- ���� 1 ��� ���̺��� �޿��� 7000�̻� 12000�����̸� �̸�(late_name)��
--'H'�� �����ϴ� ����� �����ȣ, �̸�, �޿�, �μ���ȣ
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE salary BETWEEN 7000 AND 12000
AND upper(last_name) like 'H%';

--���� 2�� 50��,60�� �μ����� ��� �޿��� 5000���� ���� �����
--�����ȣ �̸�(last_name), ����(job_id), �޿�, �μ���ȣ�� ���
SELECT employee_id, last_name, job_id, salary, department_id
FROM employees
WHERE department_id in(50,60)
AND salary > 5000;


-- ���� 3. �����ȣ, �̸�, �޿�,  �λ�� �޿�
-- �λ�� �޿� => �޿��� 5000���ϸ� 30%�λ�
--           => �޿��� 10000���ϸ� 20@�λ�
--           => �޿��� 15000���ϸ� 10�λ�
--           -> �޿��� 15001�̻��̸� �޿��� ���
SELECT employee_id, last_name, salary,
    CASE  WHEN salary <= 5000 THEN salary * 1.1
          WHEN salary <= 10000 THEN salary * 1.2
          WHEN salary <= 15000 THEN salary * 1.3
          WHEN salary >= 15001 THEN salary
          end as "�λ�� �޿�"
FROM employees;

--���� 4�� DEPARTMENTS ���̺�� LOCATIONS���̺� ���Ͽ� JOIN�� ����
-- �μ���ȣ, �μ��̸�, ���ø��� ���
SELECT department_id, department_name, city
FROM departments d
JOIN locations l on(d.location_id = l.location_id);


-- ����5. �������� �̿��ؼ� 'IT' �μ����� �ٹ��ϴ�(�μ��̸��� IT��)�����
-- �����ȣ, �̸�, ������ ���
SELECT employee_id, last_name, job_id
FROM employees
WHERE department_id = 
    (select department_id
     from departments
     where upper(department_name) = 'IT');

-- ����6. 2005�� ������ �Ի��� ����� �� ������ 'ST_CLERK'�� ����� 
-- ������ ǥ��
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id
FROM employees
WHERE hire_date < to_date('2005-01-01','yyyy-mm-dd')
and upper(job_id) = 'ST_CLERK';


-- ����7. Ŀ�̼��� �޴� ����� �̸�(last_name), ����, �޿�, Ŀ�̼��� ǥ��
-- �����͸� �޿��� ���� ������������ ����
SELECT last_name, job_id, salary, commission_pct
FROM employees
ORDER BY salary desc;

-- ����8��
CREATE table PROF(
    PROFNO number(4),
    NAME   varchar2(15) not null,
    ID     varchar2(15) not null,
    HIREDATE date,
    PAY    number(4)
    );
    
--���� 9��
--(1)
INSERT INTO prof(profno, name, id, hiredate, pay)
values (1001, 'Mark', 'm1001', to_date('07/03/01', 'yy/mm/dd'), 800);
INSERT INTO prof(profno, name, id, hiredate, pay)
values (1003, 'Adam', 'a1003', to_date('11/03/02', 'yy/mm/dd'), null);
commit;
--(2)
UPDATE prof
SET pay = 1200
WHERE pay = 800;
--(3)
DELETE prof
WHERE profno = 1003;

--10��
--(1)
ALTER TABLE prof 
ADD CONSTRAINT prof_profno_pk PRIMARY KEY (profno);
--(2)
ALTER TABLE prof
ADD (GENDER char(3));
--(3)
ALTER TABLE prof 
MODIFY (name varchar2(20));

