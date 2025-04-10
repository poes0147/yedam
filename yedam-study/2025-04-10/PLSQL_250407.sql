SET SERVEROUTPUT ON
-- PL/SQL에서 DML
-- 1) 문법은 동일하며 변수를 활용할 수 있음.
DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm employees.commission_pct%TYPE := .1;
BEGIN
    -- 1. SELECT문
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = &사원번호;
    
    -- 2. INSERT문
    INSERT INTO employees
                (employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno); 
    
    -- 3. UPDATE문
    UPDATE employees
    SET salary = (NVL(salary, 0) + 10000) * v_comm
    WHERE employee_id = 1000;    
    
    COMMIT;
END;
/
ROLLBACK;
SELECT *
FROM employees
WHERE employee_id IN (200,1000);
-- 2) 암시적 커서의 ROWCOUNT 속성을 이용해서 DML의 결과를 확인
BEGIN
    DELETE FROM employees
    WHERE employee_id = 0;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '개 행 이(가) 삭제되었습니다.');
    
    DELETE FROM employees
    WHERE employee_id = 1000;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '개 행 이(가) 삭제되었습니다.');
ENd;
/

-- 제어문 1) 조건문 : IF문, CASE문
-- 1) IF-THEN (기본 IF문) : 해당 조건식이 true인 경우만
-- 문법
IF 조건식 THEN
    수행할 명령어;
END IF;

-- 예시
DECLARE
    v_number NUMBER(2,0) := 13;
BEGIN
    IF MOD(v_number, 2) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('v_number는 홀수입니다.');
    END IF;
END;
/

-- 2) IF-THEN-ELSE ( IF ~ ELSE문) 
-- : 해당 조건식이 true인 경우와 false인 경우 동시 처리
-- 문법
IF 조건식 THEN
    조건식이 ture인 경우 수행할 명령어;
ELSE
    위의 모든 조건식들이 false인 경우 수행할 명령어;
END IF;

-- 예시
DECLARE
    v_number NUMBER(2,0) := 12;
BEGIN
    IF MOD(v_number, 2) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('v_number는 홀수입니다.');
    ELSE    
        DBMS_OUTPUT.PUT_LINE('v_number는 짝수입니다.');
    END IF;
END;
/

-- 3) IF-THEN-ELSIF ( 다중 IF문 ) : 여러 경우를 처리
-- 문법
IF 조건식 THEN
    조건식이 true인 경우 수행할 명령어;
ELSIF 추가 조건식1 THEN
    추가 조건식1이 true인 경우 수행할 명령어;
ELSIF 추가 조건식2 THEN
    추가 조건식2이 true인 경우 수행할 명령어;
ELSE
    위의 모든 조건식들이 false인 경우 수행할 명령어;
END IF;

-- 예시
DECLARE
    v_score NUMBER(2,0) := 87;
BEGIN
    IF v_score >= 90 THEN -- v_score BETWEEN 90 AND 99
        DBMS_OUTPUT.PUT_LINE('A학점');
    ELSIF v_score >= 80 THEN -- v_score BETWEEN 80 AND 89
        DBMS_OUTPUT.PUT_LINE('B학점');
    ELSIF v_score >= 70 THEN -- v_score BETWEEN 70 AND 79
        DBMS_OUTPUT.PUT_LINE('C학점');    
    ELSIF v_score >= 60 THEN -- v_score BETWEEN 60 AND 69
        DBMS_OUTPUT.PUT_LINE('D학점');
    ELSE                     -- v_score BETWEEN -99 AND 59
        DBMS_OUTPUT.PUT_LINE('F학점');
    END IF;

END;
/
SELECT * FROM employees;


/*
3.
사원번호를 입력(치환변수사용&)할 경우
입사일이 2005년 이후(2005년 포함)이면 'New employee' 출력
      2005년 이전이면 'Career employee' 출력
단, DBMS_OUTPUT.PUT_LINE ~ 은 한번만 사용

1) 입력 : 사원번호 -> 입사일로 변환 => SELECT문
SELECT  입사일자
FROM    employees
WHERE   사원번호

2) 입사일이 2005년 이후(2005년 포함) / 2005년 이전 구분 => 조건문
IF 입사일이 2005년 이후(2005년 포함) THEN
    'New employee' 출력
ELSE
    'Career employee' 출력
END IF;

*/

DECLARE
    v_hdate employees.hire_date%TYPE;
    v_msg VARCHAR2(100);
BEGIN
    -- 1)SELECT문
    SELECT  hire_date
    INTO v_hdate
    FROM    employees
    WHERE   employee_id = &사원번호;

    -- 2) 조건문
    -- IF v_hdate >= TO_DATE('20250101', 'yyyyMMdd') THEN
    IF TO_CHAR(v_hdate, 'yyyy') >= '2005' THEN
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

1) 입력 : 사원번호 => 사원번호, 사원이름, 입사일 : SELECT문
SELECT 사원번호, 사원이름, 입사일
FROM employees 
WHERE 사원번호 = &사원번호;

2)사원들 중 2005년 이후(2005년 포함)에 입사 / 2005년 이전에 입사한 사원
IF 2005년 이후(2005년 포함)에 입사 THEN
    3)사원의 사원번호, 사원이름, 입사일을 test01 테이블에 입력
    INSERT INTO test01 (사원번호, 사원이름, 입사일)
    VALUES (사원번호, 사원이름, 입사일);
ELSE
    test02 테이블에 입력
    INSERT INTO test02 (사원번호, 사원이름, 입사일)
    VALUES (사원번호, 사원이름, 입사일);
END IF;
*/
DECLARE
    v_eid   employees.employee_id%TYPE;   
    v_ename employees.last_name%TYPE;   
    v_hdate employees.hire_date%TYPE;
BEGIN
    -- 1) SELECT문
    SELECT employee_id, last_name, hire_date
    INTO  v_eid, v_ename, v_hdate
    FROM employees 
    WHERE employee_id = &사원번호;
    
    -- 2) 조건문
    IF TO_CHAR(v_hdate, 'yyyy') >= '2005' THEN
        -- 3) INSERT문
        INSERT INTO test01 (empid, ename, hiredate)
        VALUES (v_eid, v_ename, v_hdate);
    ELSE
        INSERT INTO test02 (empid, ename, hiredate)
         VALUES (v_eid, v_ename, v_hdate);
    END IF;
END;
/
SELECT * FROM test01;
SELECT * FROM test02;
/*
5.
급여가  5000이하이면 20% 인상된 급여
급여가 10000이하이면 15% 인상된 급여
급여가 15000이하이면 10% 인상된 급여
급여가 15001이상이면 급여 인상없음

사원번호를 입력(치환변수)하면 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오.
1) 입력 : 사원번호 -> 사원이름, 급여 => SELECT문
SELECT 사원이름, 급여
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

4) 출력 : 사원이름, 급여, 인상된 급여
*/
DECLARE
    v_ename  employees.last_name%TYPE;
    v_sal    employees.salary%TYPE;
    v_raise  NUMBER(4, 2);
    v_new    v_sal%TYPE;
BEGIN
    -- 1) SELECT문
    SELECT last_name, salary
    INTO v_ename, v_sal
    FROM employees
    WHERE employee_id = &사원번호; 

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

    -- 4) 출력 : 사원이름, 급여, 인상된 급여
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_sal);
    DBMS_OUTPUT.PUT_LINE(v_new);
END;
/

-- LOOP문
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Hello!');
    END LOOP;
END;
/

-- 1) 기본 LOOP문 : 무조건 반복한다를 전제로 사용
-- 사용문법 : EXIT문을 포함
LOOP
    -- 반복하고자 하는 코드
    EXIT WHEN 루프문을 종료할 조건식;
END LOOP;

-- 예시
DECLARE
    v_num NUMBER(1,0) := 1; -- 반복문을 제어할 변수
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('현재 v_num : ' || v_num);
        
        -- EXIT WHEN 에 사용하는 변수가 변경되는 코드가 반드시 필요!
        v_num := v_num + 1;
        -- 반복문을 종료할 조건
        EXIT WHEN v_num > 4;
    END LOOP;
END;
/

-- 실습) 정수 1부터 10까지 더한 총합을 구하세요.
-- 1) 정수 1부터 10까지를 표시할 변수 => LOOP문
-- ( 1, 2, 3, 4, 5, 6, 7, 8, 10)
DECLARE
    v_num NUMBER(2,0) := 1; -- 정수 1 ~ 10
    -- 2) 모든 정수의 합을 담을 변수
    v_sum NUMBER(2,0) := 0;
BEGIN
    LOOP
        -- 실제 수행할 코드 => 반복
        -- DBMS_OUTPUT.PUT_LINE(v_num);
        v_sum := v_sum + v_num;
        
        v_num := v_num + 1;
        -- 반복종료 조건
        EXIT WHEN v_num > 10;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('총합 : ' || v_sum);
END;
/


/*

6. 다음과 같이 출력되도록 하시오.
*         -- '*' 가 하나
**        -- '*' 가 둘
***       -- '*' 가 셋
****      -- '*' 가 넷
*****     -- '*' 가 다섯

=> '*' 갯수가 하나씩 증가 : LOOP문
*/
DECLARE
    v_tree VARCHAR2(6) := '*'; -- '*'을 담을 변수
    v_count NUMBER(1,0) := 1; -- LOOP문을 제어할 변수
BEGIN
    LOOP
        -- 반복코드 : '*' 갯수가 하나씩 증가해서 출력
        DBMS_OUTPUT.PUT_LINE(v_tree);
        v_tree := v_tree || '*';
        
        v_count := v_coun + 1;
        EXIT WHEN v_count > 5;
    END LOOP;
END;
/

DECLARE
    v_tree VARCHAR2(6) := '*'; -- '*'을 담을 변수
BEGIN
    LOOP
        -- 반복코드 : '*' 갯수가 하나씩 증가해서 출력
        DBMS_OUTPUT.PUT_LINE(v_tree);
        v_tree := v_tree || '*';
        EXIT WHEN LENGTH(v_count) > 5;
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
=> 치환변수 : 변수, 단을 입력
=> 곱하는 수 : 1에서 9까지, 정수값 ==> LOOP문
*/
DECLARE
    v_dan NUMBER(2,0) := &단; -- 단, 고정값
    v_num NUMBER(2,0) := 1;   -- 곱하는 수 : 1 ~ 9
BEGIN
    LOOP
        -- 2 * 1 = 2      v_dan * v_num = (v_dan * v_num)
        DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan * v_num));
        
        v_num := v_num + 1;
        -- 반복조건 : v_num <= 9;
        EXIT WHEN v_num > 9;
    END LOOP;

END;
/



/*
8. 구구단 2~9단까지 출력되도록 하시오.
- 단 : 2 ~ 9, 정수               => LOOP문, 첫번째
- 각 단에 곱하는수 : 1  ~ 9, 정수 => LOOP문, 두번째
*/
DECLARE
    v_dan NUMBER(2,0) := 2;  -- 단 : 2 ~ 9, 정수
    v_num NUMBER(2,0) := 1;   -- 곱하는 수 : 1 ~ 9
BEGIN
    LOOP -- 단을 제어하는 반복문
        DBMS_OUTPUT.PUT_LINE(v_dan);
        -- ** 중첩 LOOP문일 경우 주의 사항
        -- 안쪽 LOOP문이 실행될 때 변수가 가져야하는 값으로 초기화 작업을 진행
        v_num := 1;
        LOOP -- 각 단의 곱하는 수를 제어하는 LOOP문
            DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan * v_num));
        
            v_num := v_num + 1;
            EXIT WHEN v_num > 9;
        END LOOP;-- v_num : 10;
        V_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

-- 2) FOR LOOP문 : 횟수를 기준으로 반복
-- 문법
FOR 임시변수 IN 최소값 .. 최대값 LOOP
    -- 임시변수, 최소값, 최대값은 전부 정수타입
    반복 수행 작업;
END LOOP;

-- 예시
BEGIN
    -- FOR idx IN -115 .. -111 LOOP
    FOR idx IN 1 .. 5 LOOP
        DBMS_OUTPUT.PUT_LINE('임시변수 idx : ' || idx);
    END LOOP;
END;
/
-- 주의사항 1) 임시변수는 수정 불가(Read Only)
BEGIN
    FOR idx IN 1 .. 5 LOOP
        idx := ( idx * 1);
    END LOOP;
END;
/
-- 주의사항 2) 최소값 보다 항상 최대값이 같거나 커야한다.
-- REVERSE : 역순으로 값을 가져올 때 사용
BEGIN
    FOR idx IN REVERSE 1 .. 5 LOOP
        DBMS_OUTPUT.PUT_LINE(idx);
    END LOOP;
END;
/

-- 정수 1 ~ 10까지 총합
-- ( 1,2,3,4,5,6,7,8,9,10) => LOOP문
DECLARE
    v_sum NUMBER(2,0) := 0; -- 총합
BEGIN
    FOR num IN 1 .. 10 LOOP -- 정수 1 ~ 10
        v_sum := v_sum + num;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

/*

6. 다음과 같이 출력되도록 하시오.
*         -- 첫번째 줄, '*'가 하나
**        -- 두번째 줄, '*'가 둘
***       -- 세번째 줄, '*'가 셋
****      -- 네번째 줄, '*'가 넷
*****     -- 다섯번째 줄, '*'가 다섯 
=> '*' 갯수가 하나씩 증가 : LOOP문
*/

DECLARE
    v_tree VARCHAR2(6) := '*';
BEGIN
    FOR idx IN 1 .. 5 LOOP
        DBMS_OUTPUT.PUT_LINE(v_tree);
        v_tree := v_tree || '*';
    END LOOP;
END;
/

-- 이중 LOOP문
BEGIN
    FOR line IN 1 .. 5 LOOP -- line
        FOR count IN 1 .. line LOOP -- 각 line 별 '*' 갯수
             DBMS_OUTPUT.PUT('*'); -- Java의 System.out.print()
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(''); -- 반드시 마지막은 PUT_LINE을 실행해야 함.
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
    v_dan NUMBER(1,0) := &단;
BEGIN
    FOR num IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || '*' || num || '=' || (v_dan * num));
    END LOOP;
END;
/
/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/
BEGIN
    FOR dan IN 2 .. 9 LOOP -- 단을 제어하는 LOOP문
        FOR num IN 1 .. 9 LOOP -- 각 단별로 곱하는 수를 제어하는 LOOP문
            DBMS_OUTPUT.PUT_LINE(dan || '*' || num || '=' || (dan * num));
        END LOOP;
    END LOOP;
END;
/

-- 옆으로 각 단을 세로로 출력
BEGIN
    FOR num IN 1 .. 9 LOOP -- 각 단별로 곱하는 수를 제어하는 LOOP문
        FOR dan IN 2 .. 9 LOOP -- 단을 제어하는 LOOP문        
            DBMS_OUTPUT.PUT(dan || '*' || num || '=' || (dan * num) || ' ' );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/


/*
9. 구구단 1~9단까지 출력되도록 하시오.
   (단, 홀수단 출력)
*/

BEGIN
    FOR dan IN 2 .. 9 LOOP -- 단을 제어하는 LOOP문
        IF MOD(dan, 2) = 1 THEN
            FOR num IN 1 .. 9 LOOP -- 각 단별로 곱하는 수를 제어하는 LOOP문
                DBMS_OUTPUT.PUT_LINE(dan || '*' || num || '=' || (dan * num));
            END LOOP;
        END IF;
    END LOOP;
END;
/

-- 옆으로 각 단을 세로로 출력
BEGIN
    FOR num IN 1 .. 9 LOOP -- 각 단별로 곱하는 수를 제어하는 LOOP문
        FOR dan IN 2 .. 9 LOOP -- 단을 제어하는 LOOP문 
            CONTINUE WHEN MOD(dan, 2) = 0;
            
            DBMS_OUTPUT.PUT(dan || '*' || num || '=' || (dan * num) || ' ' );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
