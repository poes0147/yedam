-----250310------
-- 전 사원의 급여의 합계, 평균, 최대값, 최소값, 사원수

SELECT SUM(salary),department_id, job_id, round(avg(salary)), max(salary), min(salary), count(*)
FROM employees
group by department_id, job_id
HAVING sum(salary) > 50000
order by department_id;

--직무별 급여 합계를 구하고, 합계가 30,000이상인 자료만 표시
-- 합계를 이용하여 내림차순 정렬
SELECT SUM(salary), job_id
FROM employees
group by job_id
HAVING sum(salary) >30000
ORDER BY sum(salary) DESC;


--회사 관리자 수 표


--추가수당을 받는 사원수 
SELECT count(commission_pct)
FROM employees
--추가수당이 없는 사원수
where commission_pct is null;

--사원의 급여의 최대값과 최소값의 차
SELECT max(salary) - min(salary) as 차이
FROM employees;

--부서별 최초 입사 사원의 입사일과, 가장 최근 입사자의 입사일 표시
--부서별 급여 합계가 3만 이상인 자들
SELECT  MAX(hire_date), min(hire_date), department_id
FROM employees
WHERE department_id > 50
GROUP BY department_id
HAVING SUM(salary) > 30000
ORDER BY department_id;

--4. 모든 사원의 급여 최고액, 최저액, 총액 및 평균액을 표시하시오. 열 레이블을 각각 
--Maximum, Minimum, Sum, Average로 지정하고 결과를 정수로 반올림하도록 작성
--하시오.
SELECT  max(salary), min(salary), SUM(salary), ROUND(avg(salary))
FROM employees;

-- 5. 위의 질의를 수정하여 각 업무 유형(job_id)별로 급여 최고액, 최저액, 총액 및 평균
--액을 표시하시오. 
SELECT job_id, max(salary), min(salary), SUM(salary), ROUND(avg(salary))
FROM employees
GROUP BY Job_id;

--6. 업무별 사원 수를 표시하는 질의를 작성하시오.
SELECT job_id, count(job_id)
FROM employees
group by job_id;

-- 7. 관리자 수를 확인하시오. 열 레이블은 Number of Managers로 지정하시오. 
--(힌트: MANAGER_ID 열을 사용)
SELECT count(manager_id) as "Number of Managers"
FROM employees;

-- 8. 최고 급여와 최저 급여의 차액을 표시하는 질의를 작성하고 열 레이블을 
--DIFFERENCE로 지정하시오.
SELECT max(salary) - min(salary) as "DIFFERENCE"
FROM employees;

-- 9. 관리자 번호, 해당 관리자에 속한 사원의 최저 급여를 표시하시오. 
--관리자를 알 수 없는 사원, 최저 급여가 6,000 미만인 그룹은 제외시키고 
--결과를 최저급여에 대한 내림차순으로 정렬하시오.
SELECT manager_id, min(salary)
FROM employees
where manager_id is not null
group by manager_id
having min(salary) > 6000
order by min(salary) desc;

-- 10. 업무를 표시한 다음 해당 업무에 대해 
--부서 번호별(부서 20, 50, 80, 90) 급여 합계와  모든 사원의 급여 총액을 각각 표
--시하는 질의를 작성하고, 각 열에 적합한 머리글을 지정하시오

SELECT job_id,
        sum(decode(department_id, 20, salary)) as dept20,
        sum(decode(department_id, 40, salary)) as dept40,
        sum(decode(department_id, 50, salary)) as dept50,
        sum(decode(department_id, 80, salary)) as dept80,
        sum(salary)
FROM employees
GROUP BY job_id;

--join
--부서코드, 부서이름, 사원번호
SELECT employee_id, first_name, e.department_id, department_name
FROM employees e, departments d
where e.department_id(+) = d.department_id;

--join--
--직무에 해당하는 급여의 최소, 최대값
SELECT first_name, e.job_id, salary, 
       min_salary, max_salary
       FROM employees e, jobs j
       where e.salary between min_salary and max_salary;
       
       
-- 사원번호, 이름, 상사번호, 상사이름
SELECT e.employee_id, e.first_name, e.manager_id, e2.manager_id, e2.first_name
FROM employees e, employees e2;

--부서코드, 부서이름, 도시명
SELECT e.department_id, department_name, d.location_id, l.location_id, l.city
FROM employees e, departments d, locations l
where d.location_id = l.location_id
order by department_id;

--내추럴 조인
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


SELECT e.department_id, d.department_name, e.employee_id as 사원번호, e.first_name as 사원이름, e.manager_id,
    e.salary, e2.employee_id as 상관번호, e2.first_name as 상관이름
FROM employees e
RIGHT JOIN departments d on(e.department_id = d.department_id)
LEFT JOIN employees e2 on(e2.employee_id = e.manager_id)
ORDER BY e.employee_id;

--LOCATIONS, COUNTRIES 테이블을 사용하여 모든 부서의 주소를 생성하는 query를 작성하시오. 
--출력에 위치 ID, 주소, 구/군, 시/도 및 국가를 표시하며, NATURAL JOIN을 사용하여 결과를 생성합니다.
SELECT country_id, location_id, street_address, country_name, region_id
FROM countries c
NATURAL JOIN locations l;

-- 2. 모든 사원의 last_name, 소속 부서번호, 부서 이름을 표시하는 query를 작성하시오
SELECT last_name, department_id, department_name
FROM employees e
LEFT JOIN departments d using(department_id);

-- 3. Toronto에 근무하는 사원에 대한 보고서를 필요로 합니다. 
--toronto에서 근무하는 모든 사원의 last_name, 직무, 부서번호, 부서 이름을 표시하시오. (힌트 : 3-way join 사용)

SELECT last_name, job_id, department_id, department_name
FROM employees e
JOIN departments d using(department_id)
JOIN locations l using(location_id)
where city = 'Toronto';

-- 4. 사원의 last_name, 사원 번호를 해당 관리자의 last_name, 관리자 번호와 함께 표시하는 보고서를 작성하시오.  
--열 레이블을 각각 Employee, Emp#, Manager, Mgr#으로 지정하시오
SELECT e.last_name, e.employee_id, e2.last_name, e.manager_id, e2.employee_id
FROM employees e
left JOIN employees e2 on(e.manager_id = e2.employee_id)
order by e.employee_id;

-- 5. King과 같이 해당 관리자가 지정되지 않은 모든 사원을 표시하도록 4번 문장을 수정합니다. 사원 번호순으로 결과를 정렬하시오. 
SELECT e.last_name, e.employee_id, e2.last_name, e.manager_id, e2.employee_id
FROM employees e
left JOIN employees e2 on(e.manager_id = e2.employee_id)
where e.manager_id is null
order by e.employee_id;

--6. 사원의 last_name, 부서 번호,  같은 부서에 근무하는 모든 사원을 표시하는 보고서
--를 작성하시오. 각 열에 적절한 레이블을 자유롭게 지정해 봅니다

SELECT e.last_name as 사원이름 , e.department_id as 부서번호,  e2.last_name
FROM employees e
JOIN employees e2 on(e2.department_id = e.department_id)
where e.employee_id <> e2.employee_id
order by e2.last_name;

-- 7. 직무, 급여에 대한 보고서를 필요로 합니다. 먼저 JOBS테이블의 구조를 표시한 다음,
--모든 사원의 이름, 직무, 부서 이름, 급여를 표시하는 query를 작성하시오.
SELECT first_name, job_id, job_title, department_name, salary 
FROM jobs j
JOIN employees e using(job_id)
JOIN departments d
   USING (department_id)
   order by job_id;

-- 부서명이 it인 사람의 이름과 부서코드 툴력
select first_name, department_id
from employees
where department_id = (select department_id 
from departments where upper(department_name) = 'IT');

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