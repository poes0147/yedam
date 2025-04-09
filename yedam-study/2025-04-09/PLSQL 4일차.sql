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
----          DBMS_OUTPUT.PUT(emp_cursor&ROWCOUNT)
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

/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)
*/
CREATE PROCEDURE TEST_PRO
(p_del_no IN NUMBER)
IS

BEGIN
    DELETE employees
    WHERE employee_id LIKE p_del_no;
    IF p_del_nO 
END;
/
