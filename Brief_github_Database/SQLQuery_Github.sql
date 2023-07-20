create database Github_db
GO
use Github_db
-- Create Tables
GO
-- Owner Table
Create Table Owners(
	id int primary Key,
	Owner_Name varchar(150) Not NULL
)
GO
-- Technologies Table
Create Table Technologies(
	id int Primary Key,
	Technology_name varchar(150) Not NULL
)
GO
-- Licenses Table
Create Table Licenses(
	id int primary key,
	License_Name varchar(300) Not NULL
)
GO

-- Contributor Table
Create Table Contributors(
	id int Primary key,
	Contributor_Name varchar(150) Not NULL
)
GO
-- Repositories Table
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

-- Commits Table

Create Table Commits(
	id_Contributor int Foreign Key References Contributors(id),
	id_Repo int Foreign Key References Repositories(id),
	Commit_count int,
	Primary Key (id_Contributor,id_Repo)
)