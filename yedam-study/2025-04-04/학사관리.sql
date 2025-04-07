CREATE TABLE department (
    deptid NUMBER(10) NOT NULL,
    deptname VARCHAR2(10),
    loaction VARCHAR2(10),
    tel VARCHAR2(15)
);

CREATE TABLE employee (
    empid NUMBER(10) NOT NULL,
    empname VARCHAR2(10),
    hiredate DATE,
    addr VARCHAR2(12),
    tel VARCHAR2(15),
    deptid NUMBER(10)
);

ALTER TABLE employee ADD birthday DATE;

INSERT INTO department (deptid, deptname, loaction, tel) VALUES (1001, 'ÃÑ¹«ÆÀ', 'º»101È£', '053-777-8777');

INSERT INTO department (deptid, deptname, loaction, tel) VALUES (1002, 'È¸°èÆÀ', 'º»102È£', '053-888-9999');

INSERT INTO department (deptid, deptname, loaction, tel) VALUES (1002, '¿µ¾÷ÆÀ', 'º»103È£', '053-222-3333');

INSERT INTO employee (empid, empname, hiredate, addr, tel, deptid) VALUES (20121945, '¹Ú¹Î¼ö', '20120302', '´ë±¸', '010-1111-1234', 1001);

INSERT INTO employee (empid, empname, hiredate, addr, tel, deptid) VALUES (20101817, '¹ÚÁØ½Ä', '20100901', '°æ»ê', '010-2222-1234', 1003);
INSERT INTO employee (empid, empname, hiredate, addr, tel, deptid) VALUES (20122245, '¼±¾Æ¶ó', '20120302', '´ë±¸', '010-3333-1222', 1002);
INSERT INTO employee (empid, empname, hiredate, addr, tel, deptid) VALUES (20121729, 'ÀÌ¹ü¼ö', '20110302', '¼­¿ï', '010-3333-4444', 1001);
INSERT INTO employee (empid, empname, hiredate, addr, tel, deptid) VALUES (20121646, 'ÀÌÀ¶Èñ', '20120901', 'ºÎ»ê', '010-1234-2222', 1003);

ALTER TABLE employee MODIFY empname NOT NULL;


SELECT e.empname, e.hiredate, d.deptname
FROM employee e,  department d
WHERE 'ÃÑ¹«ÆÀ' = d.deptname;

DELETE employee WHERE '´ë±¸' = addr;

SELECT e.empid, e.empname, e.birthday, d.deptname
FROM employee e,  department d
WHERE hiredate > (SELECT hiredate FROM employee WHERE empid = 20121729);
