SET SERVEROUTPUT ON
/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176);
-- 프로시저, 매개변수 하나(리터럴) => IN 모드
-- 실제 기능 : DELETE, 조건 사원번호
*/
-- 기능) DELETE문
DELETE FROM employees
WHERE employee_id = &사원번호;

-- 프로시저
CREATE PROCEDURE test_pro
(p_eid IN employees.employee_id%TYPE)
IS

BEGIN
    DELETE FROM employees
    WHERE employee_id = p_eid;
     -- DML의 결과를 확인 : 암시적커서의 ROWCOUNT 속성
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
    END IF; 
END;
/

EXECUTE TEST_PRO(0);

/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) EXECUTE yedam_emp(176);
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
-- 프로시저, 매개변수 하나 IN 
-- 기능 / 입력 : 사원번호 -> 출력 : 사원이름(첫번째글자*******)
-- 1) SELECT문
SELECT 사원이름
FROM employees
WHERE 사원번호

-- 2) 사원이름 -> 첫번째 글자 남기고 나머지는 전부 *******
-- 2-1) 첫번째 글자 남기고) SUBSTR(사원이름, 1, 1)
-- 2-2) 나머지를 알기 위해 이름의 길이 확인 ) LENGTH(사원이름) 
-- 2-3) 출력형태, 함수) RPAD(SUBSTR(사원이름, 1, 1), LENGTH(사원이름) ,'*')

-- 3) 결과 출력 -> 'TAYLOR -> T*****'
*/
CREATE PROCEDURE yedam_emp
(p_eid IN employees.employee_id%TYPE)
IS
    v_ename employees.last_name%TYPE;
    v_result v_ename%TYPE;
BEGIN
    -- 1) SELECT문
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE employee_id = ;
    
    -- 2) 출력형태에 맞춰 값 계산
    v_result := RPAD(SUBSTR(v_ename, 1, 1), LENGTH(v_ename) ,'*');
    
    -- 3) 결과 출력
    DBMS_OUTPUT.PUT_LINE(v_ename || ' -> ' || v_result);    
END;
/
/*
4.
부서번호를 입력할 경우 
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name), 연차를 출력하는 get_emp 프로시저를 생성하시오. 
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
실행) EXECUTE get_emp(30)
*/
SELECT (sysdate-hire_date) 몇일
        , ((sysdate-hire_date)/30) 몇달
        , MONTHS_BETWEEN(sysdate, hire_date) 몇달
FROM employees
ORDER BY hire_date DESC;

-- 연차
-- 1) 일한 년도로써의 연차 : 1년부터 시작     / 예시 : 2년차
-- 2) 경력으로써의 연차    : 개월수부터 시작  / 예시 : 1년 9개월
SELECT employee_id
        , hire_date
        -- 총 개월수 : 실수이므로 소수점이하를 정리하는 함수를 추가로 사용해야 함
        , MONTHS_BETWEEN(sysdate, hire_date)
        -- 1) 일한 년도로써의 연차 / FLOOR
        , CEIL(MONTHS_BETWEEN(sysdate, hire_date)/12) 년차
        -- 2) 경력으로써의 연차
        -- 년 = 총개월수/12의 몫
        , TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12) 년
        -- 개월 = 총개월수/12의 나머지
        , CEIL(MOD(MONTHS_BETWEEN(sysdate, hire_date),12)) 개월
FROM employees;
-- 기능) 입력 : 부서번호 -> 출력 : 사원번호, 사원이름, 연차
-- 1) SELECT문, 다중행 => 명시적 커서 + 사원이 없을 경우 : 커서 FOR LOOP 사용불가
--                                  => 사용자 정의 예외
SELECT employee_id, last_name, hire_date
FROM employees
WHERE department_id = &부서번호;

-- 프로시저
CREATE PROCEDURE get_emp
(p_dept_id IN departments.department_id%TYPE)
IS
    -- 1.명시컥 저서
    -- 1-1) 커서 선언
    CURSOR emp_dept_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE department_id = p_dept_id;
    
    v_emp_rec emp_dept_cursor%ROWTYPE;
    v_years NUMBER(2,0);
    -- 4. 사용자 정의 예외
    -- 4-1) 예외 선언
    e_no_search_emp EXCEPTION;
BEGIN
    -- 1-2) 커서 실행
    OPEN emp_dept_cursor;
    LOOP
        -- 1-3) 데이터 인출
        FETCH emp_dept_cursor INTO v_emp_rec;
        EXIT WHEN emp_dept_cursor%NOTFOUND;
        
        -- 커서 안에 데이터가 존재하는 경우 수행할 작업
        -- 2. 연차계산
        v_years := CEIL(MONTHS_BETWEEN(sysdate, v_emp_rec.hire_date)/12);
        
        -- 3. 결과 출력 : 사원번호, 사원이름(last_name), 연차
        DBMS_OUTPUT.PUT(v_emp_rec.last_name);
        DBMS_OUTPUT.PUT(', ' || v_emp_rec.hire_date);
        DBMS_OUTPUT.PUT_LINE(', ' || v_years);
    END LOOP;    
    
    -- 4-2) 예외가 발생하는 상황 설정
    -- LOOP문 밖에서 ROWCOUNT 속성 : 현재 커서의 총 행 
    IF emp_dept_cursor%ROWCOUNT = 0 THEN
         -- 커서의 데이터가 없음을 의미
         RAISE e_no_search_emp;                
    END IF;
    -- 1-4) 커서 종료
    CLOSE emp_dept_cursor;
EXCEPTION
    -- 4-3) 예외가 발생할 경우 수행할 작업
    WHEN e_no_search_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.'); 
        CLOSE emp_dept_cursor;
END;
/
/*
5.
직원들의 사번, 급여 증가치(비율)만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10)
*/

-- 실제 프로시저가 수행하고자 하는 코드
UPDATE employees
SET salary = salary + (salary * (10/100))
WHERE employee_id = 200;

-- 프로시저
CREATE PROCEDURE y_update
( p_eid IN employees.employee_id%TYPE, 
  p_raise IN NUMBER)
IS
     e_no_emp EXCEPTION;
BEGIN
    UPDATE employees
    SET salary = salary + (salary * (p_raise/100))
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;   
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

-- FUNCTION : 독립된 기능을 구현하는 PL/SQL 객체 중의 하나
--            내부에서 DML 사용하지 않고 RETURN 타입이 NUMBER, VARCHAR, DATE일 경우
--            SQL(SELECT, INSERT, UPDATE, DELETE)문에서 사용 가능
DROP FUNCTION test_func;
CREATE FUNCTION test_func
(p_msg VARCHAR2) -- 무조건 IN 모드
RETURN VARCHAR2
IS
    -- 선언부 : 변수, 커서, 레코드타입, 예외 등 선언
    v_msg VARCHAR2(1000) := 'Hello! ';
BEGIN
    RETURN (v_msg || p_msg);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        RETURN '데이터가 존재하지 않습니다.';
END;
/
-- 실행방법
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    v_result := test_func('PL/SQL');
    -- 오라클은 프로시저와 함수를 호출하는 방식으로 구분
    -- => 함수를 호출할 때 왼쪽에 변수가 반드시 필요
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- SQL문에서 사용
SELECT test_func('PL/SQL')
FROM dual;

SELECT * FROM dual;

-- 더하기
CREATE FUNCTION y_sum
(p_x NUMBER,
 p_y NUMBER)
RETURN NUMBER -- RETURN 문에서 반환할 값의 데이터타입
IS

BEGIN
        RETURN (p_x + p_y);
END;
/

SELECT y_sum(10,25)
FROM dual;

-- 해당 사원의 직속상사 이름을 출력: 동일한 테이블을 기반으로 셀프 조인
SELECT emp.employee_id, emp.last_name, mgr.last_name
FROM employees emp
    JOIN employees mgr
    ON emp.manager_id = mgr.employee_id;
    
CREATE FUNCTION get_mgr
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_mgr_name employees.last_name%TYPE;
BEGIN
    SELECT mgr.last_name
    INTO v_mgr_name
    FROM employees emp
        JOIN employees mgr
        ON emp.manager_id = mgr.employee_id
    WHERE emp.employee_id = p_eid;
    
    RETURN v_mgr_name;
END;
/

SELECT employee_id, last_name, get_mgr(employee_id)
FROM employees;

/*
1.
사원번호를 입력하면 
last_name + first_name 이 출력되는 
y_yedam 함수를 생성하시오.
=> 함수, 매개변수 1개(employees.employee_id) : 결과, FULL NAME
- SELECT문 필요   -- 1)
SELECT last_name , first_name -- FULL NAME
FROM employees
WHERE employee_id = 174;
- FULL NAME 연산  -- 2)
last_name || ' ' || first_name

실행) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
출력 예)  Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM   employees;
*/
DROP FUNCTION y_yedam;
CREATE FUNCTION y_yedam
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2 -- 함수를 실행한 결과, 이름(문자)
IS
    v_last_name employees.last_name%TYPE;
    v_first_name employees.first_name%TYPE;
BEGIN
    -- 1) SELECT문 
    SELECT last_name , first_name -- FULL NAME
    INTO v_last_name, v_first_name -- 별도 선언 필요
    FROM employees
    WHERE employee_id = p_eid;
    
    -- 2) FULL NAME 연산
    RETURN (v_last_name || ' ' || v_first_name);
END;
/

SELECT employee_id, y_yedam(employee_id)
FROM   employees;
/*
2.
사원번호를 입력할 경우 다음 조건을 만족하는 결과가 출력되는 ydinc 함수를 생성하시오.
- 급여가 5000 이하이면 20% 인상된 급여 출력
- 급여가 10000 이하이면 15% 인상된 급여 출력
- 급여가 20000 이하이면 10% 인상된 급여 출력
- 급여가 20000 초과이면 급여 그대로 출력
실행) SELECT last_name, salary, YDINC(employee_id)
     FROM   employees; 
1) 입력 : 사원번호 ->  인상된 급여 => SELECT문
SELECT 급여
FROM employees
WHERE 사원번호 

2) 다중 조건문
IF 급여가  5000이하 THEN
    20% 인상된 급여
ELSIF 급여가 10000이하 THEN
    15% 인상된 급여
ELSIF 급여가 15000이하 THEN
    10% 인상된 급여
ELSIF 급여가 15001이상 THEN -- 15000 초과 + 최대치가 없음 => ELSE
    급여 인상없음
    
3) 인상된 급여 계산
급여 * 인상율

4) 반환 : 인상된 급여
*/
CREATE FUNCTION ydinc
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
-- DECLARE
    -- v_ename  employees.last_name%TYPE;
    v_sal    employees.salary%TYPE;
    v_raise  NUMBER(4, 2);
    v_new    v_sal%TYPE;
BEGIN
    -- 1) SELECT문
    SELECT salary
    INTO  v_sal
    FROM employees
    WHERE employee_id = p_eid; 

    -- 2) 다중 조건문
    IF v_sal <= 5000 THEN
        v_raise := 20;
    ELSIF v_sal <= 10000 THEN
        v_raise := 15;
    ELSIF v_sal <= 15000 THEN
        v_raise := 10;
    ELSE
        v_raise := 0;
    END IF;
    
    -- 3) 인상된 급여 계산
    v_new := v_sal + (v_sal * v_raise/100);

    -- 4) 반환 : 인상된 급여
    RETURN v_new;
END;
/




