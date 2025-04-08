SET SERVEROUTPUT ON;
-- 조합데이터 : RECORD (필드, 필드2,. ...)=> 객체
-- 사용방법


DECLARE
    -- 1) TYPE 정의
    TYPE 레코듵아입이름 IS RECORD
        (필드명1 데이터타입,
         필드명2 데이터타입 NON NULL DEFAULT 초기값,
         필드명3 데이터타입 := 초기값
         ...)
         
    -- 2) 변수선안
    변수명 레코드 타입이름
BEGIN
    -- 3) 실제 사용
    변수명, 필드명1 := 값;
    DBMS_OUTPUT.PUT_LINE
    
END;
/

--예시 회원정보를 하나의 변수로 다룸
DECLARE
-- 회원정보 (아이디, 이름, 가입일자)를 의미
    -- 1)RECORD 정의
    TYPE user_record_type IS RECORD
        (user_id NUMBER(6,0),
         user_name VARCHAR2(100) := '익명',
         join_date DATE NOT NULL DEFAULT SYSDATE);
    -- 2)변수선언
    first_user user_record_type;
    new_user user_record_type;
BEGIN
    -- 3)실제 사용 : 변수명 필드명
    DBMS_OUTPUT.PUT_LINE(first_user.user_id);
    DBMS_OUTPUT.PUT_LINE(first_user.user_name);    
    DBMS_OUTPUT.PUT_LINE(first_user.join_date);
END;
/
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;

    v_new_eid employees.employee_id%TYPE;
    v_new_ename employees.last_name%TYPE;
    v_new_sal employees.salary%TYPE;
BEGIN
    SELECT employee_id, last_name, salary
    INTO v_eid, v_ename, v_sal
    FROM employees
    WHERE employee_id = 100;
    
    SELECT employee_id, last_name, salary
    INTO v_new_eid, v_new_ename, v_new_sal
    FROM employees
    WHERE employee_id = 200;
END;
/

DECLARE
    -- 1) TYPE 정의
    TYPE emp_record_type IS RECORD
        (empno NUMBER(6,0),
         ename employees.last_name%TYPE NOT NULL := 'Hong',
         sal employees.salary%TYPE := 0);
         
    -- 2) 변수선안
    v_emp_info emp_record_type;
    v_emp_record emp_record_type;
BEGIN
    -- 3) 실제 사용
    SELECT employee_id, last_name, salary
--    INTO v_eid, v_ename, v_sal
    INTO v_emp_info
    -- 무조건 RECORD 타입 변수 하나만 사용
    FROM employees
    WHERE employee_id = 100;
    
    SELECT employee_id, last_name, salary
--    INTO v_new_eid, v_new_ename, v_new_sal
    INTO v_emp_record
    FROM employees
    WHERE employee_id = 200;
    
    DBMS_OUTPUT.PUT(v_emp_info.empno); DBMS_OUTPUT.PUT(v_emp_info.ename); DBMS_OUTPUT.PUT_LINE(v_emp_info.sal);
    DBMS_OUTPUT.PUT(v_emp_record.empno); DBMS_OUTPUT.PUT(v_emp_record.ename); DBMS_OUTPUT.PUT_LINE(v_emp_record.sal);

END;
/
--%ROWTYPE
--테이블 VIEW, 명시적 커서의 한행을 RECORD타입으로 참조하도록 사용
-- 1) 필드명을 따로 지정 불가, 참조하는 테이블의 칼럼명과 동일한 필드명 사용
-- 2) SELECT할 때 사용 시 반드시 해당 테이블의 모든 칼럼을 선언 -> * 사용
DECLARE
    -- 1) TYPE 정의 생략
    -- 2) 변수 선언
    v_emp_info employees%ROWTYPE;

BEGIN
    -- 3) 변수 사용
    SELECT *
    INTO v_emp_info
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE(v_emp_info.employee_id);
    DBMS_OUTPUT.PUT_LINE(v_emp_info.last_name);
    DBMS_OUTPUT.PUT_LINE(v_emp_info.salary);

END;
/

--명시적 커서
-- 예시

DECLARE
    CURSOR test_cursor IS
        SELECT employee_id, last_name
        FROM employees;
        
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;  
BEGIN
    OPEN test_cursor;
    
    FETCH test_cursor INTO v_eid, v_ename;
    DBMS_OUTPUT.PUT_LINE(v_eid);
        DBMS_OUTPUT.PUT_LINE(v_ename);
    CLOSE test_cursor;
END;
/

--1) 목적 : 다중 행 select문을 사용
DECLARE
    --1. 커서 정의 -> 실행 x
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE department_id = &부서번호;
        
    --값을 담을 변수 선언
    v_eid   employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    --2. 커서 실행
    OPEN emp_cursor;
    --3. 데이터 확인 및 반환 -> 1건의 데이터만
    LOOP
        FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
    --FETCH 를 기반으로 가져온 데이터가 새로운 데이터가 아닌 경우
        EXIT WHEN emp_cursor%NOTFOUND;
    --가져온 데이터를 기반으로 작업
        DBMS_OUTPUT.PUT_LINE(v_eid); 
        DBMS_OUTPUT.PUT_LINE(v_ename);
        DBMS_OUTPUT.PUT_LINE(v_hdate);
    END LOOP;

    --4. 커서 종료
    CLOSE emp_cursor;
END; 
/
/*
특정 업무를 수행하는 사원의 정보를 출력하세요
출력할 사원의 정보는 사원번호, 사원이름, 입사일자 입니다.
단, 해당 업무를 수행하는 사원이 없는 경우
'해당 사원이 없습니다.' 라고 출력합니다.
*/
DECLARE
--커서 선언
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE job_id LIKE UPPER('&업무%');
--변수선언 
    v_eid   employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
--커서오픈
    OPEN emp_cursor;
--데이터 반환
        LOOP
            FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
            EXIT WHEN emp_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT(v_eid);
            DBMS_OUTPUT.PUT(v_ename);
            DBMS_OUTPUT.PUT_LINE(v_hdate);
        END LOOP;
        
        IF emp_cursor%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('해당 사원이 없습니다.');
        END IF;
--커서종료
    CLOSE emp_cursor;
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
    v_eid   employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    OPEN emp_cursor;
        LOOP
            FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
            EXIT WHEN emp_cursor%NOTFOUND;
                IF TO_CHAR(v_hdate, 'YYYY') >= '2005' THEN
                    INSERT INTO TEST01 (empid, ename, hiredate)
                    VALUES (v_eid, v_ename, v_hdate);
                ELSE
                    INSERT INTO TEST02 (empid, ename, hiredate)
                    VALUES (v_eid, v_ename, v_hdate);
                END IF;
        END LOOP;
    CLOSE emp_cursor;
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
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_ename, v_hdate, v_dname;
        EXIT WHEN emp_cursor%NOTFOUND;
--          DBMS_OUTPUT.PUT(emp_cursor&ROWCOUNT)
            DBMS_OUTPUT.PUT(v_ename); 
            DBMS_OUTPUT.PUT(', '||v_hdate);
            DBMS_OUTPUT.PUT_LINE(', '||v_dname);
        END LOOP;
        IF emp_cursor%ROWCOUNT THEN
            DBMS_OUTPUT.PUT_LINE('찾으시는 부서가 없어요. ');
    CLOSE emp_cursor;
END;
/


/*
3.
부서번호를 입력(&사용)할 경우 
급여가  5000이하이면 20% 인상된 급여
급여가 10000이하이면 15% 인상된 급여
급여가 15000이하이면 10% 인상된 급여
급여가 15001이상이면 급여 인상없음

사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/

DECLARE
    CURSOR emp_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id = &부서번호;
    v_ename employees.last_name%TYPE;
    v_sal   employees.salary%TYPE;
    v_com   employees.commission_pct%TYPE;
    v_ysal  NUMBER(20,2);
BEGIN   --사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
    OPEN emp_cursor;
        LOOP
            FETCH emp_cursor INTO v_ename, v_sal, v_com;
            EXIT WHEN emp_cursor%NOTFOUND;
                IF v_sal <= 5000 THEN
                    v_ysal := ((v_sal * 1.2)*12+((v_sal * 1.2)*nvl(v_com,0)*12));
                ELSIF v_sal <= 10000 THEN
                    v_ysal := ((v_sal * 1.15)*12+((v_sal * 1.15)*nvl(v_com,0)*12));
                ELSIF v_sal <= 15000 THEN
                    v_ysal := ((v_sal * 1.1)*12+((v_sal * 1.1)*nvl(v_com,0)*12));
                ELSE 
                    v_ysal := v_sal *12+(v_sal*(nvl(v_com,0)*12));
                END IF;
            DBMS_OUTPUT.PUT(v_ename); 
            DBMS_OUTPUT.PUT(', '||v_sal);
            DBMS_OUTPUT.PUT_LINE(', '||v_ysal); 
        END LOOP;
    CLOSE emp_cursor;
END;
/


DECLARE
    CURSOR emp_cursor IS
        SELECT last_name, salary, salary*12+(salary)*nvl(commission_pct,0)*12 as ysal
        FROM employees
        WHERE department_id = &부서번호;
    v_ename employees.last_name%TYPE;
    v_sal   employees.salary%TYPE;
--    v_com   employees.commission_pct%TYPE;
    v_ysal  NUMBER(10,2); 
BEGIN   --사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
    OPEN emp_cursor;
        LOOP
            FETCH emp_cursor INTO v_ename, v_sal, v_ysal;
            EXIT WHEN emp_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT(v_ename); 
            DBMS_OUTPUT.PUT(', '||v_sal);
            DBMS_OUTPUT.PUT_LINE(', '||v_ysal); 
        END LOOP;
    CLOSE emp_cursor;
END;
/

DECLARE
    CURSOR emp_cursor IS
        SELECT last_name, salary
        FROM employees
        WHERE department_id = &부서번호;
    v_ename employees.last_name%TYPE;
    v_sal   employees.salary%TYPE;
--    v_com   employees.commission_pct%TYPE;
    v_ysal  NUMBER(10,2); 
BEGIN   --사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
    OPEN emp_cursor;
    v_ysal := v_sal*12+(v_sal)*nvl(commission_pct,0)*12;
        LOOP
            FETCH emp_cursor INTO v_ename, v_sal, v_ysal;
            EXIT WHEN emp_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT(v_ename); 
            DBMS_OUTPUT.PUT(', '||v_sal);
            DBMS_OUTPUT.PUT_LINE(', '||v_ysal); 
        END LOOP;
    CLOSE emp_cursor;
END;
/

-- 커서 FOR LOOP
-- 예시
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, salary
        FROM employees;
BEGIN
    FOR emp_info IN emp_cursor LOOP --암묵적으로 OPEN과 FETCH 실행
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' : ' );
        DBMS_OUTPUT.PUT(emp_info.employee_id);
        DBMS_OUTPUT.PUT(', ' || emp_info.last_name);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_info.salary);
    END LOOP;--암묵적으로 CLOSE 실행
    
END;
/
