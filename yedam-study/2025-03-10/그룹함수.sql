-----250310------
-- �� ����� �޿��� �հ�, ���, �ִ밪, �ּҰ�, �����

SELECT SUM(salary),department_id, job_id, round(avg(salary)), max(salary), min(salary), count(*)
FROM employees
group by department_id, job_id
HAVING sum(salary) > 50000
order by department_id;

--������ �޿� �հ踦 ���ϰ�, �հ谡 30,000�̻��� �ڷḸ ǥ��
-- �հ踦 �̿��Ͽ� �������� ����
SELECT SUM(salary), job_id
FROM employees
group by job_id
HAVING sum(salary) >30000
ORDER BY sum(salary) DESC;


--ȸ�� ������ �� ǥ


--�߰������� �޴� ����� 
SELECT count(commission_pct)
FROM employees
--�߰������� ���� �����
where commission_pct is null;

--����� �޿��� �ִ밪�� �ּҰ��� ��
SELECT max(salary) - min(salary) as ����
FROM employees;

--�μ��� ���� �Ի� ����� �Ի��ϰ�, ���� �ֱ� �Ի����� �Ի��� ǥ��
--�μ��� �޿� �հ谡 3�� �̻��� �ڵ�
SELECT  MAX(hire_date), min(hire_date), department_id
FROM employees
WHERE department_id > 50
GROUP BY department_id
HAVING SUM(salary) > 30000
ORDER BY department_id;

--4. ��� ����� �޿� �ְ��, ������, �Ѿ� �� ��վ��� ǥ���Ͻÿ�. �� ���̺��� ���� 
--Maximum, Minimum, Sum, Average�� �����ϰ� ����� ������ �ݿø��ϵ��� �ۼ�
--�Ͻÿ�.
SELECT  max(salary), min(salary), SUM(salary), ROUND(avg(salary))
FROM employees;

-- 5. ���� ���Ǹ� �����Ͽ� �� ���� ����(job_id)���� �޿� �ְ��, ������, �Ѿ� �� ���
--���� ǥ���Ͻÿ�. 
SELECT job_id, max(salary), min(salary), SUM(salary), ROUND(avg(salary))
FROM employees
GROUP BY Job_id;

--6. ������ ��� ���� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ�.
SELECT job_id, count(job_id)
FROM employees
group by job_id;

-- 7. ������ ���� Ȯ���Ͻÿ�. �� ���̺��� Number of Managers�� �����Ͻÿ�. 
--(��Ʈ: MANAGER_ID ���� ���)
SELECT count(manager_id) as "Number of Managers"
FROM employees;

-- 8. �ְ� �޿��� ���� �޿��� ������ ǥ���ϴ� ���Ǹ� �ۼ��ϰ� �� ���̺��� 
--DIFFERENCE�� �����Ͻÿ�.
SELECT max(salary) - min(salary) as "DIFFERENCE"
FROM employees;

-- 9. ������ ��ȣ, �ش� �����ڿ� ���� ����� ���� �޿��� ǥ���Ͻÿ�. 
--�����ڸ� �� �� ���� ���, ���� �޿��� 6,000 �̸��� �׷��� ���ܽ�Ű�� 
--����� �����޿��� ���� ������������ �����Ͻÿ�.
SELECT manager_id, min(salary)
FROM employees
where manager_id is not null
group by manager_id
having min(salary) > 6000
order by min(salary) desc;

-- 10. ������ ǥ���� ���� �ش� ������ ���� 
--�μ� ��ȣ��(�μ� 20, 50, 80, 90) �޿� �հ��  ��� ����� �޿� �Ѿ��� ���� ǥ
--���ϴ� ���Ǹ� �ۼ��ϰ�, �� ���� ������ �Ӹ����� �����Ͻÿ�

SELECT job_id,
        sum(decode(department_id, 20, salary)) as dept20,
        sum(decode(department_id, 40, salary)) as dept40,
        sum(decode(department_id, 50, salary)) as dept50,
        sum(decode(department_id, 80, salary)) as dept80,
        sum(salary)
FROM employees
GROUP BY job_id;

--join
--�μ��ڵ�, �μ��̸�, �����ȣ
SELECT employee_id, first_name, e.department_id, department_name
FROM employees e, departments d
where e.department_id(+) = d.department_id;

--join--
--������ �ش��ϴ� �޿��� �ּ�, �ִ밪
SELECT first_name, e.job_id, salary, 
       min_salary, max_salary
       FROM employees e, jobs j
       where e.salary between min_salary and max_salary;
       
       
-- �����ȣ, �̸�, ����ȣ, ����̸�
SELECT e.employee_id, e.first_name, e.manager_id, e2.manager_id, e2.first_name
FROM employees e, employees e2;

--�μ��ڵ�, �μ��̸�, ���ø�
SELECT e.department_id, department_name, d.location_id, l.location_id, l.city
FROM employees e, departments d, locations l
where d.location_id = l.location_id
order by department_id;

--���߷� ����
SELECT employee_id, department_id, department_name
FROM employees e natural join departments d
order by department_id;

SELECT employee_id, e.department_id, department_name
FROM employees e ,departments d
where e.employee_id = d.department_id
    and e.manager_id = d.manager_id
order by department_id;

SELECT employee_id, department_id, department_name
FROM employees e JOIN departments d USING (department_id);

SELECT department_id, department_name, employee_id, first_name, salary
FROM employees e 
JOIN departments d using(department_id)
where salary > 13000;

SELECT department_id, department_name, round(avg(salary)), max(salary),
    min(salary), count(employee_id)
FROM employees e
JOIN departments d using(department_id)
--JOIN departments d on(e.department_id = d.department_id)
GROUP BY department_id, department_name
order by department_id;

SELECT department_id, department_name, employee_id, first_name, job_title, salary
FROM employees e
left JOIN departments d using(department_id)
JOIN jobs j using(job_id)
order by first_name;


SELECT e.department_id, d.department_name, e.employee_id as �����ȣ, e.first_name as ����̸�, e.manager_id,
    e.salary, e2.employee_id as �����ȣ, e2.first_name as ����̸�
FROM employees e
RIGHT JOIN departments d on(e.department_id = d.department_id)
LEFT JOIN employees e2 on(e2.employee_id = e.manager_id)
ORDER BY e.employee_id;

--LOCATIONS, COUNTRIES ���̺��� ����Ͽ� ��� �μ��� �ּҸ� �����ϴ� query�� �ۼ��Ͻÿ�. 
--��¿� ��ġ ID, �ּ�, ��/��, ��/�� �� ������ ǥ���ϸ�, NATURAL JOIN�� ����Ͽ� ����� �����մϴ�.
SELECT country_id, location_id, street_address, country_name, region_id
FROM countries c
NATURAL JOIN locations l;

-- 2. ��� ����� last_name, �Ҽ� �μ���ȣ, �μ� �̸��� ǥ���ϴ� query�� �ۼ��Ͻÿ�
SELECT last_name, department_id, department_name
FROM employees e
LEFT JOIN departments d using(department_id);

-- 3. Toronto�� �ٹ��ϴ� ����� ���� ������ �ʿ�� �մϴ�. 
--toronto���� �ٹ��ϴ� ��� ����� last_name, ����, �μ���ȣ, �μ� �̸��� ǥ���Ͻÿ�. (��Ʈ : 3-way join ���)

SELECT last_name, job_id, department_id, department_name
FROM employees e
JOIN departments d using(department_id)
JOIN locations l using(location_id)
where city = 'Toronto';

-- 4. ����� last_name, ��� ��ȣ�� �ش� �������� last_name, ������ ��ȣ�� �Բ� ǥ���ϴ� ������ �ۼ��Ͻÿ�.  
--�� ���̺��� ���� Employee, Emp#, Manager, Mgr#���� �����Ͻÿ�
SELECT e.last_name, e.employee_id, e2.last_name, e.manager_id, e2.employee_id
FROM employees e
left JOIN employees e2 on(e.manager_id = e2.employee_id)
order by e.employee_id;

-- 5. King�� ���� �ش� �����ڰ� �������� ���� ��� ����� ǥ���ϵ��� 4�� ������ �����մϴ�. ��� ��ȣ������ ����� �����Ͻÿ�. 
SELECT e.last_name, e.employee_id, e2.last_name, e.manager_id, e2.employee_id
FROM employees e
left JOIN employees e2 on(e.manager_id = e2.employee_id)
where e.manager_id is null
order by e.employee_id;

--6. ����� last_name, �μ� ��ȣ,  ���� �μ��� �ٹ��ϴ� ��� ����� ǥ���ϴ� ����
--�� �ۼ��Ͻÿ�. �� ���� ������ ���̺��� �����Ӱ� ������ ���ϴ�

SELECT e.last_name as ����̸� , e.department_id as �μ���ȣ,  e2.last_name
FROM employees e
JOIN employees e2 on(e2.department_id = e.department_id)
where e.employee_id <> e2.employee_id
order by e2.last_name;

-- 7. ����, �޿��� ���� ������ �ʿ�� �մϴ�. ���� JOBS���̺��� ������ ǥ���� ����,
--��� ����� �̸�, ����, �μ� �̸�, �޿��� ǥ���ϴ� query�� �ۼ��Ͻÿ�.
SELECT first_name, job_id, job_title, department_name, salary 
FROM jobs j
JOIN employees e using(job_id)
JOIN departments d
   USING (department_id)
   order by job_id;

-- �μ����� it�� ����� �̸��� �μ��ڵ� ����
select first_name, department_id
from employees
where department_id = (select department_id 
from departments where upper(department_name) = 'IT');

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