------ 서브쿼리

--표시 필드 : 사원번호, 사원이름, 급여
--조건 : 사원 전체 급여의 평균 이하인 사원만 표시
SELECT employee_id, first_name, salary
FROM employees
where salary = (select round(min(salary)) 
                from employees);
--표시 필드 : 사원번호, 사원이름, 급여
--조건 : 사원 전체 급여의 평균 이하인 사원만 표시

-- 5. King에게 보고하는(manager가 King) 모든 사원의 이름과 급여를 표시하시오.
SELECT first_name, salary
FROM employees
WHERE manager_id in (select employee_id from employees where upper(last_name) = 'KING');

--from 절으ㅔ 사용
SELECT employee_id, first_name, e.department_id, salary, salavg
from employees e,
    (select department_id, round(avg(salary)) as salavg
    from employees
    group by department_id) b
where e.department_id = b.department_id
and salavg > 6000;

--whit 활용
WHIT
b as (select department_id, round(avg(salary)) as salavg
    from employees
    group by department_id)
SELECT employee_id, first_name, e.department_id, salary, salavg
from employees e join b
on e.department_id = b.deaprtment_id
and salavg > 6000;
    
-- 1.사원테이블 급여가 6500이상 13000이하 이름(last_name)이 h로 시작하는
-- 사원의 사원번호, 이름(last_name), 급여, 부서번호 출력
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE salary between 6000 and 130000 
and LOWER(last_name) like 'h%';


-- 2. 50번, 60번 부서 직원 가운데 급여가 4000보다 많은 사원의 
-- 사원번호, 이름, 직무, 급여,  부서번호 출력
SELECT employee_id, last_name, job_id, salary, department_id
FROM employees
WHERE department_id in (50, 60)
and salary > 4000;

-- 3. 사원번호, 이름, 급여, 인상된 급여
-- 인상된 급여 => 급여가 3000이하면 30%인상
--           => 급여가 9000이하면 20@인상
--           => 급여가 14000이하면 10인상
--              나머지는 동결
SELECT employee_id, last_name, salary, 
    case when salary <= 3000 then salary*1.3
         when salary <= 9000 then salary*1.2
         when salary <= 14000 then salary*1.1
         else salary
         end as "인상된 급여"
FROM employees;
    
-- 4. 이름, 부서번호, 부서이름, 도시명을 출력
SELECT last_name, e.department_id, department_name, city
FROM employees e
JOIN departments d
    on(e.department_id = d.department_id)
JOIN locations l 
    on(d.location_id = l.location_id);
    
-- 5. 서브쿼리 이용해서 'sales' 부서에서 일하는 사원들의
-- 사원번호, 이름, 직무를 출력
with
dep_sales as (select department_id 
from departments
where lower(department_name) = 'sales')

SELECT employee_id, last_name, job_id
FROM employees e , dep_sales 
where e.department_id = dep_sales.department_id;


-- 6. 2005년 이전에 입사한 사원들 중 직무가 'ST_CLERK'인 사원의 데이터 표시
SELECT *
FROM employees
WHERE hire_date < to_date('2005-01-01', 'yyyy-mm-dd') 
and upper(job_id) = 'ST_CLERK';
                                                        
-- 7. 추가 수당을 받는 사원의 이름, 직무, 급여, 추가수당율 표시
-- 급여에 대하여 내림차순 정렬
SELECT last_name, job_id, salary, commission_pct
FROM employees
WHERE commission_pct is not null
order by salary desc;

-- 8. 부서별 급여 평균(정수), 함께 표시
-- 부서코드, 급여평균, 금여합계 출력
-- 급여합계가 50000이상인 자료만 출력
SELECT department_id, round(avg(salary)), sum(salary)
FROM employees
HAVING sum(salary) > 50000
GROUP BY department_id;


--1. Zlotkey와 동일한 부서에 속한 모든 사원의 이름과 입사일을 표시하는 
--질의를 작성하시오. Zlotkey는 결과에서 제외하시오.
SELECT last_name, hire_date
FROM employees
WHERE department_id = 
    (select department_id
    from employees
    where initcap(last_name) = 'Zlotkey');


-- 2. 급여가 평균 급여보다 많은 모든 사원의 사원 번호와 이름을 표시하는 
--질의를 작성하고 결과를 급여에 대해 오름차순으로 정렬하시오.
SELECT employee_id, last_name, salary
FROM employees
WHERE salary < (select avg(salary) from employees)
ORDER BY salary;

select department_id, last_name
    from employees 
    where lower(last_name) like '%u%';

-- 3. 이름에 u가 포함된 사원과 같은 부서에서 일하는 모든 사원의 사원 번호와
-- 이름을 표시하는 질의를 작성하고 질의를 실행하시오.
SELECT employee_id, last_name, department_id
FROM employees
WHERE department_id in
    (select department_id 
    from employees 
    where lower(last_name) like '%u%'); 

-- 4. 부서 위치 ID가 1700인 모든 사원의 이름, 부서 번호 및 업무 ID를 표시하시오.
SELECT last_name, department_id, employee_id
FROM employees
WHERE department_id in
    (select department_id
    from departments
    where location_id ='1700' );
    

-- 5. King에게 보고하는(manager가 King) 모든 사원의 이름과 급여를 표시하시오.

SELECT first_name, salary
FROM employees
WHERE manager_id in 
(select employee_id 
from employees 
where upper(last_name) = 'KING');


-- 6. Executive 부서의 모든 사원에 대한 부서 번호, 이름, 업무 ID를 표시하시오.
SELECT department_id, last_name, employee_id
FROM employees
WHERE department_id in 
    (select department_id
     from departments
     where department_name = 'Executive');

-- 7. 평균 급여보다 많은 급여를 받고, 이름에 u가 포함된 사원과 같은 부서에 근무하는 
--모든 사원의 사원번호, 이름, 급여를 표시하시오
WITH
sal_avg as (select avg(salary) as salary from employees),
name_u as (select department_id from employees where lower(last_name) like '%u%')

SELECT e.employee_id, last_name, e.salary, e.department_id
FROM employees e, sal_avg, name_u
WHERE e.salary > sal_avg.salary
and e.department_id = name_u.department_id;


------데이터 조작어
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
is '임시 테이블이다';

select *
from user_tab_comments;

comment on column dept.deptno
is 'ㅋㅋㅋㅋㅋㅋㅋ 집에가고싶어';

select *
from user_col_comments;
--테이블 생성
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
--칼럼 추가
alter table EMP_HW
ADD (bigo varchar(20));
--칼럼 수정
alter table EMP_HW
MODIFY (bigo varchar(30));
--칼럼 이름 변경
alter table EMP_HW
RENAME column bigo to REMAKE;

insert into dept
    select department_id, department_name, location_id, sysdate
    from departments;
-- 데이터 추가
INSERT INTO EMP_HW
    select employee_id, first_name, job_id, manager_id, hire_date, salary, commission_pct, department_id, null
    from employees;
    
--데이터타입 변경
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
