-- �μ��ڵ尡 30�� 60�� 80���� 
select employee_id, first_name, salary, department_id
from employees
where salary >= 5000
and department_id in(30, 50, 90);


--�̸��� ù ���ڰ� P�� ����� �̸��� ����(�ݿ�*12)
select first_name, salary, salary * 12 as ����
from employees
where first_name like '%t%';

--2000�� ���� �Ի����� ���, �̸�, ����, �޿�
select employee_id, first_name, manager_id ,salary, hire_date
from employees
where hire_date like '05%';

--������ null�� ����� ��ȸ
select *
from employees
where commission_pct is null;

--�������� �������� , �޿����� ��������
SELECT * FROM employees
WHERE commission_pct is null
order by job_id, salary desc;

--�μ����� ��������, ������ ���� ������� ǥ��(���, �̸�, �μ��ڵ�, �޿�, ����(�޿�*12)
SELECT employee_id, first_name, manager_id, salary, salary * 12 as ���� FROM employees
WHERE commission_pct is null
order by manager_id, salary;




-- 1) ��� ���̺��� �����ȣ�� �̸��� ���� ��ȸ.
SELECT employee_id, first_name, salary
FROM employees;

-- 2) ��� ���̺��� ��� �÷� ��ȸ.
SELECT *
FROM employees;

-- 3) ��� ���̺��� �����ȣ�� �̸�, ���� ��ȸ.�÷����� �ѱ۷� '��� ��ȣ', '��� �̸�'���� ��ȸ.
SELECT employee_id  as �����ȣ, first_name as ����̸�, salary
FROM employees;

-- 4) ��� ���̺��� �̸��� ������ �̿��Ͽ� ������ ���� ��ȸ.-- - ��¿��� ) ��� �̸��� Steven �̰� ������ 30000�� ���, 'Steven �� ������ 30000 �޷��Դϴ�.'
SELECT first_name || '�� ������' ||  salary ||'�޷� �Դϴ�'
FROM employees;


-- 5) ��� ���̺��� �ߺ��� �����͸� ������ ���� ��ȸ.
SELECT DISTINCT job_id  FROM employees;


-- 6) ��� ����� �̸��� ���� ��ȸ. ������ ���� ������� ���.
SELECT first_name, salary
FROM employees
ORDER by first_name, salary desc;

-- 7) ��� ��� �� ������ 3000�� ������� �̸�, ����, ������ ��ȸ.
SELECT first_name, salary, job_id
FROM employees
WHERE salary > 3000;

-- 8) �̸��� 'Steven'�� ����� �̸�, ����, ����, �Ի���, �μ���ȣ ��ȸ.
SELECT first_name, salary, job_id, hire_date, department_id
FROM employees
WHERE first_name = 'Steven';

-- 9) ������ 36000�̻��� ������� �̸��� ������ ��ȸ.-- - ������ ���޿� ������ ���ϰ� 12�� ���ؼ� ���Ѵ�.-- - ������ ���޿� Ŀ�̼��� ���ؼ� ���Ѵ�. -- - NVL(�ʵ��,0) => �ʵ���� null�̸� 0���� ó��
SELECT first_name, (salary+(salary*commission_pct))*12 as ����
FROM employees
WHERE (salary+(salary*commission_pct))*12 > 36000;

-- 10) ������ 12000������ ������� �̸���, ����, ����, �μ���ȣ�� ��ȸ.
SELECT first_name, salary, job_id, department_id
FROM employees
WHERE salary < 12000;

-- 11) ������ 'SA_MAN'�� �ƴ� ������� �̸��� �μ���ȣ, ������ ��ȸ.
SELECT first_name, salary, job_id, department_id
FROM employees
WHERE job_id = 'SA_MAN';

-- 12) ������ 1000���� 3000������ ������� �̸��� ������ ��ȸ.
SELECT first_name, salary
FROM employees
WHERE salary BETWEEN 1000 AND 3000;

-- 13) ������ 1000���� 3000���̰� �ƴ� ������� �̸��� ������ ��ȸ
SELECT first_name, salary
FROM employees
WHERE salary not BETWEEN 1000 AND 3000;

-- 14) 2006�⵵�� �Ի��� ������� �̸��� �Ի��� ��ȸ.
SELECT first_name, hire_date
FROM employees
WHERE hire_date like '06%';

-- 15) �̸��� ù ���ڰ� S, s�� �����ϴ� ������� �̸��� ������ ��ȸ.
SELECT first_name, salary
FROM employees
WHERE first_name like 'S%';

-- 16) �̸��� �� ���ڰ� t, T�� ������ ������� �̸��� ������ ��ȸ.
SELECT first_name, salary
FROM employees
WHERE first_name like '%t';

-- 17) �̸��� �� ��° ö�ڰ� m, M �� ����� �̸��� ������ ��ȸ.
SELECT first_name, salary
FROM employees
WHERE first_name like '_m%';

-- 18) �̸��� A, a�� �����ϰ� �ִ� ������� �̸��� ��ȸ.
SELECT first_name, salary
FROM employees
WHERE first_name like '%a%' or first_name like '%A%';

-- 19) Ŀ�̼��� NULL�� ������� �̸��� Ŀ�̼��� ��ȸ.
SELECT first_name, commission_pct
FROM employees
WHERE commission_pct is null;

-- 20) ������ 'SA_MAN', 'PU_CLERK', 'IT_PROG' �� ������� �̸�, ����, ���� ��ȸ.
SELECT first_name, salary, job_id
FROM employees
WHERE job_id in ('SA_MAN', 'PU_CLERK', 'IT_PROG');


-- 21) ������ 'SA_MAN', 'PU_CLERK', 'IT_PROG' �� �ƴ� ������� �̸�, ����, ���� ��ȸ.
SELECT first_name, salary, job_id
FROM employees
WHERE NOT job_id = 'SA_MAN' and not job_id = 'PU_CLERK' and not job_id = 'IT_PROG';

SELECT first_name, salary, job_id
FROM employees
WHERE job_id not in ('SA_MAN', 'PU_CLERK', 'IT_PROG');

-- 22) ������ 'SA_MAN'�̰� ������ 1200�̻��� ������� �̸�, ����, ������ ��ȸ
SELECT first_name, salary, job_id
FROM employees
WHERE job_id = 'SA_MAN' and salary > 1200;

--��� �̸��� S�� ������ ��� ��ȸ
SELECT *
FROM employees
WHERE first_name like '%s'
OR first_name like '%S';


--30�� �μ��� �ٹ��ϴ� ����� ��å�� salesman�� ����� ���, �̸�, ��å, �޿�, �μ���ȣ
SELECT employee_id, first_name, job_id, salary, department_id
FROM employees
WHERE job_id = 'SA_MAN' and department_id = '80';

--20,50 �μ� ��ȣ�� �ٹ��ϰ�, ����� �޿��� 2000 �ʰ��� ���
