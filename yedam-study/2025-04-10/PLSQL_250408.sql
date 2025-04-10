SET SERVEROUTPUT ON
-- 조합데이터 : RECORD ( 필드1, 필드2, ... ) => 객체
-- 사용방법
DECLARE
    -- 1) TYPE 정의
    TYPE 레코드타입이름 IS RECORD
        (필드명1 데이터타입,
         필드명2 데이터타입 NOT NULL DEFAULT 초기값,
         필드명3 데이터타입 := 초기값,
         ...);
    -- 2) 변수 선언
    변수명 레코드타입이름;
BEGIN
    -- 3) 실제사용 : 변수명.필드명
    변수명.필드명1 := 값;
    DBMS_OUTPUT.PUT_LINE(변수명.필드명2);
END;
/


-- 예시  : 회원정보를 하나의 변수로 다룸
DECLARE
    -- 회원정보(아이디, 이름, 가입일자)를 의미
    -- 1) RECORD 정의
    TYPE user_record_type IS RECORD
        ( user_id NUMBER(6,0),
          user_name VARCHAR2(100) := '익명',
          join_date DATE NOT NULL DEFAULT SYSDATE);
          
    -- 2) 변수선언
    first_user user_record_type;
    new_user user_record_type;
BEGIN
    -- 3) 실제 사용 : 변수명.필드명
    -- DBMS_OUTPUT.PUT_LINE(first_user);
    DBMS_OUTPUT.PUT_LINE(first_user.user_id);
    DBMS_OUTPUT.PUT_LINE(first_user.user_name);
    DBMS_OUTPUT.PUT_LINE(first_user.join_date);
END;
/
-- 특정 사원의 사원번호, 사원이름, 급여를 출력하세요.
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
-- RECORD 적용
DECLARE
    -- 1) TYPE 정의
    TYPE emp_record_type IS RECORD
        (empno NUMBER(6,0),
         ename employees.last_name%TYPE NOT NULL := 'Hong',
         sal employees.salary%TYPE := 0);
    -- 2) 변수 선언
    v_emp_info emp_record_type;
    v_emp_record emp_record_type;
BEGIN
    -- 변수 사용
    SELECT employee_id, last_name, salary
    -- INTO v_eid, v_ename, v_sal
    INTO v_emp_info
    -- 무조건 RECORD 타입 변수 하나만 사용
    FROM employees
    WHERE employee_id = 100;
    
    SELECT employee_id, last_name, salary
    -- INTO v_new_eid, v_new_ename, v_new_sal
    INTO v_emp_record
    -- emp_record_type ( empno, ename, sal )
    FROM employees
    WHERE employee_id = 200;
    
    -- 사원번호 100
    DBMS_OUTPUT.PUT(v_emp_info.empno);
    DBMS_OUTPUT.PUT(', ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', ' || v_emp_info.sal);
    -- 사원번호 200
    DBMS_OUTPUT.PUT(v_emp_record.empno);
    DBMS_OUTPUT.PUT(', ' || v_emp_record.ename);
    DBMS_OUTPUT.PUT_LINE(', ' || v_emp_record.sal);
END;
/

-- %ROWTYPE
-- 테이블, VIEW, 명시적 커서의 한행을 RECORD 타입으로 참조하도록 사용
-- 1) 필드명을 따로 지정 불가, 참조하는 테이블의 컬렴명과 동일한 필드명 사용
-- 2) SELECT할 때 사용 시 반드시 해당 테이블의 모든 컬럼을 선언 => * 사용
DECLARE
    -- 1) TYPE 정의 => 생략
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
SELECT * 
FROM employees;

-- 명시적 커서
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

-- 1) 목적 : 다중 행 SELECT문을 사용
DECLARE
    -- 1. 커서 정의 => 실행 X
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE department_id = &부서번호;
    -- 부서번호 50 :
    -- 부서번호  0 : 
        
    -- 값을 담을 변수 선언 : 커서의 SELECT절 컬럼 수만큼 필요
    v_eid   employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    -- 2. 커서 실행
    -- 2-1. 실제 SELECT문을 실행
    -- 2-2. 포인터의 위치를 가장 위로 배치
    OPEN emp_cursor;
    
    -- 3. 데이터 확인 및 반환 => 1건의 데이터만
    -- 3-1. 포인터를 밑으로 이동
    -- 3-2. 현재 포인터가 가리키는 한 행을 반환
    FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
    
    -- 가져온 데이터를 기반으로 작업
    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_hdate);
    
    -- 4. 커서 종료
    -- 4-1. 메모리에서 결과를 삭제
    CLOSE emp_cursor;
END;
/
-- 명시적 커서 + 기본 LOOP문
DECLARE
    -- 1. 커서 정의 => 실행 X
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE department_id = &부서번호;
    -- 부서번호 50 :
    -- 부서번호  0 : 
        
    -- 값을 담을 변수 선언 : 커서의 SELECT절 컬럼 수만큼 필요
    v_eid   employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    -- 2. 커서 실행
    OPEN emp_cursor;
    
    LOOP
        -- 3. 데이터 확인 및 반환 => 1건의 데이터만
        FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
        -- FETCH를 기반으로 가져온 데이터가 새로운 데이터가 아닌 경우
        EXIT WHEN emp_cursor%NOTFOUND;
        
        
        -- 1) LOOP문 안에선 현재 가지고 온 행의 갯수, 유동적
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' : ' );
        -- 가져온 데이터를 기반으로 작업
        DBMS_OUTPUT.PUT(v_eid);
        DBMS_OUTPUT.PUT(', ' || v_ename);
        DBMS_OUTPUT.PUT_LINE(', ' || v_hdate);        
    END LOOP; -- 커서가 가진 모든 데이터를 가져온 상황
    
    -- 2) LOOP문 바깥에선 커서가 가지고 있는 총 데이터의 갯수, 고정적 
    DBMS_OUTPUT.PUT_LINE('LOOP 종료 : ' || emp_cursor%ROWCOUNT);
    
    -- 4. 커서 종료
    CLOSE emp_cursor;
END;
/

-- 사용방법 정리
DECLARE
    -- 1) 커서 정의
    CURSOR 커서명 IS   
        커서가 실행할 SELECT문; 
BEGIN
    -- 2) 커서 실행
    OPEN 커서명;
    
    LOOP
        -- 3) 데이터 확인 및 반환
        FETCH 커서명 INTO 값을 담을 변수들;
        EXIT WHEN 커서명%NOTFOUND;
        
        -- 새로운 데이터가 있는 경우 진행할 작업
        -- 커서명%ROWCOUNT : 현재 몇번째 행, 유동값
    END LOOP;
    -- 커서명%ROWCOUNT : 커서가 가진 총 행수, 고정값
    
    -- 4) 커서 종료
    CLOSE 커서명;
    -- CLOSE 후 %ISOPEN을 제외한 속성에 접근 불가
END;
/

/* 
특정 업무를 수행하는 사원의 정보를 출력하세요.
출력할 사원의 정보는 사원번호, 사원이름, 입사일자 입니다.
1) 출력 : SELECT문, 다중행 => 명시적 커서
2) 입력 : 특정업무(job_id) => 출력 : 사원번호, 사원이름, 입사일자
단, 해당 업무를 수행하는 사원이 없는 경우
'해당 사원이 없습니다.'라고 출력합니다.
*/ 
-- SELECT문
SELECT employee_id, last_name, hire_date
FROM    employees
WHERE job_id LIKE UPPER('&업무%');

-- 명시적커서 
DECLARE
    -- 1) 커서 선언
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM    employees
        WHERE job_id LIKE UPPER('&업무%');
        
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    -- 2) 커서 실행
    OPEN emp_cursor;
    
    LOOP
        -- 3) 데이터 인출 및 확인
        FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        -- 데이터가 존재하는 경우 실행할 작업
        DBMS_OUTPUT.PUT(v_eid);
        DBMS_OUTPUT.PUT(', ' || v_ename);
        DBMS_OUTPUT.PUT_LINE(', ' || v_hdate);
    END LOOP; -- 커서의 데이터를 다 가져온 상황
    
    IF emp_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원이 없습니다.');
    END IF;
    
    -- 4) 커서 종료
    CLOSE emp_cursor;
END;
/


/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.
=> SELECT문, employees 전체조회
입사년도가 2005년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2005년 이후 입사한 사원은 test02 테이블에 입력
=> 조건문 IF ~ ELSE문
IF 입사년도 <= 2015년 THEN
    => INSERT문
    INSERT INTO test01 (empid, ename, hiredate)
    VALUES ();
ELSE 
    => INSERT문
    INSERT INTO test02 (empid, ename, hiredate)
    VALUES ();
END IF;
*/
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;

    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        IF TO_CHAR(v_hdate, 'yyyy') <= '2005' THEN
            INSERT INTO test01(empid, ename, hiredate)
            VALUES (v_eid, v_ename, v_hdate);
        ELSE
            INSERT INTO test02(empid, ename, hiredate)
            VALUES (v_eid, v_ename, v_hdate);
        END IF;
    END LOOP;
    CLOSE emp_cursor;
END;
/
DELETE test02;
SELECT * FROM test01;
SELECT * FROM test02;

-- 명시적 커서와 RECORD 
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id  AS eid, last_name AS ename, hire_date
        FROM employees;
        
    -- 커서가 가진 SELECT문의 컬럼 구성으로 RECORD 타입 생성
    v_emp_info emp_cursor%ROWTYPE;
    -- emp_cursor%ROWTYPE : (employee_id , last_name , hire_date)
BEGIN
    OPEN emp_cursor;

    LOOP 
        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;

        -- 데이터가 존재하는 경우
        IF TO_CHAR(v_hdate,'yyyy') <= '2005' THEN
            INSERT INTO test01 (empid, ename, hiredate)
            -- 커서를 기반으로 만들어진 RECORD 타입의 필드는 컬럼명. 단, 별칭을 사용한 경우 별칭이 필드명
            VALUES (v_emp_info.eid, v_emp_info.ename, v_emp_info.hire_date);
        ELSE 
            -- 레코드 타입의 구성과 테이블의 컬럼 구성이 같을 경우
            INSERT INTO test02 
            VALUES v_emp_info;
        END IF;
    END LOOP;

    CLOSE emp_cursor;
END;
/

/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
=> SELECT문, 다중행 : 명시적 커서
입력 : 부서번호 -> 출력 : 사원이름, 입사일자, 부서명
- employees ( 부서번호, 사원이름, 입사일자 )
- departments ( 부서번호, 부서명 )

-- JOIN
SELECT e.last_name, e.hire_date, d.department_name
FROM employees e
     JOIN departments d
     ON e.department_id = d.department_id
WHERE e.department_id = &부서번호;
*/
DECLARE
    --커서 선언
    CURSOR emp_cursor IS
        SELECT e.last_name, e.hire_date, d.department_name
        FROM employees e
        JOIN departments d
        ON e.department_id = d.department_id
        WHERE e.department_id = &부서번호; 
    --변수 선언
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    --커서 실행
    OPEN emp_cursor;
    --반복문 실행
    LOOP
        --데이터 인출
        FETCH emp_cursor INTO v_ename, v_hdate, v_dname;
        --반복문 종료조건
        EXIT WHEN emp_cursor%NOTFOUND;
        --데이터 처리
        DBMS_OUTPUT.PUT(v_ename);
        DBMS_OUTPUT.PUT(', ' || v_hdate);
        DBMS_OUTPUT.PUT_LINE(', ' || v_dname);
    END LOOP;
    --커서 종료
    CLOSE emp_cursor;
    
    -- 커서 재오픈
END;
/
/*
3.
부서번호를 입력(&사용)할 경우 
사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
=> SELECT문, 다중행 : 명시적 커서
입력 : 부서번호 -> 출력 : 사원이름, 급여, 연봉
                        연봉 (급여*12+(급여*nvl(커미션퍼센트,0)*12))
SELECT last_name, salary, commission_pct
FROM employees
WHERE department_id = &부서번호;
*/

DECLARE 
    CURSOR emp_cursor IS
                  SELECT last_name,
                         salary,
                         salary*12+(salary*nvl(commission_pct,0)*12) AS years
                  FROM employees
                  WHERE department_id = &사원번호;
    emp_info emp_cursor%ROWTYPE;
    
BEGIN
    OPEN emp_cursor;
   LOOP
        FETCH emp_cursor INTO emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(emp_info.last_name);
        DBMS_OUTPUT.PUT_LINE(emp_info.salary);
        DBMS_OUTPUT.PUT_LINE(emp_info.years);
   END LOOP;
   CLOSE emp_cursor;
END;
/

DECLARE
    CURSOR emp_of_dept_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id = &부서번호;
    
    v_ename employees.last_name%TYPE;
    v_sal   employees.salary%TYPE;
    v_comm  employees.commission_pct%TYPE;
    
    v_annual NUMBER;
BEGIN
    OPEN emp_of_dept_cursor;

    LOOP
        FETCH emp_of_dept_cursor INTO v_ename, v_sal, v_comm;
        EXIT WHEN emp_of_dept_cursor%NOTFOUND;

        -- 데이터가 존재하는 경우
        v_annual := (v_sal*12+(v_sal*nvl(v_comm,0)*12));

        DBMS_OUTPUT.PUT(v_ename);
        DBMS_OUTPUT.PUT(', ' || v_sal);
        DBMS_OUTPUT.PUT_LINE(', ' || v_annual);
    END LOOP;

    CLOSE emp_of_dept_cursor;
END;
/

-- 커서 FOR LOOP 
-- 예시
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, salary
        FROM employees
        WHERE employee_id = 0; 
BEGIN
    FOR emp_info IN emp_cursor LOOP -- 암묵적으로 OPEN과 FETCH 실행
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' : ');
        DBMS_OUTPUT.PUT(emp_info.employee_id);
        DBMS_OUTPUT.PUT(', ' || emp_info.last_name);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_info.salary);
    END LOOP; -- => 암묵적으로  CLOSE 실행
    DBMS_OUTPUT.PUT_LINE('Result : ' || emp_cursor%ROWCOUNT);
END;
/

