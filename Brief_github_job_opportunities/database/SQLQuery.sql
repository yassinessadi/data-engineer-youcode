DROP DATABASE job_opportunities

CREATE DATABASE job_opportunities
USE job_opportunities

-- job types table 1
CREATE TABLE jobTypes(
	ID INT PRIMARY KEY,
	Job_Name varchar(250)
)
--Campany Table 2
CREATE TABLE Companies(
	ID INT PRIMARY KEY,
	Company_Name VARCHAR(250)
 )
 -- LEVELS TABLE 3
 CREATE TABLE Levels(
	ID INT PRIMARY KEY,
	Level_Name VARCHAR(250)
)

-- COUNTRIES TABLE 4
CREATE TABLE Countries(
	ID INT PRIMARY KEY,
	Country_Name VARCHAR(250)
)

-- JOBS OFFER TABLE 5
CREATE TABLE Job_Offer(
	ID INT PRIMARY KEY,
	ID_JOB_TYPE INT FOREIGN KEY REFERENCES jobTypes(ID),
	ID_COMPANY INT FOREIGN KEY REFERENCES Companies(ID),
	ID_LEVELS INT FOREIGN KEY REFERENCES Levels(ID),
	ID_COUNTRY INT FOREIGN KEY REFERENCES Countries(ID),
	Title VARCHAR(250),
	Salary FLOAT,
	oFFER_Location VARCHAR(250)
)

-- TAGS TABLE 5
CREATE TABLE Tags(
	ID INT FOREIGN KEY REFERENCES Job_Offer(ID),
	Tag_Name VARCHAR(250),
	PRIMARY KEY (ID,Tag_Name)
)



---selection part

SELECT * FROM TAGS

select * from Countries

select * from jobTypes

select * from Companies

select * from Levels

select * from Job_Offer

---DROP FROM TABLES
DELETE FROM Countries
DELETE FROM jobTypes
DELETE FROM Companies
DELETE FROM Tags


---insert into some placeholders for validation (Tags):
insert into Tags values(1,'None')
insert into Tags values(2,'None')
insert into Tags values(3,'None')
insert into Tags values(1,'None')
