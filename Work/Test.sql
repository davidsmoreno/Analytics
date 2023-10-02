

select * from instructor

/* Tenemos las columnas ins_id,lastname,firstname,city,country\*
*/

insert into instructor(ins_id,lastname,firstname,city,country)
values(4,'Sagha','Sandip','Edomnton','Ca')


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