
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello PL/SQL');
END;


SELECT * FROM EMPLOYEES;

SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id
FROM employees
WHERE job_id = 'ST_CLERK';

SELECT last_name, job_id, salary, commission_pct
FROM employees
WHERE commission_pct > 0
ORDER BY salary DESC ;


SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello PL/SQL');
END;

DECLARE 
--idnetifier[constant] detatype[not null] [:= | DEFAULT expr];
--기본 사용
변수명 데이터타입;
v_str VARCHAR2(100);
-- 상수 선언
변수명 CONSTANT 데이터타입 := 표현식;
v_num CONSTANT
-- NOT NULL적용 
변수명 데이터타입 NOT NULL := 표현식;
-- 변수 선언 및 초기화
변수명 데이터타입 := 표현식;
BEGIN

END;
/


--PL/SQL에서 함수 사용
DECLARE
    -- 선언부
    v_today      DATE := SYSDATE;
    -- v_after_day  employees.hire_date%TYPE;
    v_after_day  v_today%TYPE;
    v_msg        VARCHAR2(100);
BEGIN
    -- 실행부
    v_after_day := ADD_MONTHS(v_today, 3);
    v_msg := TO_CHAR(v_after_day, 'yyyy"년" MM"월" dd"일"');

    DBMS_OUTPUT.PUT_LINE('3개월 후 날짜는 ' || v_msg);
END;
/

--PL/SQL의 SELECT
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    --조회된 데이터를 변수에 담는 구문
    INTO v_ename
    FROM employees
    WHERE employee_id = 100;

    DBMS_OUTPUT.PUT_LINE('사원의 이름은: ' || v_ename);
END;
/

--2) 결과는 반드시 ONLY ONE;
DECLARE
    v_ename VARCHAR2(100);
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    --부서번호 10: 정상실행
    --부서번호 50: ORA-01422: exact fetch returns more than requested number of rows
    --부서번호  0: ORA-01403: no data found

    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
END;
/
--3) select 정의 컬럼과 INTO 정의 변수 관계
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename VARCHAR2(100);
BEGIN
    SELECT employee_id, last_name --위치를 기반으로 변수가 넘어감!!
    --SELECT > INTO
    --SELECT < INTO
    INTO v_eid,  v_ename
    FROM employees
    WHERE employee_id = 100;

    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid || ', 사원이름 : ' || v_ename);
END;
/
--학습예제
/*
사원번호를 입력(사원번호) 경로 해당
사원 이름과 입사일자를 출력하는 PL/SQL을 작성
1) SQL문 확인 : 출력 => SELECT문
입력 : 사원번호 -> 출력 : 사원이름, 입사일자 {테이블 employees)
SELECT 사원 이름, 입사일자
FROM employees
WHERE 사원번호

2) PL/SQL 블록 생성

*/
--1) SELECT 생성
SELECT employee_id, hire_date
FROM employees
WHERE  employee_id = &사원번호

DECLARE
    v_empid    employees.employee_id%TYPE;
    v_hiredate employees.hire_date%TYPE; 
BEGIN
    SELECT employee_id, hire_date
    INTO v_empid, v_hiredate
    FROM employees
    WHERE employee_id = &사원번호;

    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_empid || ', 입사일 : ' || TO_CHAR(v_hiredate, 'YYYY-MM-DD'));
END;
/

/*
1.
사원번호를 입력(치환변수사용&)할 경우
사원번호, 사원이름, 부서이름  
을 출력하는 PL/SQL을 작성하시오.
*/

DECLARE
    v_empid employees.employee_id%TYPE;
    v_ename employees.first_name%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    SELECT e.employee_id, e.first_name, d.department_name
    INTO v_empid, v_ename, v_dname
    FROM employees e JOIN departments d ON(e.department_id = d.department_id)
    WHERE e.employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_empid || ', 이름 : ' || v_ename || ',부서이름 : ' || v_dname);
END;
/

/*
2.
사원번호를 입력(치환변수사용&)할 경우 
사원이름, 
급여, 
연봉->(급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/

DECLARE
    v_ename employees.first_name%TYPE;
    v_sal employees.salary%TYPE;
    v_com NUMBER;
BEGIN
    SELECT first_name, salary, (salary*12+(NVL(salary,0)*NVL(commission_pct,0)*12)) as 연봉
    INTO v_ename, v_sal, v_com
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename || ', 월급 : ' || v_sal || ',연봉 : ' || v_com);
END;
/

DECLARE
BEGIN
END;
/

-- 제어문 1) 조건문 : if문 CASE문
-- 1) IF THEN (기본IF문) : 조건식이 TRUE인 경우에만 사용

IF 조건식 THEN
	수행할 명령어;
END IF;

--예시
DECLARE
    v_number NUMBER := 13;
BEGIN
    IF MOD(v_number, 2) = 1 THEN   
        DBMS_OUTPUT.PUT_LINE('v_number는 홀수입니다.');
    END IF;
END;


--1) IF THEN ELSE (IF -ELSE문 )
-- 해당 조건식이 true 인 경우와 FALSE인 경우 동시처리

IF 조건식 THEN
	조건식이 true인 경우 수행할 명령어
ELSE
	위의 모든 조건식들이 FALSE 인 경우 수행할 명령어
END IF;
/

DECLARE
    v_number NUMBER := 12;
BEGIN
    IF MOD(v_number, 2) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('v_number는 홀수입니다.');
	ELSE
	        DBMS_OUTPUT.PUT_LINE('v_number는 짝수입니다.');
    END IF;
END;

-- 3) IF THEN ELSIF (다중 IF문 ) : 여러 경어를 처리
-- 문법

IF 조건식 THEN
	조건식이 true인 경우 수행할 명령어
ELSIF 추가 수식어1 THEN
	추가 수식어1이 true인 경우 수행할 명령어
ELSIF 추가 수식어2 THEN
	추가 수식어2가 true인 경우 수행할 명령어
ELSE
	위의 모든 조건식들이 FALSE 인 경우 수행할 명령어
END IF;
/

DECLARE
	v_score NUMBER(2,0) := 87;
BEGIN
	IF v_score >= 90THEN
	        DBMS_OUTPUT.PUT_LINE('A학점');
	ELSIF v_score >= 80THEN
		    DBMS_OUTPUT.PUT_LINE('B학점');
	ELSIF v_score >= 70THEN
		    DBMS_OUTPUT.PUT_LINE('C학점');
	ELSIF v_score >= 60THEN
		    DBMS_OUTPUT.PUT_LINE('D학점');
	ELSE
		    DBMS_OUTPUT.PUT_LINE('F학점');
	END IF;
END;
/

/*
3.
사원번호를 입력(치환변수사용&)할 경우
입사일이 2005년 이후(2005년 포함)이면 'New employee' 출력
      2005년 이전이면 'Career employee' 출력
단, DBMS_OUTPUT.PUT_LINE ~ 은 한번만 사용
*/
DECLARE
    v_empno  employees.employee_id%TYPE := &사원번호;
    v_hdate  employees.hire_date%TYPE;
    v_msg    VARCHAR2(50);
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = v_empno;

    IF TO_CHAR(v_hdate, 'YYYY') >= '2005' THEN
        v_msg := 'New employee';
    ELSE
        v_msg := 'Career employee';
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/
/*
4.
create table test01(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

create table test02(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

사원번호를 입력(치환변수사용&)할 경우
사원들 중 2005년 이후(2005년 포함)에 입사한 사원의 사원번호, 
사원이름, 입사일을 test01 테이블에 입력하고, 2005년 이전에 
입사한 사원의 사원번호,사원이름,입사일을 test02 테이블에 입력하시오.
*/
  
DECLARE
    v_empno  employees.employee_id%TYPE;
    v_ename  employees.first_name%TYPE;
    v_hdate  employees.hire_date%TYPE;
BEGIN
    SELECT employee_id, first_name, hire_date
    INTO v_empno, v_ename, v_hdate
    FROM employees
    WHERE employee_id = &사원번호;

    IF TO_CHAR(v_hdate, 'YYYY') >= '2005' THEN
        INSERT INTO TEST01 (empid, ename, hiredate)
        VALUES (v_empno, v_ename, v_hdate);
    ELSE
        INSERT INTO TEST02 (empid, ename, hiredate)
        VALUES (v_empno, v_ename, v_hdate);
    END IF;
END;
/

/*
5.
급여가  5000이하이면 20% 인상된 급여
급여가 10000이하이면 15% 인상된 급여
급여가 15000이하이면 10% 인상된 급여
급여가 15001이상이면 급여 인상없음

사원번호를 입력(치환변수)하면 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오.
*/

DECLARE
    v_ename  employees.first_name%TYPE;
    v_sal  employees.salary%TYPE;
    v_upsal NUMBER;
    v_msg    VARCHAR2(100);
BEGIN
    SELECT first_name, salary,
        CASE  WHEN salary <= 5000 THEN salary * 1.2
              WHEN salary <= 10000 THEN salary * 1.15
              WHEN salary <= 15000 THEN salary * 1.1
              WHEN salary >= 15001 THEN salary
              END
    INTO v_ename, v_sal, v_upsal
    FROM employees
    WHERE employee_id = &사원번호;

    v_msg := '이름 :' || v_ename ||', 급여 : ' ||v_sal||', 인산된 급여 : ' ||v_upsal ;
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/

DECLARE
    v_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_salary_up NUMBER(20,0);
BEGIN
    SELECT last_name, salary
    INTO v_name, v_salary
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_salary <= 5000 THEN
        v_salary_up := v_salary * 1.2;
    ELSIF v_salary <= 10000 THEN
        v_salary_up := v_salary * 1.15;
    ELSIF v_salary <= 15000 THEN
        v_salary_up := v_salary * 1.1;
    ELSE 
        v_salary_up := v_salary;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_name);
    DBMS_OUTPUT.PUT_LINE(v_salary);
    DBMS_OUTPUT.PUT_LINE(v_salary_up);
END;
/


--loof문

BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('안녕');
    END LOOP;
END;
/

--기본 LOOP문
LOOP
    --반복하고자 하는 코드
    EXIT WHEN 투프문을 종료할 조건식;
END LOOP

--예시
DECLARE 
    v_num NUMBER(1,0) := 0; --반복문을 제어할 함수
BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE('현재 v_num : ' || v_num);
        --EXIT WHEN에 사용하는 변수가 변경되는 코드가 반드시 필요!
        v_num := v_num+1;
        --반복문을 종료할 조건
    EXIT WHEN v_num > 4;
    END LOOP;
END;
/

-- 실습) 정수 1부터 10까지 더한 종합을 구하세요
DECLARE
    v_num NUMBER(3) := 0;
    v_plus NUMBER(3) := 0;
BEGIN
    LOOP

    
    v_plus := v_plus+v_num;
    v_num := v_num + 1;
        DBMS_OUTPUT.PUT_LINE('현재 v_num : ' || v_num ||'  지금까지 총 합은  '|| v_plus);
    EXIT WHEN v_num > 10;
    END LOOP;
END;
/

/*

6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    

*/
DECLARE
    v_star    NUMBER(2) := 0;   
    v_msg     VARCHAR2(10) := '*';
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_msg);  

        v_star := v_star + 1;         
        v_msg := v_msg || '*';        

        EXIT WHEN v_star >= 5;
    END LOOP;
END;
/


/*
7. 치환변수(&)를 사용하면 숫자를 입력하면 
해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...

*/
DECLARE
    v_num    NUMBER(10) := &구구단;   
    v_gugudan    NUMBER(3) := 1;
BEGIN
        DBMS_OUTPUT.PUT_LINE(v_num ||'단');  
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_num ||'X'||  v_gugudan || ' = '|| v_num * v_gugudan);  

        v_gugudan := v_gugudan + 1;     
        EXIT WHEN v_gugudan > 9;
    END LOOP;
END;
/


/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/

DECLARE
    v_num    NUMBER(10) := 2;    -- 단
    v_gugudan    NUMBER(10) := 1; -- y변수
BEGIN
    LOOP -- 단 출력
    DBMS_OUTPUT.PUT_LINE(' '); 
    DBMS_OUTPUT.PUT_LINE(v_num ||'단'); 
    DBMS_OUTPUT.PUT_LINE(' '); 
        LOOP --구구단 출력
            DBMS_OUTPUT.PUT(v_num || ' X '||  v_gugudan || ' = '||v_num * v_gugudan || '  ');  -- 한줄 출력

            v_gugudan := v_gugudan + 1;     
            EXIT WHEN v_gugudan > 9;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE(' '); 
    v_gugudan := 1;
    v_num := v_num +1;
    EXIT WHEN v_num > 9;
    END LOOP;
END;
/

FOR 임시변수 IN 최소갑 .. 최대갑  LOOP
  --임시변수, 최소값, 최대갑은 전부 정수타입
    반복 수행 작업;
END LOOP;

--예시
BEGIN
    FOR idx IN  1.. 5 LOOP
        DBMS_OUTPUT.PUT_LINE('임시변수 idx' || idx);
    END LOOP;
END;
/
 -- 주의사항 1) 임시변수는 수정 불가(Read Only)

BEGIN
    FOR idx IN REVERSE 1 .. 5 LOOP -- REVERSE 역순으로 값을 가져옴
        DBMS_OUTPUT.PUT_LINE(idx);
    END LOOP;
END;
/


-- 정수 1~10까지 총합
DECLARE
    v_num NUMBER(3) := 0;
BEGIN
    FOR idx IN 1 .. 10 LOOP
        v_num := v_num + idx;
        DBMS_OUTPUT.PUT_LINE(idx ||'를 더한 값' || v_num);
    END LOOP;
END;


/*

6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    

*/

BEGIN
    FOR line IN 1 .. 5LOOP
    FOR idx IN 1 .. line LOOP
            DBMS_OUTPUT.PUT('*');
    END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END;



/*
7. 치환변수(&)를 사용하면 숫자를 입력하면 
해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...

*/
DECLARE
    v_num  NUMBER(10) :=  &구구단입력;
BEGIN
    FOR idx IN 1 .. 9LOOP
        DBMS_OUTPUT.PUT_LINE( v_num || '*' || idx || '=' || v_num * idx );
    END LOOP;
END;
/
/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/
BEGIN
    FOR jdx IN 2 .. 9LOOP
        DBMS_OUTPUT.PUT_LINE(jdx ||'단'); 
        DBMS_OUTPUT.PUT_LINE(' ');
        FOR idx IN 1 .. 9LOOP
            DBMS_OUTPUT.PUT( jdx || ' * ' || idx || ' = ' || jdx * idx || '  ');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('=============================================================='); 
    END LOOP;
END;
/

BEGIN
        FOR dan IN 1 .. 9LOOP
            DBMS_OUTPUT.PUT( RPAD(dan || '단',12));
        END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');  
    FOR jdx IN 2 .. 9LOOP
        FOR idx IN 1 .. 9LOOP
            DBMS_OUTPUT.PUT( RPAD(idx || ' * ' || jdx || ' = ' || jdx * idx,12));
        END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');    
    END LOOP;
END;
/

--DBMS_OUTPUT.PUT
--    IF MOD(v_number, 2) = 1 THEN
--홀수 구구단
BEGIN
    FOR dan IN 1 .. 9LOOP
        IF MOD (dan,2) = 1 THEN
            DBMS_OUTPUT.PUT( RPAD(dan || '단',12));
        END IF;
    END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');  
    FOR jdx IN 2 .. 9LOOP
        FOR idx IN 1 .. 9LOOP
            IF MOD (idx,2) = 1 THEN
                DBMS_OUTPUT.PUT( RPAD(idx || ' * ' || jdx || ' = ' || jdx * idx,12));
            END IF;
        END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');    
    END LOOP;
END;
/


BEGIN
    FOR jdx IN 2 .. 9LOOP
        IF MOD (jdx,2) = 1 THEN
            DBMS_OUTPUT.PUT_LINE(jdx ||'단'); 
            DBMS_OUTPUT.PUT_LINE(' ');
                FOR idx IN 1 .. 9LOOP
                    DBMS_OUTPUT.PUT( RPAD(jdx || ' * ' || idx || ' = ' || jdx * idx,12));
                END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('=============================================================='); 
            END IF;
    END LOOP;
END;
/