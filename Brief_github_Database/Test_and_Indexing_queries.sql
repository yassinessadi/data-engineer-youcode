
--Owner Index
CREATE INDEX index_Owner
ON Owners (id);

--Technologies Index
CREATE INDEX index_Technologies
ON Technologies (id,Technology_name);

--Licenses Index
CREATE INDEX index_Licenses
ON Licenses (id,License_Name);


--Contributors Index
CREATE INDEX index_Contributors
ON Contributors (id,Contributor_Name);

--Contributors Index
CREATE INDEX index_Repositories
ON Repositories (id,Full_Name);

--Contributors Index
CREATE INDEX index_Commits
ON Commits (id_Contributor,id_Repo);



-- Drop Index
DROP INDEX index_Owner ON Owners;

--selection using index 
SELECT *
FROM Owners WITH(INDEX(index_Owner))
--
Go
SELECT *
FROM Technologies WITH(INDEX(index_Technologies))

-- Selection from Licenses
SELECT *
FROM Licenses WITH(INDEX(index_Licenses))

-- Selection from Contributors
SELECT *
FROM Contributors WITH(INDEX(index_Contributors))

-- Selection from Repositories
SELECT *
FROM Repositories WITH(INDEX(index_Repositories))

-- Selection from Repositories
SELECT *
FROM Commits WITH(INDEX(index_Commits))



-- SQL Test Using Some inner joir Queries

SELECT Repositories.id, Owners.id, Licenses.id,Technologies.id,Repositories.id_Technology,Repositories.id_Owner,Repositories.Full_Name,Owner_Name,License_Name,Technology_name
FROM (((Repositories
INNER JOIN Owners ON Repositories.id_Owner = Owners.id)
INNER JOIN Technologies ON Repositories.id_Technology = Technologies.id)
INNER JOIN Licenses ON Repositories.id_License = Licenses.id);