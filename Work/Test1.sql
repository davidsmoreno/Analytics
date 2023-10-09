

Question 1

select YEAR(applicationdate) as Year,MONTH(applicationdate) as Month,
COUNT(*) as T_Aplications,
AVG(CASE WHEN applicationdate<300 THEN NULL else CREDITSCORE END)  AS AVGCREDIT,
(SUM(CASE WHEN APLICATIONSTATUS='APPROVED' THEN 1 ELSE 0 END)/COUNT(*))*100 AS A_RATING
FROM APLICATION_TABLE
WHERE
applicationdate>='2018-01-01'
GROUP BY  YEAR(applicationdate) as Year,MONTH(applicationdate)
ORDER BY  YEAR(applicationdate) as Year,MONTH(applicationdate)


Question 2


SELECT YEAR(A.applicationdate) AS Year,MONTH(A.applicationdate) AS Month,
(COUNT(DISTINCT A.applicationid) / (SELECT COUNT(*) FROM application_table WHERE applicationdate >= '2018-01-01')) * 100 AS Rate,
(SUM(CASE WHEN A.requestedamount > B.loanamount THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS LoanRate
FROM
application_table A
INNER JOIN
loan_table B ON A.applicationid = B.loanid
WHERE
A.applicationstatus = 'Approved'
AND A.applicationdate >= '2018-01-01'
GROUP BY
Year,
Month;










