SET SERVEROUTPUT ON;
/
--2번
/
DECLARE
    v_dname departments.department_name%TYPE;
    v_jid employees.job_id%TYPE;
    v_sla employees.salary%TYPE;
    v_ysal NUMBER(10,2);
BEGIN
    SELECT d.department_name, e.job_id, e.salary, e.salary*12+(NVL(e.salary,0)*NVL(commission_pct,0)*12)
    INTO v_dname, v_jid, v_sla, v_ysal
    FROM employees e 
    JOIN departments d ON e.department_id = d.department_id
    WHERE employee_id = &사원번호;  
    
    DBMS_OUTPUT.PUT('사원의 부서명은: ' || v_dname);
    DBMS_OUTPUT.PUT(' 직업은:  ' || v_jid);
    DBMS_OUTPUT.PUT(' 월급은:  ' || v_sla);
    DBMS_OUTPUT.PUT_LINE(' 연봉은:  ' || v_ysal);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 존재하지 않습니다.');   
END;
/


--3번
/
DECLARE
    v_hdate employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &입사번호;
    
    IF TO_CHAR(v_hdate, 'YYYY') > '2005' THEN
        DBMS_OUTPUT.PUT_LINE('NEW EMPLOYEE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employees');
    END IF;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원은 없습니다.');  
END;
/


--4번
BEGIN
    FOR dan IN 1 .. 9LOOP
        IF MOD (dan,2) = 1 THEN
            DBMS_OUTPUT.PUT( RPAD(dan || '단',13));
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
--5번

DECLARE
    CURSOR dep_no IS
        SELECT emploYee_id, last_name, salary
        FROM employees 
        WHERE department_id = &부서번호;
    v_eid employees.employee_id%TYPE;
    v_name employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
BEGIN
    OPEN dep_no;
    LOOP
        FETCH dep_no INTO v_eid, v_name, v_sal;
        EXIT WHEN dep_no%NOTFOUND;
            DBMS_OUTPUT.PUT(dep_no%ROWCOUNT);
            DBMS_OUTPUT.PUT(' : '||v_eid); 
            DBMS_OUTPUT.PUT(', '||v_name);
            DBMS_OUTPUT.PUT_LINE(', '||v_sal);
    END LOOP;
    CLOSE dep_no;
END;
/

--6번 

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


--7번

DROP PROCEDURE jumin;

CREATE PROCEDURE jumin
(p_id_no IN VARCHAR2)
IS
    p_age NUMBER(10);
    p_gender NUMBER(2);
    p_resuly VARCHAR(10);
BEGIN
    p_gender := TO_NUMBER(SUBSTR(p_id_no,7,1));
    IF p_gender > 3 THEN
        p_age := SUBSTR(20250410 - TO_NUMBER('20'||SUBSTR(p_id_no,1,6)),1,2);
        IF MOD(p_gender,2)=1 THEN
        DBMS_OUTPUT.PUT_LINE('만' || p_age || '세 남자');
        ELSE
        DBMS_OUTPUT.PUT_LINE('만' || p_age || '세 여자');
        END IF;
    ELSE 
        p_age := SUBSTR(20250410 - TO_NUMBER('19'||SUBSTR(p_id_no,1,6)),1,2);
        IF MOD(p_gender,2)=1 THEN
        DBMS_OUTPUT.PUT_LINE('만' || p_age || '세 남자');
        ELSE
        DBMS_OUTPUT.PUT_LINE('만' || p_age || '세 여자');
        END IF;
    END IF;
END;
/


/
EXECUTE jumin('1010154234567');
/


--8번 
DROP FUNCTION get_emp;
/
CREATE FUNCTION get_emp
(p_eno IN employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_hdate employees.hire_date%TYPE;
    v_years VARCHAR2(10);
BEGIN
        SELECT hire_date
        INTO v_hdate
        FROM employees
        WHERE employee_id = p_eno;

        v_years := (TO_CHAR(CEIL(MONTHS_BETWEEN(sysdate, v_hdate)/12))|| '년');
        RETURN v_years;
END;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(get_emp(174));
/

--9번 
DROP FUNCTION get_dpt;
/
CREATE FUNCTION get_dpt
(p_dpt IN departments.department_name%TYPE)
RETURN VARCHAR2
IS
--    v_dname departments.department_name%TYPE;
    v_mng VARCHAR2(100);
BEGIN
        SELECT last_name
        INTO v_mng
        FROM employees
        WHERE employee_id = 
            (SELECT manager_id
             FROM departments
             WHERE department_name = p_dpt);

--        v_years := (TO_CHAR(CEIL(MONTHS_BETWEEN(sysdate, v_hdate)/12))|| '년');
        RETURN v_mng;
END;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(get_dpt('IT'));
/

--10번 hr 사용자에게 존재하는 procedure, function, package, apakage body
-- 이름과 소스를 한꺼번에 확인하는 sql구문을 작성
SELECT name, text
FROM user_source
WHERE type
IN ('PROCUDURE', 'FUNCTION', 'PACKAGE', 'PACKGE BODY');
/

--11번
BEGIN
    FOR star IN 1 .. 10LOOP
        DBMS_OUTPUT.PUT(LPAD('----------',10-star,'*')); -- 1,2,3,4....
        DBMS_OUTPUT.PUT_LINE(RPAD('**********',star,'-')); -- 9,8,7
    END LOOP;
END;
/

