/* Create Star Schema */

CREATE TABLE departments (	
	depcode INT PRIMARY KEY, 
	depname VARCHAR(30)
);


CREATE TABLE copies (	
	copyno CHAR(8) PRIMARY KEY, 
	copyloc CHAR(3) 
); 


CREATE TABLE borrowers (	
	bid INT PRIMARY KEY, 
	sex CHAR(1),  
);


CREATE TABLE bibrecs (
	bibno INT PRIMARY KEY, 
	material VARCHAR(30) 
); 


CREATE TABLE dateinfo (	
	loandate DATE PRIMARY KEY,
	l_year INT,
	l_month INT,
	l_dayofmonth INT,
	l_week INT,
	l_dayofyear INT,
	l_dayofweek INT
);


CREATE TABLE loans (
	lid INT,
	depcode INT,
	copyno CHAR(8),
	bid INT,
	bibno INT,
	loandate DATE,

	PRIMARY KEY (lid,depcode,copyno,bid,bibno,loandate),
	FOREIGN KEY (depcode) REFERENCES departments(depcode),
	FOREIGN KEY (copyno) REFERENCES copies(copyno),
	FOREIGN KEY (bid) REFERENCES borrowers(bid),
	FOREIGN KEY (bibno) REFERENCES bibrecs(bibno),
	FOREIGN KEY (loandate) REFERENCES dateinfo(loandate)
);



/* Fill Star Schema */

INSERT INTO departments(depcode, depname) SELECT depcode, depname FROM LIBRARY.dbo.departments;

INSERT INTO copies(copyno, copyloc) SELECT copyno, copyloc FROM LIBRARY.dbo.copies;

INSERT INTO borrowers(bid, sex) SELECT bid, sex FROM LIBRARY.dbo.borrowers;

INSERT INTO bibrecs(bibno, material) SELECT bibno, material FROM LIBRARY.dbo.bibrecs;

SET DATEFIRST 1;
INSERT INTO dateinfo
SELECT DISTINCT loandate, DATEPART(YEAR, loandate), DATEPART(MONTH, loandate),
							DATEPART(DAY,loandate), DATEPART(WEEK,loandate),
							DATEPART(DAYOFYEAR,loandate),DATEPART(dw,loandate)
FROM LIBRARY.dbo.loanstats;

INSERT INTO loans(lid, depcode, copyno, bid, bibno, loandate) 
SELECT LIBRARY.dbo.loanstats.lid, 
		LIBRARY.dbo.departments.depcode, 
		LIBRARY.dbo.loanstats.copyno, 
		LIBRARY.dbo.borrowers.bid, 
		LIBRARY.dbo.bibrecs.bibno, 
		LIBRARY.dbo.loanstats.loandate
FROM LIBRARY.dbo.loanstats, 
		LIBRARY.dbo.departments, 
		LIBRARY.dbo.copies, 
		LIBRARY.dbo.borrowers, 
		LIBRARY.dbo.bibrecs
WHERE LIBRARY.dbo.loanstats.bid = LIBRARY.dbo.borrowers.bid AND 
		LIBRARY.dbo.departments.depcode = LIBRARY.dbo.borrowers.depcode AND 
		LIBRARY.dbo.loanstats.copyno = LIBRARY.dbo.copies.copyno AND 
		LIBRARY.dbo.bibrecs.bibno = LIBRARY.dbo.copies.bibno;



/* 2.1 */
SELECT l_year, departments.depcode, COUNT(lid) FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN departments
ON departments.depcode = loans.depcode
GROUP BY l_year, departments.depcode
ORDER BY l_year, departments.depcode


/* 2.2 */
SELECT copies.copyno, bibrecs.material, COUNT(lid) FROM loans
JOIN copies
ON copies.copyno = loans.copyno
JOIN bibrecs
ON bibrecs.bibno = loans.bibno
GROUP BY copies.copyno, bibrecs.material
ORDER BY bibrecs.material


/* 2.3 */
SELECT l_month, borrowers.sex, COUNT(lid) FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN borrowers
ON borrowers.bid = loans.bid
WHERE l_year = '2000'
GROUP BY l_month, borrowers.sex
ORDER BY l_month, borrowers.sex


/* 2.4 */
SELECT l_year, l_month, COUNT(lid) FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
GROUP BY l_year, l_month
HAVING COUNT(lid) > 800
ORDER BY l_year, l_month


/* 2.5 */
SELECT l_year, department, sex, COUNT(lid) AS total_loans, year_loans, year_depcode_loans, year_depcode_sex_loans FROM loans,
(SELECT dateinfo.l_year AS l_year, departments.depcode AS department, borrowers.sex AS sex, year_loans, year_depcode_loans, COUNT(loans.lid) AS year_depcode_sex_loans FROM loans
JOIN departments
ON departments.depcode = loans.depcode
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN borrowers
ON borrowers.bid = loans.bid

RIGHT JOIN (SELECT COUNT(lid) as year_loans, l_year FROM loans
				JOIN dateinfo
				ON dateinfo.loandate = loans.loandate
			GROUP BY l_year) AS YEARLY
ON YEARLY.l_year = dateinfo.l_year

RIGHT JOIN (SELECT COUNT(lid) as year_depcode_loans, departments.depcode, l_year FROM loans
				JOIN dateinfo
				ON dateinfo.loandate = loans.loandate
				JOIN departments
				ON departments.depcode = loans.depcode
			GROUP BY l_year, departments.depcode) AS YEARLY_DEPARTMENT
ON YEARLY_DEPARTMENT.depcode = departments.depcode AND YEARLY_DEPARTMENT.l_year = dateinfo.l_year
GROUP BY dateinfo.l_year, departments.depcode, borrowers.sex, year_loans, year_depcode_loans) AS YEARLY_DEPARTMENT_SEX

GROUP BY year_loans, year_depcode_loans, department, sex, l_year, year_depcode_sex_loans
ORDER BY l_year, department, sex


SELECT dateinfo.l_year AS l_year, departments.depcode AS department, borrowers.sex AS sex, COUNT(lid) AS loans_num FROM loans
JOIN departments
ON departments.depcode = loans.depcode
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN borrowers
ON borrowers.bid = loans.bid
GROUP BY ROLLUP (dateinfo.l_year, departments.depcode, borrowers.sex)
ORDER BY dateinfo.l_year
		


/* 2.6 */
SELECT departments.depcode AS depcode, COUNT(lid) AS total_loans INTO female_loans FROM loans
			JOIN departments
			ON departments.depcode = loans.depcode
			JOIN borrowers
			ON loans.bid = borrowers.bid
			WHERE borrowers.sex = 'F'
			GROUP BY departments.depcode


SELECT departments.depcode AS depcode, COUNT(lid) AS total_loans INTO male_loans FROM loans
			JOIN departments
			ON departments.depcode = loans.depcode
			JOIN borrowers
			ON loans.bid = borrowers.bid
			WHERE borrowers.sex = 'M'
			GROUP BY departments.depcode


SELECT female_loans.depcode, female_loans.total_loans FROM female_loans
JOIN male_loans
ON male_loans.depcode = female_loans.depcode
WHERE male_loans.total_loans < female_loans.total_loans
GROUP BY female_loans.depcode, female_loans.total_loans
ORDER BY female_loans.depcode, female_loans.total_loans



/* 3.1 */
SELECT dateinfo.l_year, copies.copyloc, borrowers.sex, COUNT(lid)
FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN copies
ON copies.copyno = loans.copyno
JOIN borrowers
ON borrowers.bid = loans.bid
GROUP BY CUBE (dateinfo.l_year, copies.copyloc, borrowers.sex)



/* 3.2 */
SELECT dateinfo.l_year, copies.copyloc, borrowers.sex, COUNT(lid)
FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN copies
ON copies.copyno = loans.copyno
JOIN borrowers
ON borrowers.bid = loans.bid
GROUP BY dateinfo.l_year, copies.copyloc, borrowers.sex


SELECT dateinfo.l_year, copies.copyloc, COUNT(lid)
FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN copies
ON copies.copyno = loans.copyno
JOIN borrowers
ON borrowers.bid = loans.bid
GROUP BY dateinfo.l_year, copies.copyloc


SELECT dateinfo.l_year, borrowers.sex, COUNT(lid)
FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN copies
ON copies.copyno = loans.copyno
JOIN borrowers
ON borrowers.bid = loans.bid
GROUP BY dateinfo.l_year, borrowers.sex


SELECT copies.copyloc, borrowers.sex, COUNT(lid)
FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN copies
ON copies.copyno = loans.copyno
JOIN borrowers
ON borrowers.bid = loans.bid
GROUP BY copies.copyloc, borrowers.sex


SELECT dateinfo.l_year, COUNT(lid)
FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN copies
ON copies.copyno = loans.copyno
JOIN borrowers
ON borrowers.bid = loans.bid
GROUP BY dateinfo.l_year


SELECT copies.copyloc, COUNT(lid)
FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN copies
ON copies.copyno = loans.copyno
JOIN borrowers
ON borrowers.bid = loans.bid
GROUP BY copies.copyloc


SELECT borrowers.sex, COUNT(lid)
FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN copies
ON copies.copyno = loans.copyno
JOIN borrowers
ON borrowers.bid = loans.bid
GROUP BY borrowers.sex


SELECT COUNT(lid)
FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN copies
ON copies.copyno = loans.copyno
JOIN borrowers
ON borrowers.bid = loans.bid


SELECT dateinfo.l_year, copies.copyloc, borrowers.sex, COUNT(lid)
FROM loans
JOIN dateinfo
ON dateinfo.loandate = loans.loandate
JOIN copies
ON copies.copyno = loans.copyno
JOIN borrowers
ON borrowers.bid = loans.bid
GROUP BY 
	GROUPING SETS
	(
		(dateinfo.l_year, copies.copyloc, borrowers.sex),
		(dateinfo.l_year, copies.copyloc),
		(dateinfo.l_year, borrowers.sex),
		(copies.copyloc, borrowers.sex),
		(dateinfo.l_year),
		(copies.copyloc),
		(borrowers.sex),
		()
	)



/* 4.0 */

CREATE TABLE loans_for_cube (
	lid INT,
	copyno CHAR(8),
	bid INT,
	loandate DATE,

	PRIMARY KEY (lid, copyno, bid, loandate),
	FOREIGN KEY (copyno) REFERENCES copies(copyno),
	FOREIGN KEY (bid) REFERENCES borrowers(bid),
	FOREIGN KEY (loandate) REFERENCES dateinfo(loandate)
);


INSERT INTO loans_for_cube SELECT lid, copyno, bid, loandate FROM loans 


SELECT dateinfo.l_year, copies.copyloc, borrowers.sex, COUNT(lid)
FROM loans_for_cube
JOIN dateinfo
ON dateinfo.loandate = loans_for_cube.loandate
JOIN copies
ON copies.copyno = loans_for_cube.copyno
JOIN borrowers
ON borrowers.bid = loans_for_cube.bid
GROUP BY 
	GROUPING SETS
	(
		(dateinfo.l_year, copies.copyloc, borrowers.sex),
		(dateinfo.l_year, copies.copyloc),
		(dateinfo.l_year, borrowers.sex),
		(copies.copyloc, borrowers.sex),
		(dateinfo.l_year),
		(copies.copyloc),
		(borrowers.sex),
		()
	)
