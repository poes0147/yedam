-- DUAL�� ���̵�����.
SELECT sysdate +5
FROM dual;
-- upper �ҹ��ڸ� �빮�ڷ�
SELECT upper('ye dam')
FROM dual;
-- lower �빮�ڸ� �ҹ��ڷ�
SELECT lower('YE DAM')
FROM dual;
-- initcap ù���ڸ� �빮�ڷ�
SELECT initcap('ye dam')
FROM dual;

--first name ù ���ڰ� s�� ����� �̸�, �޿�, �μ��� ��ȸ

SELECT first_name, salary, department_id
FROM employees
where lower(first_name) like '%s%';

-- concat ���ڿ� ��ġ��
SELECT concat ('Ye',' Dam')
FROM dual;

--�̸����� ����° ���ڸ� ǥ��, �̸��� ���ڼ� ǥ��, �μ��ڵ�
--�̸��� a�� ��ġ ǥ��(��ҹ��� ���� ���� ã��)
--last_name 10�ڸ��� ǥ��, ���ʿ� * ü���)
--�޿� ǥ��, �� : 1000�޷� �޿��� 5000 ������
--�μ��ڵ尡 80�� �����͸� ��ȸ

lpad('',

SELECT lpad(salary, salary/1000+5,'��'), salary
FROM employees
where department_id = 80;

SELECT lengthb('abc'), lengthb('�ѱ�')
FROM dual;

--�ֹι�ȣ�� ���ڸ��� *�� ��ŷ
select '050307-4684818', replace('050307-4684818', substr('050307-4684818',-6,6), '******') as �ֹε�Ϲ�ȣ,
trim('        �ѱ�'), '          �ѱ�'
FROM dual;

--�����ȣ�� Ȧ���� 1, ¦���� 0�� ǥ�õǵ��� �Ͻÿ�
-- ��� ��ȣ, �̸�, Ȧ¦ ����

SELECT employee_id, first_name, mod(employee_id,2)
FROM employees
where department_id = 80;

SELECT sysdate
FROM dual;

-- ���, �̸�, �Ի���, 1�Ի� 6����, �ټӰ���
SELECT employee_id, first_name, hire_date,add_months(hire_date, 6), trunc(MONTHS_BETWEEN(SYSDATE,hire_date))
    , next_day(SYSDATE,'��')
FROM employees;

ALTER SESSION set
nls_date_format = 'rrrr-mm-dd hh24:mi:ss';
--nls_date_format = 'rrrr-mm-dd hh24:mi:ss';

SELECT
    * FROM employees;

SELECT sysdate,
        round(sysdate, 'CC'),
        round(sysdate, 'yyyy'),
        round(sysdate, 'q'),
        round(sysdate, 'ddd')
from dual;

-- 23) ��� ���̺��� �̸��� ��ȸ. 
--�� ù ��° �÷��� �̸��� �빮�ڷ� ����ϰ�, 
--�� ��° �÷��� �̸��� �ҹ��ڷ� ����ϰ�,
--�� ��° �÷��� �̸��� ù ��° ö�ڴ� �빮�ڷ�, 
--�������� �ҹ��ڷ� ��ȸ.
SELECT UPPER(first_name),lower(first_name),initcap(first_name)
FROM employees;



-- 24) �̸��� alexander(��� �ҹ��ڷ� ��ȯ)�� ����� �̸��� ���� ��ȸ.
SELECT first_name, salary
FROM employees
WHERE lower(first_name) = 'alexander';


-- 25) ���� �ܾ� SMITH���� SMI�� �߶� ��ȸ.
SELECT SUBSTR('SMITH',1,3)
FROM dual;

-- 26) ������� �̸�(last_name)�� �̸��� ö�� ������ ���.
SELECT last_name, length(last_name)
FROM employees;


-- 27) �̸��� �ҹ��� a�� �����ϴ� ��� �� ��° �ڸ��� ��ġ�ϴ��� ��ȸ.
SELECT first_name, instr(first_name,'a') 
FROM employees;


-- 28) ������� �̸��� ������ ��ȸ. �� ���� �÷��� �ڸ����� 10�ڸ��� �ϰ�, 
--������ ����ϰ� ���� ������ �ڸ��� *(��ǥ)�� ä���� ��ȸ.

SELECT first_name, lpad(salary,10,'*')
FROM employees;

-- 29) ������� �̸��� ���� ��ȸ. �� ������ 1000�� �׸�(��) �ϳ��� ���.
SELECT first_name, lpad('��',salary/1000,'��'),salary
FROM employees;

-- 30) ���� 876.567�� �Ҽ��� �� ��° �ڸ����� ���(�ݿø� ó��)
SELECT ROUND('876.567',2)
FROM dual;


-- 31) ���� 876.567�� �Ҽ� ù° �ڸ����� ���(���� ó��)
SELECT TRUNC('876.567',1)
FROM dual;


-- 32) ���� 10�� 3���� ���� ������ ���� ���.
SELECT MOD('10',3)
FROM dual;


-- 33) ��� ��ȣ�� ��� ��ȣ�� Ȧ���̸� 1, ¦���̸� 0�� ���.
SELECT employee_id, mod(employee_id,2)
FROM employees;

-- 34) �����ȣ�� ¦���� ������� ��� ��ȣ�� �̸��� ��ȸ.
SELECT employee_id, first_name
FROM employees
where mod(employee_id,2) = 0;

-- 35) ����� �̸��� �Ի��� ��¥���� ���ñ��� �� �� ���� �ٹ��ߴ��� ��ȸ(����).
SELECT first_name, TRUNC(MONTHS_BETWEEN(SYSDATE, hiRe_date))
FROM employees;

----------------��ȯ�Լ�----------
--���ں�ȯ�Լ� : ����, ��¥, =>  ���ڿ�
SELECT first_name, hire_date, to_char(hire_date, 'yyyy/mm'), to_char(salary, '$999,999')
from employees;

ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

-- nvl null�� ��ȯ�ϴ� �Լ�
--�߰� ������ NULL�̸� 200, �ƴϸ� �޿�*������ 
-- ���, �̸�, �޿�, �߰�����
SELECT employee_id, first_name, salary, NVL2(commission_pct, to_char(commission_pct*salary),'���ʽ�����') as �߰�����
FROM employees;

--if then else
--�޿��� <1000 30%�λ� <2000 20%�λ� <3000 10%�λ� ������ ����

SELECT first_name, salary,
        case  when salary < 1000 then salary * 1.3
              when salary < 2000 then salary * 1.2
              when salary < 3000 then salary * 1.1
              else salary
              END
        as "�λ�� �޿�"
FROM employees;

--�μ��ڵ尡 20,30,50 ����
-- 60,70,80 �뱸
-- ������ ����
SELECT first_name, department_id,
        case  when department_id in (20,30,50) then '����'
              when department_id in (60,70,80) then  '�뱸'
              else '����'
              end
              as "�μ��̵�"
FROM employees;

-- 36) 2018�� 10�� 1�Ͽ��� 2019�� 6�� 1�� ������ ���ϼ� ���.
SELECT TO_DATE('2019-06-01', 'YYYY-MM-DD') - TO_DATE('2018-10-01', 'YYYY-MM-DD') AS total_days 
FROM DUAL;


-- 37) 2018�� 10�� 1�Ͽ��� 2019�� 6�� 1�� ������ �� ��(Week) ���� ���(����).
SELECT CEIL((TO_DATE('2019-06-01', 'YYYY-MM-DD') - TO_DATE('2018-10-01', 'YYYY-MM-DD'))/7) AS total 
FROM DUAL;

-- 38) 2023�� 5�� 1�Ϸκ��� 100�� ���� ��¥ ���.
SELECT ADD_MONTHS(TO_DATE('2023-05-01', 'YYYY-MM-DD'), 100)
FROM dual;

-- 39) 2023�� 5�� 1�Ϸκ��� 100�� �� ��¥ ���.
SELECT to_date('2023-05-01', 'yyyy-mm-dd') + 100
FROM dual;

-- 40) 2023�� 6�� 30�� ���� �ٷ� ���ƿ� ȭ������ ��¥ ���
SELECT next_day(to_date('2023-06-30', 'yyyy-mm-dd'),'ȭ')
FROM dual;

-- 41) 2023�� 9�� 19�� ���� �ٷ� ���ƿ� ������� ��¥ ���
SELECT next_day(to_date('2023-09-19', 'yyyy-mm-dd'),'��')
FROM dual;

-- 42) ���� ���� ���ƿ� �ݿ����� ��¥ ���
SELECT next_day(sysdate, '��')
FROM dual;

-- 43) 2020�� 5�� 22�Ϻ��� 100�� �ڿ� ���ƿ��� ȭ������ ��¥ ���
SELECT next_day(ADD_MONTHS(TO_DATE('2020-05-22','YYYY-MM-DD'),100),'ȭ')
FROM dual;

-- 44) ���ú��� 100�� �ڿ� ���ƿ��� �������� ��¥ ���
SELECT NEXT_DAY(ADD_MONTHS(SYSDATE,100),'��')
FROM dual;

-- 45) 2019�� 5�� 22�� �ش� ���� ������ ��¥�� ��� �Ǵ��� ��ȸ
SELECT LAST_DAY(TO_DATE('2019-05-22','YYYY-MM-DD'))
FROM dual;

-- 46) ���ú��� �̹� �� ���ϱ��� �� ��ĥ ���Ҵ��� ��ȸ
SELECT  LAST_DAY(SYSDATE)- SYSDATE
FROM dual;

-- 47) �̸��� SUSAN�� ����� �̸�, �Ի���, 
-- �Ի��� ���� ������ ��¥�� ��ȸ
SELECT first_name, hire_date, last_day(hire_date)
FROM employees
WHERE upper(first_name) = 'SUSAN';

-- 48) �̸�(last_name)�� GRANT(�빮�ڷ� ��ȯ)�� ����� �̸��� �Ի��� ������ ����ϰ�,
--GRANT�� ���޿� õ������ ������ �� �ִ� �޸�(,)�� �ٿ� ��ȸ
SELECT last_name, hire_date, to_char(salary, '$999,999')
FROM employees
WHERE upper(last_name) = 'GRANT';

-- 50) 2008�⵵�� �Ի��� ����� �̸��� �Ի��� ��ȸ(to_char �Լ� ���)
SELECT first_name, hire_date
FROM employees
WHERE to_char(hire_date) like '08%';

-- 51) ������ 1500 �̻��� ����� �̸���, ���޿� õ������ ������ �� �ִ� �޸�(,)�� ȭ������� �ٿ� ��ȸ
SELECT first_name, to_char(salary, '$999,999')
FROM employees
WHERE salary > 15000;

-- 52) 2005�� 06�� 14�Ͽ� �Ի��� ����� �̸��� �Ի��� ��ȸ(to_date �Լ� ���)
-- 53) ����� �̸��� Ŀ�̼��� ��ȸ. (�� Ŀ�̼��� NULL�� ������� 0)
-- 54) ������ 'SA_MAN' �Ǵ� 'IT_PROG' �� ����� ����, �߰�����, ���޿� ��ȸ - �߰����� : ���� * Ŀ�̼�(�� Ŀ�̼��� NULL�� ��� 0)- ���޿� : ���� + �߰�����
-- 55) ����� �̸��� �μ� ��ȣ, ���ʽ� ��ȸ���ʽ� : �μ� ��ȣ�� 10���̸� 300, 20���̸� 400, ������ �μ� ��ȣ�� 0
-- 56) ��� ��ȣ�� ��� ��ȣ�� ¦������ Ȧ�������� ��ȸ
-- 57) ����� �̸�, ����, ���ʽ� ��ȸ�� ������ 'SA_MAN'�̸� ���ʽ� 5000 ������ ������ ���ʽ� 2000
-- 58) ����� �̸�, ����, ����, ���ʽ� ��ȸ- ���ʽ� : ������ 3000�̻��̸� 500, ������ 2000�̻� 3000�̸��̸� 300, ������ 1000�̻� 2000�̸��̸� 200, �������� 0
-- 59) ����� �̸�, ����, Ŀ�̼�, ���ʽ� ��ȸ. ���ʽ� : Ŀ�̼��� NULL�̸� 500, NULL�� �ƴϸ� 0
-- 60) ����� �̸�, ����, ���ʽ� ��ȸ - ���ʽ��� ������ 'SA_MAN', 'PU_CLERK' �̸� 500, 'ST_CLERK', 'FI_ACCOUNT'�̸� 400������  0

