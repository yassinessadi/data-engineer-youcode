drop database Github_db
create database Github_db
GO
use Github_db
-- Create Tables
GO
IF OBJECT_ID('Owners') 
IS Null
-- Owner Table
Create Table Owners(
	id int primary Key,
	Owner_Name varchar(150) Not NULL
)
GO
-- Technologies Table
IF OBJECT_ID('Technologies') 
IS Null
Create Table Technologies(
	id int Primary Key,
	Technology_name varchar(150) Not NULL
)
GO
-- Licenses Table
IF OBJECT_ID('Licenses') 
IS Null
Create Table Licenses(
	id int primary key,
	License_Name varchar(300) Not NULL
)
GO

-- Contributor Table
GO
IF OBJECT_ID('Contributors') 
IS Null
Create Table Contributors(
	id int Primary key,
	Contributor_Name varchar(150) Not NULL
)
GO
-- Repositories Table
GO
IF OBJECT_ID('Repositories') 
IS Null
Create Table Repositories (
	id int Primary Key,
	id_Owner int Foreign Key References Owners(id),
	id_License int Foreign Key References Licenses(id),
	Full_Name varchar(150) NOT NULL,
	Repo_URL varchar(max) NOT NULL,
	Forks int default 0,
	Date_Created varchar(200) Not NULL,
	Date_Updated varchar(200) Not NULL,
	Date_Pushed varchar(200) Not NULL,
	Repo_Description text,
	Open_issue_Count int default 0,
	Star_Count int default 0,
	id_Technology int Foreign Key References Technologies(id),
)
ALTER TABLE Repositories
ALTER COLUMN Repo_URL text;

ALTER TABLE Repositories
ALTER COLUMN Date_Created DATE;
ALTER TABLE Repositories
ALTER COLUMN Date_Updated DATE;
ALTER TABLE Repositories
ALTER COLUMN Date_Pushed DATE;

-- Commits Table

GO
IF OBJECT_ID('Commits') 
IS Null
Create Table Commits(
	id_Contributor int Foreign Key References Contributors(id),
	id_Repo int Foreign Key References Repositories(id),
	Commit_count int,
	Primary Key (id_Contributor,id_Repo)
)

-- Select Technologies  (Queries)

Select * from Technologies

-- Select Owners  (Queries)

Select * from Owners

-- Select Licenses  (Queries)

Select * from Licenses

-- Select Licenses  (Queries)

Select * from Licenses

-- Select Contributors  (Queries)

Select * from Contributors

-- Select Repositories  (Queries)

Select * from Repositories


--Select Contributor (Queries)
Select * from Contributors

--Select Contributor (Queries)
Select * from Commits


-- delete 
--DELETE FROM Repositories;
--DELETE FROM Contributors;
--DELETE FROM Technologies;
--DELETE FROM Licenses;
--DELETE FROM Owners;



-- Check data 

select id,id_Technology,Full_Name,(select Technology_name from Technologies where id=r.id_Technology) from Repositories as r

select * from Technologies

