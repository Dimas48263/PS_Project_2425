
--/*** START: DROP TABLES

DROP TABLE incidentZcapPersons
DROP TABLE incidentZcaps
DROP TABLE incidents
DROP TABLE incidentTypes

GO
--/*** END: DROP TABLES

--/*** START: INCIDENTTYPES ***/

CREATE TABLE incidentTypes (
	[incidentTypeId]		BIGINT			IDENTITY(1,1) PRIMARY KEY,
	[name]					NVARCHAR(255)	NOT NULL,
	[startDate]				DATE			NOT NULL,
    [endDate]				DATE			NULL,
    [createdAt]				DATETIME		NOT NULL,
    [updatedAt]				DATETIME		NOT NULL
)

--/*** END: INCIDENTTYPES ***/

--/*** START: INCIDENTS ***/

CREATE TABLE incidents (
	[incidentId]			BIGINT		IDENTITY(1,1) PRIMARY KEY,
	[incidentTypeId]		BIGINT		NOT NULL REFERENCES incidentTypes(incidentTypeId),
	[startDate]				DATE		NOT NULL,
    [endDate]				DATE		NULL,
    [createdAt]				DATETIME	NOT NULL,
    [updatedAt]				DATETIME	NOT NULL
)

--/*** END: INCIDENTS ***/


--/*** START: INCIDENTZCAPS ***/
CREATE TABLE incidentZcaps(
	[incidentZcapId]		BIGINT				IDENTITY(1,1) PRIMARY KEY,
	[incidentId]			BIGINT				NOT NULL REFERENCES incidents(incidentId),
	[zcapId]				BIGINT				NOT NULL REFERENCES zcaps(zcapId),
	[entityId]				BIGINT				NOT NULL REFERENCES entities(entityId),
	[startDate]				DATE				NOT NULL,
    [endDate]				DATE				NULL,
    [createdAt]				DATETIME			NOT NULL,
    [updatedAt]				DATETIME			NOT NULL
)
--/*** END: INCIDENTZCAPS ***/

--/*** START: INCIDENTPERSONS ***/

CREATE TABLE incidentZcapPersons (
	[incidentPersonId]		BIGINT		IDENTITY(1,1) PRIMARY KEY,
	[incidentZcapId]		BIGINT		REFERENCES incidentZcaps(incidentZcapId),
	[personId]				BIGINT		REFERENCES persons(personId),
	[startDate]				DATE		NOT NULL,
    [endDate]				DATE		NULL,
    [createdAt]				DATETIME	NOT NULL,
    [updatedAt]				DATETIME	NOT NULL
)

--/*** END: INCIDENTPERSONS ***/

GO
--/*** END: TABLES ***/



--/**** START TRIGGERS ***/
--CREATE TRIGGER TR_Validate_Country_Overlap_Insert
--ON countries
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica sobreposição de nome
--    IF EXISTS (
--        SELECT 1 FROM countries c
--        JOIN inserted i ON c.[name] = i.[name]
--        WHERE (i.startDate BETWEEN c.startDate AND ISNULL(c.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN c.startDate AND ISNULL(c.endDate, '9999-12-31'))
--           OR (c.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um país com este nome em um período sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END

--    -- Verifica sobreposição de isoCodeA2
--    IF EXISTS (
--        SELECT 1 FROM countries c
--        JOIN inserted i ON c.isoCodeA2 = i.isoCodeA2
--        WHERE (i.startDate BETWEEN c.startDate AND ISNULL(c.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN c.startDate AND ISNULL(c.endDate, '9999-12-31'))
--           OR (c.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um país com este código ISO-3166-1 alpha-2 em um período sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END

--    -- Verifica sobreposição de isoCodeA3
--    IF EXISTS (
--        SELECT 1 FROM countries c
--        JOIN inserted i ON c.isoCodeA3 = i.isoCodeA3
--        WHERE (i.startDate BETWEEN c.startDate AND ISNULL(c.endDate, '9999-12-31'))
--           OR (i.endDate BETWEEN c.startDate AND ISNULL(c.endDate, '9999-12-31'))
--           OR (c.startDate BETWEEN i.startDate AND ISNULL(i.endDate, '9999-12-31'))
--    )
--    BEGIN
--        RAISERROR('Já existe um país com este código ISO-3166-1 alpha-3 em um período sobreposto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END

--    -- Se não houver sobreposição, insere normalmente
--    INSERT INTO countries ([name], isoCodeA2, isoCodeA3, startDate, endDate, [timestamp])
--    SELECT name, isoCodeA2, isoCodeA3, startDate, endDate, CURRENT_TIMESTAMP FROM inserted;
--END;
--GO

--CREATE TRIGGER TR_Update_Timestamp
--ON countries
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    UPDATE countries
--    SET timeStamp = CURRENT_TIMESTAMP
--    FROM countries c
--    INNER JOIN inserted i ON c.countryId = i.countryId;
--END;
--GO
--/**** END TRIGGERS ***/

--/*** TODO: CREATE TRIGGERS FOR UPDATES... and UNIQUES??? */


