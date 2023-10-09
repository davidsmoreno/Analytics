

select * from instructor

/* Tenemos las columnas ins_id,lastname,firstname,city,country\*
*/

insert into instructor(ins_id,lastname,firstname,city,country)
values(4,'Sagha','Sandip','Edomnton','Ca')


INSERT INTO JOB_HISTORY (EMP_ID, START_DATE, JOB_ID, DEPT_ID)
VALUES
    (1001, '2000-01-30', 100, 10001),
    (1002, '2010-08-16', 200, 10002),
    (1003, '2016-08-10', 300, 10003);


update instructor
set city='Toronto'
where firstname="Sandip"



delete from instructor
where ins_id=6;

ALTER TABLE table_name
ADD COLUMN column_name data_type column_constraint;

TRUNCATE TABLE author;
Elmina todos los registros de la tabla 

If wee dont know the name of the author or any stting
we can use like 'R%' porcentaje de las palabras

SELECT F_NAME , L_NAME
FROM EMPLOYEES
WHERE ADDRESS LIKE '%Elgin,IL%';


    SELECT F_NAME , L_NAME
    FROM EMPLOYEES
    WHERE B_DATE LIKE '197%';


SELECT *
FROM EMPLOYEES
WHERE (SALARY BETWEEN 60000 AND 70000) AND DEP_ID = 5;


Retrieve all employees in department 5 whose salary is between 60000 and 70000.

    select EMP_ID, F_NAME, L_NAME, SALARY 
    from EMPLOYEES
    where SALARY < (select AVG(SALARY) 
                    from EMPLOYEES);

select EMP_ID, SALARY, ( select MAX(SALARY) from EMPLOYEES ) AS MAX_SALARY 
from EMPLOYEES;


select * from ( select EMP_ID, F_NAME, L_NAME, DEP_ID from EMPLOYEES) AS EMP4ALL;

Implicit Join 

select * from EMPLOYEES where JOB_ID IN (select JOB_IDENT from JOBS);

select * from EMPLOYEES where JOB_ID IN (select JOB_IDENT from JOBS where JOB_TITLE= 'Jr. Designer');

select JOB_TITLE, MIN_SALARY,MAX_SALARY,JOB_IDENT from JOBS where JOB_IDENT IN (select JOB_ID from EMPLOYEES where SALARY > 70000 );

select JOB_TITLE, MIN_SALARY,MAX_SALARY,JOB_IDENT from JOBS where JOB_IDENT IN (select JOB_ID from EMPLOYEES where YEAR(B_DATE)>1976 );

<<<<<<< HEAD

    select E.EMP_ID,E.L_NAME,E.DEP_ID,D.DEP_NAME
    from EMPLOYEES AS E 
    LEFT OUTER JOIN DEPARTMENTS AS D ON E.DEP_ID=D.DEPT_ID_DEP;


    select E.F_NAME,E.L_NAME, JH.START_DATE, J.JOB_TITLE 
    from EMPLOYEES as E 
    INNER JOIN JOB_HISTORY as JH on E.EMP_ID=JH.EMPL_ID 
    INNER JOIN JOBS as J on E.JOB_ID=J.JOB_IDENT
    where E.DEP_ID ='5';


SELECT E.EMP_ID,E.L_NAME,E.DEPT_ID,D.DEPT_NAME FROM EMPLOYEES AS E
LEFT OUTER JOIN DEPARTMENTS AS D
ON E.DEPT_ID=D.DEPT_ID_DEP
WHERE YEAR(E.B_DATE)<1980


select E.F_NAME,E.L_NAME,D.DEP_NAME
from EMPLOYEES AS E 
LEFT OUTER JOIN DEPARTMENTS AS D ON E.DEP_ID=D.DEPT_ID_DEP

UNION

select E.F_NAME,E.L_NAME,D.DEP_NAME
from EMPLOYEES AS E 
RIGHT OUTER JOIN DEPARTMENTS AS D ON E.DEP_ID=D.DEPT_ID_DEP



SELECT
    CPS.NAME_OF_SCHOOL AS School_Name,
    SSD.COMMUNITY_AREA_NAME AS Community_Name,
    CPS.AVERAGE_STUDENT_ATTENDANCE AS Average_Attendance
FROM
    chicago_public_schools AS CPS
JOIN
    chicago_socioeconomic_data AS SSD
ON
    CPS.COMMUNITY_AREA_NUMBER = SSD.COMMUNITY_AREA_NUMBER
WHERE
    SSD.HARDSHIP_INDEX = 98;


CREATE VIEW ChicagoSchoolsView AS
SELECT
    NAME_OF_SCHOOL AS School_Name,
    Safety_Icon AS Safety_Rating,
    Family_Involvement_Icon AS Family_Rating,
    Environment_Icon AS Environment_Rating,
    Instruction_Icon AS Instruction_Rating,
    Leaders_Icon AS Leaders_Rating,
    Teachers_Icon AS Teachers_Rating
FROM
    CHICAGO_PUBLIC_SCHOOLS;



DELIMITER //

CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_ICON(
    IN in_School_ID INT,
    IN in_Leaders_Rating INT
)
BEGIN
    DECLARE leaders_icon_value VARCHAR(11);

    IF in_Leaders_Rating >= 90 THEN
        SET leaders_icon_value = 'Highly Rated';
    ELSEIF in_Leaders_Rating >= 70 THEN
        SET leaders_icon_value = 'Moderately Rated';
    ELSE
        SET leaders_icon_value = 'Low Rated';
    END IF;

    UPDATE CHICAGO_PUBLIC_SCHOOLS
    SET Leaders_Icon = leaders_icon_value
    WHERE School_ID = in_School_ID;
END //

DELIMITER ;
=======
select * from EMPLOYEES, JOBS where EMPLOYEES.JOB_ID = JOBS.JOB_IDENT;

select * from EMPLOYEES E, JOBS J where E.JOB_ID = J.JOB_IDENT;

select E.EMP_ID,E.F_NAME,E.L_NAME, J.JOB_TITLE from EMPLOYEES E, JOBS  J where E.JOB_ID = J.JOB_IDENT;


Sql Ecercice

Application_Table-----------
applicationdate,applicationid,applicationstatus,creditscore,requestedamount

loan_table----------------
loanid,loanamount,interestrate

aplicationid is the unique identifier


select year(applicationdate),Month(applicationdate),
count(applicationid) as total_application,
AVG(Case when creditscore<300 then null else creditscore end)
AVG(CASE WHEN applicationstatus='Approved' THEN 1 ELSE 0 END)
FROM application_table
where applicationdate>='2018'
GROUP BY year(applicationdate),Month(applicationdate)


Question 2


select count(loanid)/sum(case when applicationstatus='Approved' then 1 else 0 end),
avg(case when loanamount<requestedamount then 1 else 0 end)
from application_table A
inner join loan_table L
on A.applicationid=L.loanid
where A.applicationdate>='2018'
GROUP BY year(applicationdate),Month(applicationdate)
>>>>>>> 6e29ebf (Test.sql)
