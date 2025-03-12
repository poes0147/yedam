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


--기본키 설정(deptno)

alter table dept
add CONSTRAINT dept_deptno_pt primary key(deptno);

-- locno : not null 지정
alter table dept
modify locno not null;



--뷰

create view vdept50
as select employee_id, first_name, salary, 
        salary * 12 as annsal
    from employees
    where department_id = 50;
    

--view 급여가 10000이상인 사람 뷰, 이름(maxsal_ve)
--사번 이름(first_name), 입사일자, 직무, 부서코드, 부서이름, 급여

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
    
--사원번호, 이름, 부서코드, 부서명, 위치코드
--synonym 이용

CREATE SYNONYM empl
FOR employees;

SELECT employee_id, first_name, d.department_id, department_name, location_id
FROM empl e
join departments d on(e.department_id = d.department_id);



-- 1.사원테이블 급여가 6500이상 13000이하 이름(last_name)이 h로 시작하는
-- 사원의 사원번호, 이름(last_name), 급여, 부서번호 출력
SELECT employee_id, last_name, salary, department_id
FROM employees
where salary BETWEEN 6500 AND 13000
and lower(last_name) like '%h%';


-- 2. 50번, 60번 부서 직원 가운데 급여가 4000보다 많은 사원의 
-- 사원번호, 이름, 직무, 급여,  부서번호 출력
SELECT employee_id, last_name, job_id , salary, department_id
FROM employees
where salary > 4000
and department_id in (50,60);

-- 3. 사원번호, 이름, 급여,  인상된 급여
-- 인상된 급여 => 급여가 3000이하면 30%인상
--           => 급여가 9000이하면 20@인상
--           => 급여가 14000이하면 10인상
--              나머지는 동결


-- 4. 이름, 부서번호, 부서이름, 도시명을 출력

-- 5. 서브쿼리 이용해서 'sales' 부서에서 일하는 사원들의
-- 사원번호, 이름, 직무를 출력

-- 6. 2005년 이전에 입사한 사원들 중 직무가 'ST_SLERK'인 사원의 데이터 표시

-- 7. 추가 수당을 받는 사원의 이름, 직무, 급여, 추가수당율 표시
-- 급여에 대하여 내림차순 정렬

-- 8. 부서별 급여 평균(정수), 함께 표시
-- 부서코드, 급여평균, 금여합계 출력
-- 급여합계가 50000이상인 자료만 출력

-- 시험 1 사원 테이블에서 급여가 7000이상 12000이하이며 이름(late_name)이
--'H'로 시작하는 사원의 사원번호, 이름, 급여, 부서번호
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE salary BETWEEN 7000 AND 12000
AND upper(last_name) like 'H%';

--시험 2번 50번,60번 부서직원 가운데 급여가 5000보다 많은 사원의
--사원번호 이름(last_name), 업무(job_id), 급여, 부서번호를 출력
SELECT employee_id, last_name, job_id, salary, department_id
FROM employees
WHERE department_id in(50,60)
AND salary > 5000;


-- 시험 3. 사원번호, 이름, 급여,  인상된 급여
-- 인상된 급여 => 급여가 5000이하면 30%인상
--           => 급여가 10000이하면 20@인상
--           => 급여가 15000이하면 10인상
--           -> 급여가 15001이상이면 급여만 출력
SELECT employee_id, last_name, salary,
    CASE  WHEN salary <= 5000 THEN salary * 1.1
          WHEN salary <= 10000 THEN salary * 1.2
          WHEN salary <= 15000 THEN salary * 1.3
          WHEN salary >= 15001 THEN salary
          end as "인상된 급여"
FROM employees;

--시험 4번 DEPARTMENTS 테이블과 LOCATIONS테이블에 대하여 JOIN을 수행
-- 부서번호, 부서이름, 도시명을 출력
SELECT department_id, department_name, city
FROM departments d
JOIN locations l on(d.location_id = l.location_id);


-- 시험5. 서브쿼리 이용해서 'IT' 부서에서 근무하는(부서이름이 IT인)사원의
-- 사원번호, 이름, 직무를 출력
SELECT employee_id, last_name, job_id
FROM employees
WHERE department_id = 
    (select department_id
     from departments
     where upper(department_name) = 'IT');

-- 시험6. 2005년 이전에 입사한 사원들 중 직무가 'ST_CLERK'인 사원의 
-- 데이터 표시
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id
FROM employees
WHERE hire_date < to_date('2005-01-01','yyyy-mm-dd')
and upper(job_id) = 'ST_CLERK';


-- 시험7. 커미션을 받는 사원의 이름(last_name), 업무, 급여, 커미션을 표시
-- 데이터를 급여에 대한 내림차순으로 정렬
SELECT last_name, job_id, salary, commission_pct
FROM employees
ORDER BY salary desc;

-- 시험8번
CREATE table PROF(
    PROFNO number(4),
    NAME   varchar2(15) not null,
    ID     varchar2(15) not null,
    HIREDATE date,
    PAY    number(4)
    );
    
--시험 9번
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

--10번
--(1)
ALTER TABLE prof 
ADD CONSTRAINT prof_profno_pk PRIMARY KEY (profno);
--(2)
ALTER TABLE prof
ADD (GENDER char(3));
--(3)
ALTER TABLE prof 
MODIFY (name varchar2(20));

