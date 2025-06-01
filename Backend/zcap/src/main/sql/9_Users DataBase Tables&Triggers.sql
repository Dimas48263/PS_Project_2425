
--/*** START: DROP TABLES

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE users
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'userProfileDetails' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE userProfileDetails
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'userProfiles' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE userProfiles  -- admin, reald only, tecnico, diretor
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'userDataProfileDetails' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE userDataProfileDetails
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'userDataProfiles' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE userDataProfiles -- nuts1 reg aut madeira, ou nuts3 Leiria
	END
GO
--/*** END: DROP TABLES

--/*** START: USERDATAPROFILES ***/

CREATE TABLE userDataProfiles (
	[userDataProfileId]		BIGINT		IDENTITY(1,1) PRIMARY KEY,
	[name]					NVARCHAR(255)	NOT NULL,
	[startDate]				DATE			NOT NULL,
	[endDate]				DATE			NULL,
	[createdAt]				DATETIME		NOT NULL,
	[updatedAt]				DATETIME		NOT NULL
)

--/*** END: USERDATAPROFILES ***/

--/*** START: USERDATAPROFILEDETAILS ***/

CREATE TABLE userDataProfileDetails (
	[userDataProfileId]		BIGINT NOT NULL		REFERENCES userDataProfiles(userDataProfileId),
	[treeRecordId]			BIGINT NOT NULL		REFERENCES tree(treeRecordId),
	PRIMARY KEY (userDataProfileId, treeRecordId)
)

--/*** END: USERDATAPROFILEDETAILS ***/

--/*** START: USERPROFILES ***/

CREATE TABLE userProfiles (
	[userProfileId]			BIGINT		IDENTITY(1,1) PRIMARY KEY,
	[name]					NVARCHAR(255)	NOT NULL,
	[startDate]				DATE			NOT NULL,
	[endDate]				DATE			NULL,
	[createdAt]				DATETIME		NOT NULL,
	[updatedAt]				DATETIME		NOT NULL
)

--/*** END: USERPROFILES ***/

--/*** START: USERPROFILEDETAILS ***/
/* NOT TO BE IMPLEMENTED YET, SHOULD REPRESENT ACCESS TO APP OPTIONS*/
CREATE TABLE userProfileDetails (
	[userProfileDetailId]	BIGINT		IDENTITY(1,1) PRIMARY KEY,
	[name]					NVARCHAR(255)	NOT NULL,
	[accessValue]			INT	NOT NULL,	-- represents a code inside app that gives access to that option
	[accessType]			INT	NOT NULL	-- different value to represent CRUD permissions
)

--/*** END: USERPROFILEDETAILS ***/


--/*** START: USERS ***/

CREATE TABLE users (
	[userId]				BIGINT			IDENTITY(1,1) PRIMARY KEY,
	[userName]				NVARCHAR(255)	NOT NULL,
	[name]					NVARCHAR(255)	NOT NULL,
	[password]				nvarchar(500)	NOT NULL,
	[userProfileId]			BIGINT			NOT NULL REFERENCES userProfiles(userProfileId),
	[userDataProfileId]		BIGINT			NOT NULL REFERENCES userDataProfiles(userDataProfileId),
	[startDate]				DATE			NOT NULL,
	[endDate]				DATE			NULL,
	[createdAt]				DATETIME		NOT NULL,
	[updatedAt]				DATETIME		NOT NULL
)

--/*** END: USERS ***/
GO
--/*** START TRIGGERS ***/

--/*** START USER DATA PROFILES INSERT ***/

--CREATE TRIGGER TR_Validate_User_Data_Profiles_Overlap_Insert
--ON userDataProfiles
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome
--    IF EXISTS (
--        SELECT 1 FROM userDataProfiles udp
--        JOIN inserted i ON udp.[name] = i.[name]
--        WHERE (i.startDate BETWEEN udp.startDate AND ISNULL(udp.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN udp.startDate AND ISNULL(udp.endDate, '9999-12-31'))
--           OR (udp.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um perfis de dados do utilizador com este nome em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO userDataProfiles ([name], startDate, endDate, [timestamp])
--    SELECT name, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

--/*** END USER DATA PROFILES OVERLAP INSERT ***/

--/*** START USER PROFILES INSERT ***/

--CREATE TRIGGER TR_Validate_User_Profiles_Overlap_Insert
--ON userProfiles
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome
--    IF EXISTS (
--        SELECT 1 FROM userProfiles up
--        JOIN inserted i ON up.[name] = i.[name]
--        WHERE (i.startDate BETWEEN up.startDate AND ISNULL(up.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN up.startDate AND ISNULL(up.endDate, '9999-12-31'))
--           OR (up.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um perfil de utilizador com este nome em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO userProfiles ([name], startDate, endDate, [createdAt], [updatedAt])
--    SELECT name, startDate, endDate, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

--/*** END USER PROFILES OVERLAP INSERT ***/

--/*** START USERS INSERT ***/

--CREATE TRIGGER TR_Validate_Users_Overlap_Insert
--ON users
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome
--    IF EXISTS (
--        SELECT 1 FROM users u
--        JOIN inserted i ON u.[userName] = i.[userName]
--        WHERE (i.startDate BETWEEN u.startDate AND ISNULL(u.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN u.startDate AND ISNULL(u.endDate, '9999-12-31'))
--           OR (u.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um utilizador com este nome de utilizador em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO users ([userName], [name], [password], userProfileId, userDataProfileId, startDate, endDate, [timestamp])
--    SELECT userName, name, password, userProfileId, userDataProfileId, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

--/*** END USERS OVERLAP INSERT ***/

/**** START USER DATA PROFILES TIMESTAMP UPDATE***/

--CREATE TRIGGER TR_Update_Timestamp_User_Data_Profiles
--ON userDataProfiles
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE userDataProfiles
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM userDataProfiles udp
--    INNER JOIN inserted i ON udp.userDataProfileId = i.userDataProfileId;
--END;
--GO

/**** END USER DATA PROFILES TIMESTAMP UPDATE***/

/**** START USER PROFILES TIMESTAMP UPDATE***/
-- commented, API should update not the DB
-- CREATE TRIGGER TR_Update_Timestamp_User_Profiles
-- ON userProfiles
-- AFTER UPDATE
-- AS
-- BEGIN
    -- SET NOCOUNT ON;

    -- UPDATE userProfiles
    -- SET updatedAt = CURRENT_TIMESTAMP
    -- FROM userProfiles up
    -- INNER JOIN inserted i ON up.userProfileId = i.userProfileId;
-- END;
-- GO

/**** END USER PROFILES TIMESTAMP UPDATE***/

/**** START USERS TIMESTAMP UPDATE***/

--CREATE TRIGGER TR_Update_Timestamp_Users
--ON users
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE users
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM users u
--    INNER JOIN inserted i ON u.userId = i.userId;
--END;
--GO

/**** END USERS TIMESTAMP UPDATE***/

--/*** END TRIGGERS ***/


