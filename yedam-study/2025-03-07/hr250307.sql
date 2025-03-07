-- DUAL은 더미데이터.
SELECT sysdate +5
FROM dual;
-- upper 소문자를 대문자로
SELECT upper('ye dam')
FROM dual;
-- lower 대문자를 소문자로
SELECT lower('YE DAM')
FROM dual;
-- initcap 첫글자만 대문자로
SELECT initcap('ye dam')
FROM dual;

--first name 첫 글자가 s인 사람의 이름, 급여, 부서명 조회

SELECT first_name, salary, department_id
FROM employees
where lower(first_name) like '%s%';

-- concat 문자열 합치기
SELECT concat ('Ye',' Dam')
FROM dual;

--이름에서 세번째 글자만 표시, 이름의 글자수 표시, 부서코드
--이름에 a의 위치 표시(대소문자 구별 없이 찾기)
--last_name 10자리에 표시, 왼쪽에 * 체우기)
--급여 표시, ■ : 1000달러 급여가 5000 ■■■■■
--부서코드가 80인 데이터만 조회

lpad('',

SELECT lpad(salary, salary/1000+5,'■'), salary
FROM employees
where department_id = 80;

SELECT lengthb('abc'), lengthb('한글')
FROM dual;

--주민번호의 뒷자리를 *로 마킹
select '050307-4684818', replace('050307-4684818', substr('050307-4684818',-6,6), '******') as 주민등록번호,
trim('        한글'), '          한글'
FROM dual;

--사원번호가 홀수면 1, 짝수면 0이 표시되도록 하시오
-- 사원 번호, 이름, 홀짝 구분

SELECT employee_id, first_name, mod(employee_id,2)
FROM employees
where department_id = 80;

SELECT sysdate
FROM dual;

-- 사번, 이름, 입사일, 1입사 6개월, 근속개월
SELECT employee_id, first_name, hire_date,add_months(hire_date, 6), trunc(MONTHS_BETWEEN(SYSDATE,hire_date))
    , next_day(SYSDATE,'수')
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

-- 23) 사원 테이블의 이름을 조회. 
--단 첫 번째 컬럼은 이름을 대문자로 출력하고, 
--두 번째 컬럼은 이름을 소문자로 출력하고,
--세 번째 컬럼은 이름의 첫 번째 철자는 대문자로, 
--나머지는 소문자로 조회.
SELECT UPPER(first_name),lower(first_name),initcap(first_name)
FROM employees;



-- 24) 이름이 alexander(모두 소문자로 변환)인 사원의 이름과 월급 조회.
SELECT first_name, salary
FROM employees
WHERE lower(first_name) = 'alexander';


-- 25) 영어 단어 SMITH에서 SMI만 잘라서 조회.
SELECT SUBSTR('SMITH',1,3)
FROM dual;

-- 26) 사원들의 이름(last_name)과 이름의 철자 개수를 출력.
SELECT last_name, length(last_name)
FROM employees;


-- 27) 이름에 소문자 a가 존재하는 경우 몇 번째 자리에 위치하는지 조회.
SELECT first_name, instr(first_name,'a') 
FROM employees;


-- 28) 사원들의 이름과 월급을 조회. 단 월급 컬럼의 자릿수를 10자리로 하고, 
--월급을 출력하고 남은 나머지 자리에 *(별표)를 채워서 조회.

SELECT first_name, lpad(salary,10,'*')
FROM employees;

-- 29) 사원들의 이름과 월급 조회. 단 월급은 1000을 네모(■) 하나로 출력.
SELECT first_name, lpad('■',salary/1000,'■'),salary
FROM employees;

-- 30) 숫자 876.567을 소수점 두 번째 자리까지 출력(반올림 처리)
SELECT ROUND('876.567',2)
FROM dual;


-- 31) 숫자 876.567을 소수 첫째 자리까지 출력(버림 처리)
SELECT TRUNC('876.567',1)
FROM dual;


-- 32) 숫자 10을 3으로 나눈 나머지 값을 출력.
SELECT MOD('10',3)
FROM dual;


-- 33) 사원 번호와 사원 번호가 홀수이면 1, 짝수이면 0을 출력.
SELECT employee_id, mod(employee_id,2)
FROM employees;

-- 34) 사원번호가 짝수인 사원들의 사원 번호와 이름을 조회.
SELECT employee_id, first_name
FROM employees
where mod(employee_id,2) = 0;

-- 35) 사원의 이름과 입사한 날짜부터 오늘까지 총 몇 달을 근무했는지 조회(정수).
SELECT first_name, TRUNC(MONTHS_BETWEEN(SYSDATE, hiRe_date))
FROM employees;

----------------변환함수----------
--문자변환함수 : 숫자, 날짜, =>  문자열
SELECT first_name, hire_date, to_char(hire_date, 'yyyy/mm'), to_char(salary, '$999,999')
from employees;

ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

-- nvl null을 변환하는 함수
--추가 수당이 NULL이면 200, 아니면 급여*수당율 
-- 사번, 이름, 급여, 추가수당
SELECT employee_id, first_name, salary, NVL2(commission_pct, to_char(commission_pct*salary),'보너스없음') as 추가수당
FROM employees;

--if then else
--급여가 <1000 30%인상 <2000 20%인상 <3000 10%인상 나머진 동결

SELECT first_name, salary,
        case  when salary < 1000 then salary * 1.3
              when salary < 2000 then salary * 1.2
              when salary < 3000 then salary * 1.1
              else salary
              END
        as "인상된 급여"
FROM employees;

--부서코드가 20,30,50 서울
-- 60,70,80 대구
-- 나머지 제주
SELECT first_name, department_id,
        case  when department_id in (20,30,50) then '서울'
              when department_id in (60,70,80) then  '대구'
              else '제주'
              end
              as "부서이동"
FROM employees;

-- 36) 2018년 10월 1일에서 2019년 6월 1일 사이의 총일수 출력.
SELECT TO_DATE('2019-06-01', 'YYYY-MM-DD') - TO_DATE('2018-10-01', 'YYYY-MM-DD') AS total_days 
FROM DUAL;


-- 37) 2018년 10월 1일에서 2019년 6월 1일 사이의 총 주(Week) 수를 출력(정수).
SELECT CEIL((TO_DATE('2019-06-01', 'YYYY-MM-DD') - TO_DATE('2018-10-01', 'YYYY-MM-DD'))/7) AS total 
FROM DUAL;

-- 38) 2023년 5월 1일로부터 100달 뒤의 날짜 출력.
SELECT ADD_MONTHS(TO_DATE('2023-05-01', 'YYYY-MM-DD'), 100)
FROM dual;

-- 39) 2023년 5월 1일로부터 100일 후 날짜 출력.
SELECT to_date('2023-05-01', 'yyyy-mm-dd') + 100
FROM dual;

-- 40) 2023년 6월 30일 이후 바로 돌아올 화요일의 날짜 출력
SELECT next_day(to_date('2023-06-30', 'yyyy-mm-dd'),'화')
FROM dual;

-- 41) 2023년 9월 19일 이후 바로 돌아올 토요일의 날짜 출력
SELECT next_day(to_date('2023-09-19', 'yyyy-mm-dd'),'토')
FROM dual;

-- 42) 오늘 이후 돌아올 금요일의 날짜 출력
SELECT next_day(sysdate, '금')
FROM dual;

-- 43) 2020년 5월 22일부터 100달 뒤에 돌아오는 화요일의 날짜 출력
SELECT next_day(ADD_MONTHS(TO_DATE('2020-05-22','YYYY-MM-DD'),100),'화')
FROM dual;

-- 44) 오늘부터 100달 뒤에 돌아오는 월요일의 날짜 출력
SELECT NEXT_DAY(ADD_MONTHS(SYSDATE,100),'월')
FROM dual;

-- 45) 2019년 5월 22일 해당 달의 마지막 날짜가 어떻게 되는지 조회
SELECT LAST_DAY(TO_DATE('2019-05-22','YYYY-MM-DD'))
FROM dual;

-- 46) 오늘부터 이번 달 말일까지 총 며칠 남았는지 조회
SELECT  LAST_DAY(SYSDATE)- SYSDATE
FROM dual;

-- 47) 이름이 SUSAN인 사원의 이름, 입사일, 
-- 입사한 달의 마지막 날짜를 조회
SELECT first_name, hire_date, last_day(hire_date)
FROM employees
WHERE upper(first_name) = 'SUSAN';

-- 48) 이름(last_name)이 GRANT(대문자로 변환)인 사원의 이름과 입사한 요일을 출력하고,
--GRANT의 월급에 천단위를 구분할 수 있는 콤마(,)를 붙여 조회
SELECT last_name, hire_date, to_char(salary, '$999,999')
FROM employees
WHERE upper(last_name) = 'GRANT';

-- 50) 2008년도에 입사한 사원의 이름과 입사일 조회(to_char 함수 사용)
SELECT first_name, hire_date
FROM employees
WHERE to_char(hire_date) like '08%';

-- 51) 월급이 1500 이상인 사원의 이름과, 월급에 천단위를 구분할 수 있는 콤마(,)와 화폐단위를 붙여 조회
SELECT first_name, to_char(salary, '$999,999')
FROM employees
WHERE salary > 15000;

-- 52) 2005년 06월 14일에 입사한 사원의 이름과 입사일 조회(to_date 함수 사용)
-- 53) 사원의 이름과 커미션을 조회. (단 커미션이 NULL인 사원들은 0)
-- 54) 직업이 'SA_MAN' 또는 'IT_PROG' 인 사원의 월급, 추가수당, 월급여 조회 - 추가수당 : 월급 * 커미션(단 커미션이 NULL인 경우 0)- 월급여 : 월급 + 추가수당
-- 55) 사원의 이름과 부서 번호, 보너스 조회보너스 : 부서 번호가 10번이면 300, 20번이면 400, 나머지 부서 번호는 0
-- 56) 사원 번호와 사원 번호가 짝수인지 홀수인지를 조회
-- 57) 사원의 이름, 직업, 보너스 조회단 직무가 'SA_MAN'이면 보너스 5000 나머지 직무는 보너스 2000
-- 58) 사원의 이름, 직업, 월급, 보너스 조회- 보너스 : 월급이 3000이상이면 500, 월급이 2000이상 3000미만이면 300, 월급이 1000이상 2000미만이면 200, 나머지는 0
-- 59) 사원의 이름, 직업, 커미션, 보너스 조회. 보너스 : 커미션이 NULL이면 500, NULL이 아니면 0
-- 60) 사원의 이름, 직업, 보너스 조회 - 보너스는 직무가 'SA_MAN', 'PU_CLERK' 이면 500, 'ST_CLERK', 'FI_ACCOUNT'이면 400나머지  0

