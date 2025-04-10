SET SERVEROUTPUT ON
-- PL/SQL 블록
BEGIN
    -- 한줄 주석
    /*
        여러줄 주석
    */
    DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL!');
END;
/

-- 변수 선언
DECLARE
    -- identifier[constant] datatype[not null] [:= | DEFAULT expr];
    -- 기본 사용 : 변수명 데이터타입;
    v_str VARCHAR2(100);
    -- 상수 선언 : 변수명 CONSTANT 데이터타입 := 표현식;
    v_num CONSTANT NUMBER(2,0) := 10;
    -- NOT NULL 적용 : 변수명 데이터타입 NOT NULL := 표현식;
    v_count NUMBER(1,0) NOT NULL := 5;
    -- 변수 선언 및 초기화 : 변수명 데이터타입 := 표현식;
    v_sum NUMBER(3,0) := (v_num + v_count);
BEGIN
    -- v_str := 'Hello';
    -- CONSTANT ) 상수로 선언한 변수의 값을 변경할 경우
    -- v_num := 100;
    -- NOT NULL ) NOT NULL 제약조건을 설정한 변수에 null을 할당할 경우
    -- v_count := null;
    -- NUMBER(3,0) ) 데이터 크기보다 큰 값을 할당할 경우
    -- v_sum := v_num + 1234;
    
    
    DBMS_OUTPUT.PUT_LINE('v_str : ' || v_str);
    DBMS_OUTPUT.PUT_LINE('v_num : ' || v_num);
    DBMS_OUTPUT.PUT_LINE('v_count : ' || v_count);
    DBMS_OUTPUT.PUT_LINE('v_sum : ' || v_sum);
END;
/

-- PL/SQL에서 함수 사용
DECLARE
    -- 선언부
    v_today DATE := SYSDATE;
    -- v_after_day employees.hire_date%TYPE;
    v_after_day v_today%TYPE;
    v_msg VARCHAR2(100);
BEGIN
    -- 실행부
    v_after_day := ADD_MONTHS(v_today, 3);
    v_msg := TO_CHAR(v_after_day, 'yyyy"년" MM"월" dd"일"');
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/

-- PL/SQL의 SELECT문
-- 1) 예시
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    -- 조회한 데이터를 변수에 담는 구문
    INTO v_ename
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
END;
/

SELECT last_name
-- INTO v_ename
FROM employees
WHERE employee_id = 100;

-- 2) 결과는 반드시  Only One!
DECLARE
    v_ename VARCHAR2(100);
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    -- 부서번호 10 : 정상실행 
    -- 부서번호 50 : TOO_MANY_ROWS(ORA-01422: exact fetch returns more than requested number of rows)
    -- 부서번호  0 : NO_DATA_FOUND(ORA-01403: no data found)
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
END;
/

-- 3) SELECT 절의 컬럼과 INTO 절의 변수 관계
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename VARCHAR2(100);
BEGIN
    SELECT employee_id, last_name
    INTO v_eid, v_ename
    -- SELECT > INTO ) ORA-00947: not enough values
    -- SELECT < INTO ) ORA-00913: too many values
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid || ', 사원이름 : ' || v_ename);
END;
/

-- 실습예제
/* 
 사원번호를 입력(치환변수)할 경우 해당 
 사원의 이름과 입사일자를 출력하는 PL/SQL을 작성하세요.
 1) SQL문 확인 ) 출력 => SELECT문
 입력 : 사원번호 -> 출력 : 사원의 이름, 입사일자 ( 테이블 employees )
 
 SELECT 사원이름, 입사일자
 FROM employees
 WHERE 사원번호
 
 2) PL/SQL 블록 생성
 */
 -- 1) SELECT문
SELECT employee_id, hire_date
FROM employees
WHERE employee_id = &사원번호;

 -- 2) PL/SQL 블록
DECLARE
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    SELECT last_name, hire_date
    INTO v_ename, v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename || ', 입사일자 : ' || v_hdate);
END;
/

/*
1.
사원번호를 입력(치환변수사용&)할 경우
사원번호, 사원이름, 부서이름  
을 출력하는 PL/SQL을 작성하시오.
1) SQL문 : 출력 => SELECT문
SELECT 사원번호, 사원이름, 부서이름  
FROM employees JOIN departments
    ON employees.department_id = departments.department_id
WHERE 사원번호

2) PL/SQL 블록
*/
-- 1) SELECT문
SELECT employee_id, last_name, department_name  
FROM employees e
    JOIN departments d
    ON e.department_id = d.department_id
WHERE employee_id = &사원번호;

--2) PL/SQL블록
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_dept_name departments.department_name%TYPE;
BEGIN
    SELECT employee_id, last_name, department_name  
    INTO v_eid, v_ename, v_dept_name
    FROM employees e
        JOIN departments d
        ON e.department_id = d.department_id
    WHERE employee_id = &사원번호;

    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_dept_name);
END;
/
/*
2.
사원번호를 입력(치환변수사용&)할 경우 
사원이름, 
급여, 
연봉->(급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
1) SQL문 : 출력 => SELECT문
입력 : 사원번호 -> 출력 : 사원이름, 급여, 연봉
                        연봉(급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12))
                        
SELECT 사원이름, 급여, 연봉(급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12))
FROM employees
WHERE 사원번호
*/
-- 1) SELECT문
SELECT last_name, salary, (salary*12+(NVL(salary,0)*NVL(commission_pct,0)*12))
FROM employees
WHERE employee_id = &사원번호;

-- 2) PL/SQL 블록
DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_year NUMBER(15, 2);
BEGIN
    SELECT last_name, salary, (salary*12+(NVL(salary,0)*NVL(commission_pct,0)*12))
    INTO v_ename, v_sal, v_year
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_sal);
    DBMS_OUTPUT.PUT_LINE(v_year);
END;
/



