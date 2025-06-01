
--/*** START: DROP TABLES

DROP TABLE zcapDetails
DROP TABLE zcapDetailTypes
DROP TABLE detailTypeCategories
DROP TABLE dataTypes
DROP TABLE zcaps
DROP TABLE entities
DROP TABLE entityTypes
DROP TABLE buildingTypes
GO
----/*** END: DROP TABLES


--/*** START: BUILDINGTYPES ***/

CREATE TABLE buildingTypes (
	[buildingTypeId]	BIGINT	IDENTITY(1,1) PRIMARY KEY,
	[name]				NVARCHAR(255)	NOT NULL,
    [startDate]			DATE NOT NULL,
    [endDate]			DATE NULL,
    [createdAt]			DATETIME NOT NULL,
    [updatedAt]			DATETIME NOT NULL
)
--/*** END: BUILDINGTYPES ***/

--/*** START: ENTITYTYPES ***/

CREATE TABLE entityTypes (
	[entityTypeId]		BIGINT	IDENTITY(1,1) PRIMARY KEY,
	[name]				NVARCHAR(255)	NOT NULL,
    [startDate]			DATE NOT NULL,
    [endDate]			DATE NULL,
    [createdAt]			DATETIME NOT NULL,
    [updatedAt]			DATETIME NOT NULL
)
--/*** END: ENTITYTYPES ***/

--/*** START: ENTITIES ***/

CREATE TABLE entities (
	[entityId]			BIGINT				IDENTITY(1,1) PRIMARY KEY,
	[name]				NVARCHAR(255)	NOT NULL,
	[entityTypeId]		BIGINT				NOT NULL REFERENCES entityTypes(entityTypeId),
	[email]				NVARCHAR(255)	NULL,
	[phone1]			NVARCHAR(100)	NOT NULL,
	[phone2]			NVARCHAR(100)	NULL,
    [startDate]			DATE NOT NULL,
    [endDate]			DATE NULL,
    [createdAt]			DATETIME NOT NULL,
    [updatedAt]			DATETIME NOT NULL
)
--/*** END: ENTITIES ***/

--/*** START: ZCAPS ***/

CREATE TABLE zcaps (
	[zcapId]			BIGINT				IDENTITY(1,1) PRIMARY KEY,
	[name]				NVARCHAR(255)	NOT NULL,
	[buildingTypeId]	BIGINT			NOT NULL REFERENCES buildingTypes(buildingTypeId),
	[address]			NVARCHAR(500)	NOT NULL,
	[treeRecordId]		BIGINT			NULL REFERENCES tree(treeRecordId),
	[latitude]			REAL			NULL,
	[longitude]			REAL			NULL,
	[entityId]			BIGINT			NOT NULL REFERENCES entities(entityId),
    [startDate]			DATE			NOT NULL,
    [endDate]			DATE			NULL,
    [createdAt]			DATETIME		NOT NULL,
    [updatedAt]			DATETIME		NOT NULL
)

--/*** END: ZCAPS ***/

--/*** START: DATATYPES ***/

CREATE TABLE dataTypes (
	[dataTypeId]	BIGINT IDENTITY(1,1) PRIMARY KEY,
	[name]			NVARCHAR(255)
)

--/*** END: DATATYPES ***/

--/*** START: DETAILTYPECATEGORIES ***/

CREATE TABLE detailTypeCategories (
	[detailTypeCategoryId]	BIGINT	IDENTITY(1,1) PRIMARY KEY,
	[name]					NVARCHAR(255)	NOT NULL,
    [startDate]				DATE NOT NULL,
    [endDate]				DATE NULL,
    [createdAt]				DATETIME NOT NULL,
    [updatedAt]				DATETIME NOT NULL
)

--/*** END: DETAILTYPECATEGORIES ***/

--/*** START: ZCAPDETAILTYPES ***/

CREATE TABLE zcapDetailTypes (
	[zcapDetailTypeId]		BIGINT				IDENTITY(1,1) PRIMARY KEY,
	[name]					NVARCHAR(255)	NOT NULL,
	[detailTypeCategoryId]	BIGINT			NOT NULL REFERENCES detailTypeCategories(detailTypeCategoryId),
	[dataTypeId]			BIGINT				NOT NULL REFERENCES dataTypes(dataTypeId),
	[isMandatory]			BIT				NOT NULL,
    [startDate]				DATE NOT NULL,
    [endDate]				DATE NULL,
    [createdAt]				DATETIME NOT NULL,
    [updatedAt]				DATETIME NOT NULL
)

--/*** END: ZCAPDETAILTYPES ***/

--/*** START: ZCAPDETAILS ***/

CREATE TABLE zcapDetails (
	[zcapDetailId]		BIGINT				IDENTITY(1,1) PRIMARY KEY,
	[zcapId]			BIGINT				NOT NULL REFERENCES zcaps(zcapId),
	[zcapDetailTypeId]	BIGINT				NOT NULL REFERENCES zcapDetailTypes(zcapDetailTypeId),
	[value]				NVARCHAR(MAX)	NOT NULL,
    [startDate]			DATE NOT NULL,
    [endDate]			DATE NULL,
    [createdAt]			DATETIME NOT NULL,
    [updatedAt]			DATETIME NOT NULL)

--/*** END: ZCAPDETAILS ***/
GO
--/*** START TRIGGERS ***/


----/*** START BUILDING TYPES OVERLAP INSERT ***/

--CREATE TRIGGER TR_Validate_Building_Types_Overlap_Insert
--ON buildingTypes
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome
--    IF EXISTS (
--        SELECT 1 FROM buildingTypes bt
--        JOIN inserted i ON bt.[name] = i.[name]
--        WHERE (i.startDate BETWEEN bt.startDate AND ISNULL(bt.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN bt.startDate AND ISNULL(bt.endDate, '9999-12-31'))
--           OR (bt.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um tipo de edificio com este nome em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO buildingTypes ([name], startDate, endDate, [timestamp])
--    SELECT name, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

----/*** END BUILDING TYPES OVERLAP INSERT ***/

----/*** START ENTITY TYPES OVERLAP INSERT ***/

--CREATE TRIGGER TR_Validate_Entity_Types_Overlap_Insert
--ON entityTypes
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome
--    IF EXISTS (
--        SELECT 1 FROM entityTypes et
--        JOIN inserted i ON et.[name] = i.[name]
--        WHERE (i.startDate BETWEEN et.startDate AND ISNULL(et.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN et.startDate AND ISNULL(et.endDate, '9999-12-31'))
--           OR (et.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um tipo de entidade com este nome em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO entityTypes ([name], startDate, endDate, [timestamp])
--    SELECT name, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

----/*** END ENTITY TYPES OVERLAP INSERT ***/

----/*** START ENTITY OVERLAP INSERT ***/

--CREATE TRIGGER TR_Validate_Entities_Overlap_Insert
--ON entities
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome e entityTypeId
--    IF EXISTS (
--        SELECT 1 FROM entities e
--        JOIN inserted i ON e.[name] = i.[name] AND e.entityTypeId = i.entityTypeId
--        WHERE (i.startDate BETWEEN e.startDate AND ISNULL(e.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN e.startDate AND ISNULL(e.endDate, '9999-12-31'))
--           OR (e.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe uma entidade com este nome em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO entities ([name], entityTypeId, email, phone1, phone2, startDate, endDate, [timestamp])
--    SELECT name, entityTypeId, email, phone1, phone2, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

----/*** END ENTITY OVERLAP INSERT ***/

----/*** START ZCAP OVERLAP INSERT ***/

--CREATE TRIGGER TR_Validate_ZCAPS_Overlap_Insert
--ON zcaps
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome e buildingTypeId
--    IF EXISTS (
--        SELECT 1 FROM zcaps z
--        JOIN inserted i ON z.[name] = i.[name] AND z.buildingTypeId = i.buildingTypeId
--        WHERE (i.startDate BETWEEN z.startDate AND ISNULL(z.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN z.startDate AND ISNULL(z.endDate, '9999-12-31'))
--           OR (z.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe uma zcap com este nome em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO zcaps ([name], buildingTypeId, address, postalCodeId, latitude, longitude, entityId, startDate, endDate, [timestamp])
--    SELECT name, buildingTypeId, address, postalCodeId, latitude, longitude, entityId, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

----/*** END ZCAP OVERLAP INSERT ***/

----/*** START DETAIL TYPE CATEGORIES OVERLAP INSERT ***/

--CREATE TRIGGER TR_Validate_Detail_Type_Category_Overlap_Insert
--ON detailTypeCategories
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome
--    IF EXISTS (
--        SELECT 1 FROM detailTypeCategories dtc
--        JOIN inserted i ON dtc.[name] = i.[name] 
--        WHERE (i.startDate BETWEEN dtc.startDate AND ISNULL(dtc.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN dtc.startDate AND ISNULL(dtc.endDate, '9999-12-31'))
--           OR (dtc.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe uma categoria do tipo de detalhe com este nome em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO detailTypeCategories ([name], startDate, endDate, [timestamp])
--    SELECT name, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

----/*** END DETAIL TYPE CATEGORIES OVERLAP INSERT ***/

----/*** START ZCAP DETAIL TYPES OVERLAP INSERT ***/

--CREATE TRIGGER TR_Validate_ZCAP_Detail_Type_Overlap_Insert
--ON zcapDetailTypes
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome e detailTypeCategoryId
--    IF EXISTS (
--        SELECT 1 FROM zcapDetailTypes zdt
--        JOIN inserted i ON zdt.[name] = i.[name] AND zdt.detailTypeCategoryId = i.detailTypeCategoryId
--        WHERE (i.startDate BETWEEN zdt.startDate AND ISNULL(zdt.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN zdt.startDate AND ISNULL(zdt.endDate, '9999-12-31'))
--           OR (zdt.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um tipo de detalhe da zcap com este nome e categoria em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, startDate, endDate, [timestamp])
--    SELECT name, detailTypeCategoryId, dataTypeId, isMandatory, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

----/*** END ZCAP DETAIL TYPES OVERLAP INSERT ***/

----/*** START ZCAP DETAILS OVERLAP INSERT ***/

--CREATE TRIGGER TR_Validate_ZCAP_Details_Overlap_Insert
--ON zcapDetails
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição zcapId e zcapDetailTypeId
--    IF EXISTS (
--        SELECT 1 FROM zcapDetails zd
--        JOIN inserted i ON zd.zcapId = i.zcapId AND zd.zcapDetailTypeId = i.zcapDetailTypeId
--        WHERE (i.startDate BETWEEN zd.startDate AND ISNULL(zd.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN zd.startDate AND ISNULL(zd.endDate, '9999-12-31'))
--           OR (zd.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um detalhe da zcap em um periodo sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END
--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO zcapDetails (zcapId, zcapDetailTypeId, [value], startDate, endDate, [timestamp])
--    SELECT zcapId, zcapDetailTypeId, value, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

----/*** END ZCAP DETAILS OVERLAP INSERT ***/

--/**** START TIMESTAMP UPDATE TRIGGERS ***/

--/**** START BUILDING TYPES ***/

--CREATE TRIGGER TR_Update_Timestamp_Building_Type
--ON buildingTypes
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE buildingTypes
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM buildingTypes bt
--    INNER JOIN inserted i ON bt.buildingTypeId = i.buildingTypeId;
--END;
--GO

--/**** END BUILDING TYPES ***/

--/**** START ENTITY TYPES ***/

--CREATE TRIGGER TR_Update_Timestamp_Entity_Types
--ON entityTypes
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE entityTypes
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM entityTypes et
--    INNER JOIN inserted i ON et.entityTypeId = i.entityTypeId;
--END;
--GO

--/**** END ENTITY TYPES ***/

--/**** START ENTITIES ***/

--CREATE TRIGGER TR_Update_Timestamp_Entities
--ON entities
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE entities
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM entities e
--    INNER JOIN inserted i ON e.entityId = i.entityId;
--END;
--GO

--/**** END ENTITIES ***/

--/**** START ZCAPS ***/

--CREATE TRIGGER TR_Update_Timestamp_ZCAPS
--ON zcaps
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE zcaps
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM zcaps z
--    INNER JOIN inserted i ON z.zcapId = i.zcapId;
--END;
--GO

--/**** END ZCAPS ***/

--/**** START DETAIL TYPE CATEGORIES ***/

--CREATE TRIGGER TR_Update_Timestamp_Detail_Type_Catergories
--ON detailTypeCategories
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE detailTypeCategories
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM detailTypeCategories dtc
--    INNER JOIN inserted i ON dtc.detailTypeCategoryId = i.detailTypeCategoryId;
--END;
--GO

--/**** END DETAIL TYPE CATEGORIES ***/

--/**** START ZCAP DETAIL TYPES ***/

--CREATE TRIGGER TR_Update_Timestamp_ZCAP_Detail_Types
--ON zcapDetailTypes
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE zcapDetailTypes
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM zcapDetailTypes zdt
--    INNER JOIN inserted i ON zdt.zcapDetailTypeId = i.zcapDetailTypeId;
--END;
--GO

--/**** END ZCAP DETAIL TYPES ***/

--/**** START ZCAP DETAILS ***/

--CREATE TRIGGER TR_Update_Timestamp_ZCAP_Details
--ON zcapDetails
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE zcapDetails
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM zcapDetails zd
--    INNER JOIN inserted i ON zd.zcapDetailId = i.zcapDetailId;
--END;
--GO

--/**** END ZCAP DETAILS ***/

--/**** END TIMESTAMP UPDATE TRIGGERS ***/

--/**** END TRIGGERS ***/