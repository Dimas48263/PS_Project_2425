
--/*** START: DROP TABLES
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'relation' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE relation
	END
GO

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'relationType' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE relationType
	END
GO

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'personSupportNeeded' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE personSupportNeeded
	END
GO

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'supportNeeded' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE supportNeeded
	END
GO

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'personSpecialNeeds' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE personSpecialNeeds
	END
GO

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'specialNeeds' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE specialNeeds
	END
GO

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'persons' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE persons
	END
GO

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'departureDestination' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE departureDestination
	END
GO
--/*** END: DROP TABLES

--/*** START TABLES **********/

--/*** START: PERSON DEPENDENCIES (LIST OF DESTINATIONS) ***/
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'departureDestination' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE departureDestination(	-- outra ZCAP, casa de familiares, residencia
	[departureDestinationId]	BIGINT IDENTITY(1,1) PRIMARY KEY,
	[name]						NVARCHAR(255)	NOT NULL,
	[startDate]					DATE			NOT NULL,
	[endDate]					DATE			NULL,
	[createdAt]					DATETIME		NOT NULL,
    [updatedAt]					DATETIME		NOT NULL
)
	END
GO

--/*** END: PERSON DEPENDENCIES ***/

--/*** START: PERSON ***/
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'persons' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
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
	END
GO

--/*** END: PERSON ***/

--/*** START: LISTS OF NEEDS ***/
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'specialNeeds' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE specialNeeds(  -- gravidez, medicamentos, doença...
	[specialNeedId] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[name] 			NVARCHAR(255)	NOT NULL ,
	[startDate]		DATE			NOT NULL,
	[endDate]		DATE			NULL,
	[createdAt]     DATETIME		NOT NULL,
    [updatedAt]		DATETIME		NOT NULL
)
	END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'personSpecialNeeds' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
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
	END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'supportNeeded' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE supportNeeded( -- alojamento, comida, vestuario 
	[supportNeededId]   BIGINT IDENTITY(1,1) PRIMARY KEY,
	[name] 			    NVARCHAR(255)	NOT NULL,
	[startDate]			DATE			NOT NULL,
	[endDate]			DATE			NULL,
	[createdAt]			DATETIME		NOT NULL,
    [updatedAt]			DATETIME		NOT NULL
)
	END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'personSupportNeeded' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
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
	END
GO

--/*** END: LISTS OF NEEDS ***/

--/*** START: RELATIVES ***/

IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'relationType' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE relationType (		-- mae, pai, filho, irmao, conjuge...
    [relationTypeId] 	BIGINT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(50)					NOT NULL ,
	[startDate]			DATE			NOT NULL,
	[endDate]			DATE			NULL,
	[createdAt]			DATETIME		NOT NULL,
    [updatedAt]			DATETIME		NOT NULL
)
	END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'relation' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE relation (
    [relationId]		BIGINT IDENTITY(1,1) PRIMARY KEY,
    [personId1]			BIGINT NOT NULL REFERENCES persons(personId),
    [personId2]			BIGINT NOT NULL REFERENCES persons(personId),
    [relationTypeId]	BIGINT NOT NULL REFERENCES relationType(relationTypeId),
    --CONSTRAINT unique_relation UNIQUE (personId1, personId2, relationTypeId), 
	CONSTRAINT chk_no_self_relation CHECK (personId1 <> personId2)
)
	END
GO
--/*** END: RELATIVES ***/

/****** END TABLES *********/