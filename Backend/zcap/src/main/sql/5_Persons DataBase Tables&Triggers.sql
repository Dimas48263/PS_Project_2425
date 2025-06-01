
--/*** START: DROP TABLES

DROP TABLE relation
DROP TABLE relationType
DROP TABLE personSupportNeeded
DROP TABLE supportNeeded
DROP TABLE personSpecialNeeds
DROP TABLE specialNeeds
DROP TABLE persons
DROP TABLE departureDestination
--GO
--/*** END: DROP TABLES

--/*** START TABLES **********/

--/*** START: PERSON DEPENDENCIES (LIST OF DESTINATIONS) ***/

CREATE TABLE departureDestination(	-- outra ZCAP, casa de familiares, residencia
	[departureDestinationId]	BIGINT IDENTITY(1,1) PRIMARY KEY,
	[name]						NVARCHAR(255)	NOT NULL,
	[startDate]					DATE			NOT NULL,
	[endDate]					DATE			NULL,
	[createdAt]					DATETIME		NOT NULL,
    [updatedAt]					DATETIME		NOT NULL
)

--/*** END: PERSON DEPENDENCIES ***/

--/*** START: PERSON ***/

CREATE TABLE persons (
	[personId]					BIGINT 			IDENTITY(1,1) PRIMARY KEY,
	[name]						NVARCHAR(255)	NOT NULL,
	[age] 					    INT 			NOT NULL,
	[contact]  					NVARCHAR(255) 	NOT NULL,
	[countryCodeId]  			BIGINT 			NOT NULL REFERENCES treeRecordDetails(detailId),
	[placeOfResidence]  		BIGINT 			NOT NULL REFERENCES tree(treeRecordId),		
	[entryDatetime]				DATETIME 		NOT NULL,
	[departureDatetime]			DATETIME 		NULL,
	[birthDate]					DATE 			NULL,
	[nationalityId] 			BIGINT 			NULL REFERENCES treeRecordDetails(detailId),
	[address]					NVARCHAR(255)	NULL,
	[NISS]						INT 			NULL,
	[departureDestinationId] 	BIGINT 			NULL REFERENCES departureDestination(departureDestinationId),
	[destinationContact]		INT 			NULL,
	[createdAt]					DATETIME NOT NULL,
    [updatedAt]					DATETIME NOT NULL
)

--/*** END: PERSON ***/

--/*** START: LISTS OF NEEDS ***/

CREATE TABLE specialNeeds(  -- gravidez, medicamentos, doença...
	[specialNeedId] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[name] 			NVARCHAR(255)	NOT NULL ,
	[startDate]		DATE			NOT NULL,
	[endDate]		DATE			NULL,
	[createdAt]     DATETIME		NOT NULL,
    [updatedAt]		DATETIME		NOT NULL
)

CREATE TABLE personSpecialNeeds(	
	[personSpecialNeedId]	BIGINT IDENTITY(1,1) PRIMARY KEY,
	[personId]				BIGINT			NOT NULL REFERENCES persons(personId),
	[specialNeedId]			BIGINT			NOT NULL REFERENCES specialNeeds(specialNeedId),
	[description]			NVARCHAR(255)	NULL, -- caso de outro? descriçao:
	[startDate]				DATE			NOT NULL,
	[endDate]				DATE			NULL,
	[createdAt]				DATETIME		NOT NULL,
    [updatedAt]				DATETIME		NOT NULL
)

CREATE TABLE supportNeeded( -- alojamento, comida, vestuario 
	[supportNeededId]   BIGINT IDENTITY(1,1) PRIMARY KEY,
	[name] 			    NVARCHAR(255)	NOT NULL,
	[startDate]			DATE			NOT NULL,
	[endDate]			DATE			NULL,
	[createdAt]			DATETIME		NOT NULL,
    [updatedAt]			DATETIME		NOT NULL
)

CREATE TABLE personSupportNeeded(
	[personSupportNeededId]		BIGINT IDENTITY(1,1) PRIMARY KEY,
	[personId]					BIGINT NOT NULL REFERENCES persons(personId),
	[supportNeededId]			BIGINT NOT NULL REFERENCES supportNeeded(supportNeededId),
	[description]				NVARCHAR(255) NULL, -- caso de outro? descriçao:
	[startDate]					DATE			NOT NULL,
	[endDate]					DATE			NULL,
	[createdAt]					DATETIME NOT NULL,
    [updatedAt]					DATETIME NOT NULL
)

--/*** END: LISTS OF NEEDS ***/

--/*** START: RELATIVES ***/

CREATE TABLE relationType (		-- mae, pai, filho, irmao, conjuge...
    [relationTypeId] 	BIGINT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(50)					NOT NULL ,
	[startDate]			DATE			NOT NULL,
	[endDate]			DATE			NULL,
	[createdAt]			DATETIME		NOT NULL,
    [updatedAt]			DATETIME		NOT NULL
);

CREATE TABLE relation (
    [relationId]		BIGINT IDENTITY(1,1) PRIMARY KEY,
    [personId1]			BIGINT NOT NULL REFERENCES persons(personId),
    [personId2]			BIGINT NOT NULL REFERENCES persons(personId),
    [relationTypeId]	BIGINT NOT NULL REFERENCES relationType(relationTypeId),
    --CONSTRAINT unique_relation UNIQUE (personId1, personId2, relationTypeId), 
	CONSTRAINT chk_no_self_relation CHECK (personId1 <> personId2)
);
--/*** END: RELATIVES ***/

/****** END TABLES *********/
GO

/**** START TRIGGERS ***/

/**** START VALIDATIONS ***/

--CREATE TRIGGER TR_Validate_Departure_Destination_Overlap_Insert
--ON departureDestination
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome
--    IF EXISTS (
--        SELECT 1 FROM departureDestination d
--        JOIN inserted i ON d.[name] = i.[name]
--        WHERE (i.startDate BETWEEN d.startDate AND ISNULL(d.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN d.startDate AND ISNULL(d.endDate, '9999-12-31'))
--           OR (d.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um destino com este nome em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO departureDestination ([name], startDate, endDate, [timestamp])
--    SELECT name, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

--CREATE TRIGGER TR_Validate_Special_Needs_Overlap_Insert
--ON specialNeeds
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome
--    IF EXISTS (
--        SELECT 1 FROM specialNeeds s
--        JOIN inserted i ON s.[name] = i.[name]
--        WHERE (i.startDate BETWEEN s.startDate AND ISNULL(s.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN s.startDate AND ISNULL(s.endDate, '9999-12-31'))
--           OR (s.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe uma necessidade especial com este nome em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO specialNeeds ([name], startDate, endDate, [timestamp])
--    SELECT name, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

--CREATE TRIGGER TR_Validate_Person_SpecialNeeds_Insert
--ON personSpecialNeeds
--INSTEAD OF INSERT
--AS
--BEGIN
--    SET NOCOUNT ON;

--    -- Verifica se já existe um par (personId, specialNeedId) em um período sobreposto
--    IF EXISTS (
--        SELECT 1 
--        FROM personSpecialNeeds psn
--        JOIN inserted i ON psn.personId = i.personId AND psn.specialNeedId = i.specialNeedId
--        WHERE (i.startDate BETWEEN psn.startDate AND ISNULL(psn.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN psn.startDate AND ISNULL(psn.endDate, '9999-12-31'))
--           OR (psn.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um registro para esta pessoa com esta necessidade especial em um período sobreposto.', 16, 1);
--        RETURN;
--    END

--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO personSpecialNeeds (personId, specialNeedId, description, startDate, endDate, timestamp)
--    SELECT personId, specialNeedId, description, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

--CREATE TRIGGER TR_Validate_Support_Needed_Overlap_Insert
--ON supportNeeded
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome
--    IF EXISTS (
--        SELECT 1 FROM supportNeeded s
--        JOIN inserted i ON s.[name] = i.[name]
--        WHERE (i.startDate BETWEEN s.startDate AND ISNULL(s.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN s.startDate AND ISNULL(s.endDate, '9999-12-31'))
--           OR (s.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe uma necessidade com este nome em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO supportNeeded ([name], startDate, endDate, [timestamp])
--    SELECT name, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

--CREATE TRIGGER TR_Validate_Person_Support_Needed_Insert
--ON personSupportNeeded
--INSTEAD OF INSERT
--AS
--BEGIN
--    SET NOCOUNT ON;

--    -- Verifica se já existe um par (personId, supportNeededId) em um período sobreposto
--    IF EXISTS (
--        SELECT 1 
--        FROM personSupportNeeded psn
--        JOIN inserted i ON psn.personId = i.personId AND psn.supportNeededId = i.supportNeededId
--        WHERE (i.startDate BETWEEN psn.startDate AND ISNULL(psn.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN psn.startDate AND ISNULL(psn.endDate, '9999-12-31'))
--           OR (psn.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe a necessidade para esta pessoa em um período sobreposto.', 16, 1);
--        RETURN;
--    END

--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO personSupportNeeded (personId, supportNeededId, description, startDate, endDate, timestamp)
--    SELECT personId, supportNeededId, description, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO


--CREATE TRIGGER TR_Validate_Realtion_Type_Insert
--ON relationType
--INSTEAD OF INSERT
--AS
--BEGIN
--    SET NOCOUNT ON;

--    -- Verifica sobreposição de nome
--    IF EXISTS (
--        SELECT 1 
--        FROM relationType r
--        JOIN inserted i ON r.[name] = i.[name] 
--        WHERE (i.startDate BETWEEN r.startDate AND ISNULL(r.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN r.startDate AND ISNULL(r.endDate, '9999-12-31'))
--           OR (r.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe uma relaçao com este nome em um período sobreposto.', 16, 1);
--        RETURN;
--    END

--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO relationType  ([name], startDate, endDate, [timestamp])
--    SELECT name, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

--/**** END VALIDATIONS ***/


--/**** START TIMESTAMP UPDATE TRIGGERS ***/

--CREATE TRIGGER TR_Update_Timestamp_Departure_Destination
--ON departureDestination
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE departureDestination
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM departureDestination d
--    INNER JOIN inserted i ON d.departureDestinationId = i.departureDestinationId;
--END;
--GO

--CREATE TRIGGER TR_Update_Timestamp_Persons
--ON persons
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE persons
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM persons p
--    INNER JOIN inserted i ON p.personId = i.personId;
--END;
--GO

--CREATE TRIGGER TR_Update_Timestamp_Special_Needs
--ON specialNeeds
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE specialNeeds
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM specialNeeds s
--    INNER JOIN inserted i ON s.specialNeedId = i.specialNeedId;
--END;
--GO

--CREATE TRIGGER TR_Update_Timestamp_Person_Special_Needs
--ON personSpecialNeeds
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE personSpecialNeeds
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM personSpecialNeeds p
--    INNER JOIN inserted i ON p.personSpecialNeedId = i.personSpecialNeedId;
--END;
--GO

--CREATE TRIGGER TR_Update_Timestamp_Support_Nedded
--ON supportNeeded
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE supportNeeded
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM supportNeeded s
--    INNER JOIN inserted i ON s.supportNeededId = i.supportNeededId;
--END;
--GO

--CREATE TRIGGER TR_Update_Timestamp_Person_Support_Nedded
--ON personSupportNeeded
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE personSupportNeeded
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM personSupportNeeded p
--    INNER JOIN inserted i ON p.personSupportNeededId = i.personSupportNeededId;
--END;
--GO

--CREATE TRIGGER TR_Update_Timestamp_Relation_Type
--ON relationType
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE relationType
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM relationType r
--    INNER JOIN inserted i ON r.relationTypeId = i.relationTypeId;
--END;
--GO

/**** END TIMESTAMP UPDATE TRIGGERS ***/

/**** END TRIGGERS ***/
