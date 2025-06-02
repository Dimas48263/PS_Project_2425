
--/*** START: DROP TABLES
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'incidentZcapPersons' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE incidentZcapPersons
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'incidentZcaps' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE incidentZcaps
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'incidents' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE incidents
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'incidentTypes' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE incidentTypes
	END
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

