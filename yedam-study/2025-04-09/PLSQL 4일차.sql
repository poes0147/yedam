SET SERVEROUTPUT ON;

--명시적 커서 + 커서 FOR LOOP : 명시적 커서 단축방법
DECLARE
    --커서 선언
    CURSOR 커서 이름 IS
        SELECT 문;
BEGIN
    --2.커서제어 (OPEN FETCH, CLOSE)
    FOR 임시변수 IN 커서이름 LOOP --암묵적으로 OPEN과 FETCH가 실행
        --데이터가 존재하는 경우 수행할 작업
    END LOOP; -- 암묵적으로 CLOES 실행

END;
/

DECLARE
    -- 1) 커서선언
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE department_id = &부서번호; -- 50 // 0 확인
        
BEGIN
    -- 2) 커서제어
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT(RPAD(emp_cursor%ROWCOUNT, 3 ) || ': ');
        --emp_rec : RECORD 타입의 임시변수, 필드는 커서의 SELECT절 컬럼 이름
        DBMS_OUTPUT.PUT(emp_rec.employee_id);
        DBMS_OUTPUT.PUT(', ' || emp_rec.last_name);
        DBMS_OUTPUT.PUT_LINE(', '||emp_rec.hire_date);
    -- 3)
    END LOOP;
END;
/

/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.

입사년도가 2005년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2005년 이후 입사한 사원은 test02 테이블에 입력
*/
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        IF TO_CHAR(emp_rec.hire_date, 'YYYY') > '2005' THEN
            INSERT INTO test01 (empid, ename, hiredate)
            VALUES (emp_rec.employee_id, emp_rec.last_name, emp_rec.hire_date);
        ELSE
            INSERT INTO test02 (empid, ename, hiredate)
            VALUES (emp_rec.employee_id, emp_rec.last_name, emp_rec.hire_date);
        END IF;
    END LOOP;
END;
/



/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
*/
DECLARE
    CURSOR emp_cursor IS
        SELECT e.last_name, e.hire_date, d.department_name
        FROM employees e JOIN departments d ON (e.department_id = d.department_id)
        WHERE e.department_id = &부서번호;
        
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT(emp_rec.last_name);
        DBMS_OUTPUT.PUT(', '||emp_rec.hire_date);
        DBMS_OUTPUT.PUT_LINE(', '||emp_rec.department_name);
    END LOOP;

--    OPEN emp_cursor;
--    LOOP
--        FETCH emp_cursor INTO v_ename, v_hdate, v_dname;
--        EXIT WHEN emp_cursor%NOTFOUND;
----          DBMS_OUTPUT.PUT(emp_cursorROWCOUNT)
--            DBMS_OUTPUT.PUT(v_ename); 
--            DBMS_OUTPUT.PUT(', '||v_hdate);
--            DBMS_OUTPUT.PUT_LINE(', '||v_dname);
--        END LOOP;
--        IF emp_cursor%ROWCOUNT THEN
--            DBMS_OUTPUT.PUT_LINE('찾으시는 부서가 없어요. ');
--    CLOSE emp_cursor;
END;
/






/*
3.
부서번호를 입력(&사용)할 경우 
사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/

DECLARE
    CURSOR emp_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id = &부서번호;

    v_ysal NUMBER(12);
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        v_ysal := emp_rec.salary * 12 + emp_rec.salary * NVL(emp_rec.commission_pct, 0) * 12;
        DBMS_OUTPUT.PUT(emp_rec.last_name); 
        DBMS_OUTPUT.PUT(', ' || emp_rec.salary);
        DBMS_OUTPUT.PUT_LINE(', ' || v_ysal); 
    END LOOP;
END;
/


BEGIN
EXCEPTION
    --예외처리
    WHEN 예외이름1 THEN
        예외가 발생했을 때 실행할 코드;
    WHEN 예외이름2 THEN
        예외가 발생했을 때 실행할 코드;
    WHEN OTHERS THEN
        위에 선언되지 않은 예외가 발생한 경우 실행할 코드;
END
/

-- 1) 예외유형 : 이미 오라클에 정의되어 있고 이름도 존재하는 예외
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    --부서번호 10 : 정상실행
    --부서번호 50 : TOO_MANY_ROWS (ORA-01442) 
    --부서번호 0  : NO_DATA_FOUND (ORA-01403)
    DBMS_OUTPUT.PUT_LINE(v_ename);
    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 여러명의 사원이 존재합니다.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 존재하지 않습니다.');    
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 에러가 발생하였습니다.');
        DBMS_OUTPUT.PUT_LINE('SQLCODE : ' || TO_CHAR(SQLCODE));
        DBMS_OUTPUT.PUT_LINE('SQLERRM : ' || SQLERRM);
END;
/


-- 2) 예외유형 : 이미 오라클에 정의도어 있지만 이름이 없는 예외
DECLARE
    -- 예외 이름 선언
    e_emps_remaining EXCEPTION;
    
    -- 예외 이름과 Oracle 에러코드 연결
    -- ORA-02292: 무결성 제약조건 위반 (부모 삭제 불가 → 자식 행 존재)
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -2292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;

    DBMS_OUTPUT.PUT_LINE('삭제가 완료되었습니다.');

--    COMMIT;
EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('내용을 다시 확인해 주세요');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 오류: ' || SQLERRM);
        ROLLBACK;
END;
/

-- 3) 예외유형 : 사용자 정의 예외 => 오라클 입장에선 정상 코드

DECLARE
    --3_1) 예외이름 선언
    e_dept_del_fail EXCEPTION;
--사용자 정의 예외사항 VS 조건문
--해당 경우에 더이상 코드가 진행되면 안될때 예외처리.

BEGIN
    DELETE FROM departments
    WHERE department_id = 0;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_dept_del_fail;
    END IF;
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제 되었습니다.');
EXCEPTION
    WHEN e_dept_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당부서가 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('부서 이름을 다시 확인해 주세요');
END;
/


--PROCEDURE : 독립된 기능을 구현하는 PL/SQL의 객체 중 하나
CREATE PROCEDURE test_pro_01
(p_msg IN VARCHAR2)
IS
-- DECLARE 쓰지 않음
    -- 선언부 : 변수, 커서, 예외
    v_msg VARCHAR2(1000) := 'Hello';
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_msg || p_msg);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('데이터가 존재하지 않습니다');
END;
/

BEGIN
    test_pro_01(' World!');
END;
/
DECLARE
     -- v_result VARCHAR2(1000);

BEGIN
    -- v_result := test_pro_01(' World!');
    --오라클은 프로시져와 함수를 호출하는 방식으로 구분
    -- => 프로시져를 호출할 때 왼쪽에 변수가 존재하면 안됨!!!.]
    test_pro_01(' World!');
END;
/



--------------------------------------------------------------------------------
--IN모드 : 호출환경 -> 프로시져
DROP PROCEDURE raise_salary;
CREATE PROCEDURE raise_salary
(p_eid IN employees.employee_id%TYPE)
IS
    --선언부
BEGIN
    --실행부
--    p_eid := NVL(p_eid, 100);
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = p_eid;
END;
/

DECLARE
    v_first NUMBER(3,0) := 100;
    v_second CONSTANT NUMBER(3,0) := 149;
BEGIN
    raise_salary(100);          --리터럴
    raise_salary(v_first+10);   --표현식(계산식)
    raise_salary(v_first);      --값을 가진 변수
    raise_salary(v_second);     --상수
END;
/

DROP PROCEDURE test_p_out;
CREATE PROCEDURE test_p_out
(p_num IN NUMBER,
 p_out OUT NUMBER)
 IS
 
BEGIN 
    DBMS_OUTPUT.PUT_LINE('IN : ' || p_num);
    DBMS_OUTPUT.PUT_LINE('OUT : ' || p_out);
END;
/

DECLARE
    v_result NUMBER(4,0) := 1234;
BEGIN
    --OUT모드
    --1)매게변수로 전달되는 값이 있어도 무조건 null로 값을 가짐
    --2)OUT모드의 매게변수가 가진 최종 값을 호출환경으로 변환
    DBMS_OUTPUT.PUT_LINE('1) result : ' || v_result);
    test_p_out(1000,v_result);
    DBMS_OUTPUT.PUT_LINE('2) result : ' || v_result);
END;
/

DROP PROCEDURE plus;
CREATE PROCEDURE plus
(p_x IN NUMBER,
 p_y IN NUMBER,
 p_result OUT NUMBER)
IS

BEGIN
    p_result := (p_x + p_y);
    --result (x+y);
END;
/

DECLARE
    v_total NUMBER(10,0);
BEGIN
    plus(10,25, v_total);
     DBMS_OUTPUT.PUT_LINE(v_total);
END;
/
DROP PROCEDURE format_phone;
CREATE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2)
IS

BEGIN
        --1) OUT 모드와 달리 호출환경에서 전달받은 값을 가질 수 있음
    DBMS_OUTPUT.PUT_LINE('before :' || p_phone_no);
        --2) IN 모ㅡ와 달리 값을 변결할 수 있음
    p_phone_no := SUBSTR(p_phone_no, 1, 3)
         || '-'|| SUBSTR(p_phone_no, 4, 4)
         || '-'|| SUBSTR(p_phone_no, 8);
        --3) OUT모드처럼 최종 값을 호출환경으로 변환
    DBMS_OUTPUT.PUT_LINE('after : ' || p_phone_no);
END;
/

DECLARE
    v_no VARCHAR(100) := '01012345678';
BEGIN
    format_phone(v_no);
    DBMS_OUTPUT.PUT_LINE(v_no);
END;

/
/*
1.
주민등록번호를 입력하면 
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju('9501011667777');
950101-1******
EXECUTE yedam_ju('1511013689977');
151101-3******
*/
DROP PROCEDURE yedam_ju;
/
CREATE PROCEDURE yedam_ju
(p_id_no IN VARCHAR2)
IS
    p_result VARCHAR(20);
BEGIN

        --2) IN 모ㅡ와 달리 값을 변결할 수 있음
    p_result := RPAD(SUBSTR(p_id_no, 1, 6)|| '-'|| SUBSTR(p_id_no, 7, 1),15,'*') ;
    DBMS_OUTPUT.PUT_LINE(p_result);
END;
/


DECLARE
    v_no VARCHAR(100) := '0010151234567';
BEGIN
    yedam_ju(v_no);
END;
/

EXECUTE yedam_ju('0010151234567');
/

SELECT last_name, RPAD(last_name, 10, '-'), LPAD(last_name,10,'-')
/
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
        -- 1) 일한 년도로써의 연차
        , CEIL(MONTHS_BETWEEN(sysdate, hire_date)/12) 년차
        -- 2) 경력으로써의 연차
        -- 년 = 총개월수/12의 몫
        , TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12) 년
        -- 개월 = 총개웘/12의 나머지
        , CEIL(MOD(MONTHS_BETWEEN(sysdate, hire_date),12)) 개월
FROM employees;
-- 기능) 입력 : 부서번호 -> 출력 : 사원번호, 사원이름, 연차
-- 1) SELECT문, 다중행 => 명시적 커서 + 사원이 없을 경우 : 커서 FOR LOOP 사요웁ㄹ가
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
    --4 사용자 예외 정의
    --4-1) 예외 선언
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
    --4-2) 예외가 발생하는 상황
    IF emp_dept_cursor%ROWCOUNT = 0 THEN
        --커서의 데이터가 없음을 의미
        RAISE e_no_search_emp;
    END IF;
    -- 1-4) 커서 종료
    CLOSE emp_dept_cursor;
EXCEPTION
    --4-3) 에외가 발생할 경우 수행
    WHEN e_no_search.emp THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.')
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

/*
--FUNCTION : 독립된 기능을 구현하는 PL/SQL 객체 중의 하나
            내부에서 DNL, 사용하지 않고

*/
DROP FUNCTION test_func;

CREATE FUNCTION test_func
(p_msg VARCHAR2)  -- 무조건 IN 모드
RETURN VARCHAR2
IS
    v_msg VARCHAR2(1000) := 'Hello ';
BEGIN
    -- 원래 의도한 경우: 사용자 입력을 붙여서 반환
    -- RETURN (v_msg || p_msg);

    -- 현재 시각을 반환하는 경우
    RETURN TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '데이터가 존재하지 않습니다.';
END;
/
DECLARE
    v_result VARCHAR(1000);
BEGIN
    v_result := test_func('PL/SQL');
    -- 오라클은 프로시져와 함수를 호출하는 방식으로 구분
    -- => 함수를 호출할 때 왼쪽에 변수가 반드시 필요
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
SELECT test_func('PL/SQL')
FROM dual;
/
SELECT * FROM dual;
/
DROP FUNCTION y_sum;
/
CREATE FUNCTION y_sum
(p_x NUMBER, p_y NUMBER)
RETURN NUMBER
IS

BEGIN
    RETURN p_x + p_y;
END;
/

SELECT y_sum(10,25)
FROM dual;
/

SELECT emp.employee_id, emp.last_name, mgr.last_name
FROM employees emp
    JOIN employees mgr
    ON emp.manager_id = mgr.employee_id;
    /
    DROP FUNCTION get_mgr
    /
CREATE OR REPLACE FUNCTION get_mgr
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
/


/*
1.
사원번호를 입력하면 
last_name + first_name 이 출력되는 
y_yedam 함수를 생성하시오.

실행) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
출력 예)  Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM   employees;
*/
DROP FUNCTION y_yedam;
/

CREATE FUNCTION y_yedam
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_name VARCHAR2(1000);
BEGIN
    SELECT first_name ||' '|| last_name
    INTO v_name
    FROM employees
    WHERE employee_id = p_eid;
    
    RETURN v_name;
END;
/

/
EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
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
*/

DROP FUNCTION ydinc;
/
CREATE FUNCTION ydinc
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
--    v_name employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_upsal NUMBER(10,2);
BEGIN
    SELECT  salary INTO  v_sal
    FROM employees
    WHERE employee_id = p_eid;
    
    IF v_sal <= 5000 THEN v_upsal := v_sal * 1.2;
    ELSIF v_sal <= 10000 THEN v_upsal := v_sal * 1.15;
    ELSIF v_sal <= 20000 THEN v_upsal := v_sal * 1.1;
    ELSE v_upsal := v_sal;
    END IF;
    
    RETURN v_upsal;
END;
/
SELECT last_name, salary, YDINC(employee_id)
FROM   employees; 