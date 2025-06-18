
USE [master]
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'ZCAPNET')
BEGIN
    CREATE DATABASE ZCAPNET
    PRINT 'Base de dados ZCAPNET criada com sucesso.'
END
ELSE
BEGIN
    PRINT 'A base de dados ZCAPNET já existe.'
END
GO

USE ZCAPNET
GO

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
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'zcapDetails' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE zcapDetails
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'zcapDetailTypes' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE zcapDetailTypes
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'detailTypeCategories' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE detailTypeCategories
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'dataTypes' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE dataTypes
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'zcaps' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE zcaps
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'entities' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE entities
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'entityTypes' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE entityTypes
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'buildingTypes' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE buildingTypes
	END
GO

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'treeLevelDetailType' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE treeLevelDetailType
	END
GO

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'treeRecordDetails' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE treeRecordDetails
	END
GO

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'treeRecordDetailTypes' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE treeRecordDetailTypes
	END
GO

IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tree' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE tree
	END
GO
IF EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'treeLevels' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
		DROP TABLE treeLevels
	END
GO

-- Tabela de níveis de divisão administrativa
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'treeLevels' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE treeLevels (
    [treeLevelId]	BIGINT IDENTITY(1,1) PRIMARY KEY,
    [levelId]		INT,
    [name]			NVARCHAR(255) NOT NULL,											-- Nome do nível (País, Distrito, Concelho, etc.)
    [description]	NVARCHAR(255) NULL,												-- Descrição opcional
    [startDate]		DATE NOT NULL,
    [endDate]		DATE NULL,
    [createdAt]      DATETIME NOT NULL,
    [lastUpdatedAt]		DATETIME NOT NULL
)
	END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tree' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
-- Tabela genérica para armazenar divisoes administrativas
CREATE TABLE tree (
    treeRecordId	BIGINT IDENTITY(1,1) PRIMARY KEY,
    [name]			NVARCHAR(255) NOT NULL,											-- Nome da região
    treeLevelId		BIGINT NOT NULL REFERENCES treeLevels(treeLevelId),				-- Nível administrativo
    parentId		BIGINT NULL REFERENCES tree(treeRecordId),						-- Região superior (NULL para País)
    startDate		DATE NOT NULL,
    endDate			DATE NULL,
    [createdAt]      DATETIME NOT NULL,
    [lastUpdatedAt]		DATETIME NOT NULL
)
	END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'treeRecordDetailTypes' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
-- NOVO: Tabela de tipos de detalhe da arvore
CREATE TABLE treeRecordDetailTypes (
    [detailTypeId]	BIGINT IDENTITY(1,1) PRIMARY KEY,
    [name]			NVARCHAR(255) NOT NULL,											-- Nome do tipo de detalhe (ex: População, Área, PIB, etc.)
    [unit]			NVARCHAR(50)  NULL,												-- Unidade de medida (ex: km², habitantes, €)
    [startDate]		DATE NOT NULL,
    [endDate]		DATE NULL,
    [createdAt]      DATETIME NOT NULL,
    [lastUpdatedAt]		DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
)
	END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'treeRecordDetails' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
-- NOVO: Tabela para armazenar os detalhes de cada item da arvore
CREATE TABLE treeRecordDetails (
    [detailId]		BIGINT IDENTITY(1,1) PRIMARY KEY,
    [treeRecordId]	BIGINT NOT NULL REFERENCES tree(treeRecordId),					-- Qual região este detalhe pertence
    [detailTypeId]	BIGINT NOT NULL REFERENCES treeRecordDetailTypes(detailTypeId),	-- Tipo de detalhe
    [valueCol]			NVARCHAR(255) NOT NULL,											-- O valor do detalhe (pode ser número, texto, etc.)
    [startDate]		DATE NOT NULL,
    [endDate]		DATE NULL,
    [createdAt]      DATETIME NOT NULL,
    [lastUpdatedAt]		DATETIME NOT NULL
)
	END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'treeLevelDetailType' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
-- NOVO: Tabela para armazenar os tipos de detalhes necessarios para cada nivel hierárquico
CREATE TABLE treeLevelDetailType (
    [treeLevelDetailTypeId]		BIGINT IDENTITY(1,1) PRIMARY KEY,
    [treeLevelId]	BIGINT NOT NULL REFERENCES treeLevels(treeLevelId),
    [detailTypeId]	BIGINT NOT NULL REFERENCES treeRecordDetailTypes(detailTypeId),	-- Tipo de detalhe
    [startDate]		DATE NOT NULL,
    [endDate]		DATE NULL,
    [createdAt]      DATETIME NOT NULL,
    [lastUpdatedAt]		DATETIME NOT NULL
)
	END
GO


IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'buildingTypes' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE buildingTypes (
	[buildingTypeId]	BIGINT	IDENTITY(1,1) PRIMARY KEY,
	[name]				NVARCHAR(255)	NOT NULL,
    [startDate]			DATE NOT NULL,
    [endDate]			DATE NULL,
    [createdAt]			DATETIME NOT NULL,
    [lastUpdatedAt]			DATETIME NOT NULL
)
	END
GO
--/*** END: BUILDINGTYPES ***/

--/*** START: ENTITYTYPES ***/
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'entityTypes' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE entityTypes (
	[entityTypeId]		BIGINT	IDENTITY(1,1) PRIMARY KEY,
	[name]				NVARCHAR(255)	NOT NULL,
    [startDate]			DATE NOT NULL,
    [endDate]			DATE NULL,
    [createdAt]			DATETIME NOT NULL,
    [lastUpdatedAt]			DATETIME NOT NULL
)
	END
GO
--/*** END: ENTITYTYPES ***/

--/*** START: ENTITIES ***/
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'entities' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
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
    [lastUpdatedAt]			DATETIME NOT NULL
)
	END
GO
--/*** END: ENTITIES ***/

--/*** START: ZCAPS ***/
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'zcaps' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
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
    [lastUpdatedAt]			DATETIME		NOT NULL
)
	END
GO
--/*** END: ZCAPS ***/

--/*** START: DATATYPES ***/
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'dataTypes' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE dataTypes (
	[dataTypeId]	BIGINT IDENTITY(1,1) PRIMARY KEY,
	[name]			NVARCHAR(255)
)
	END
GO
--/*** END: DATATYPES ***/

--/*** START: DETAILTYPECATEGORIES ***/
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'detailTypeCategories' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE detailTypeCategories (
	[detailTypeCategoryId]	BIGINT	IDENTITY(1,1) PRIMARY KEY,
	[name]					NVARCHAR(255)	NOT NULL,
    [startDate]				DATE NOT NULL,
    [endDate]				DATE NULL,
    [createdAt]				DATETIME NOT NULL,
    [lastUpdatedAt]				DATETIME NOT NULL
)
	END
GO
--/*** END: DETAILTYPECATEGORIES ***/

--/*** START: ZCAPDETAILTYPES ***/
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'zcapDetailTypes' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE zcapDetailTypes (
	[zcapDetailTypeId]		BIGINT				IDENTITY(1,1) PRIMARY KEY,
	[name]					NVARCHAR(255)	NOT NULL,
	[detailTypeCategoryId]	BIGINT			NOT NULL REFERENCES detailTypeCategories(detailTypeCategoryId),
	[dataTypeId]			BIGINT				NOT NULL REFERENCES dataTypes(dataTypeId),
	[isMandatory]			BIT				NOT NULL,
    [startDate]				DATE NOT NULL,
    [endDate]				DATE NULL,
    [createdAt]				DATETIME NOT NULL,
    [lastUpdatedAt]				DATETIME NOT NULL
)
	END
GO

--/*** END: ZCAPDETAILTYPES ***/

--/*** START: ZCAPDETAILS ***/
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'zcapDetails' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE zcapDetails (
	[zcapDetailId]		BIGINT				IDENTITY(1,1) PRIMARY KEY,
	[zcapId]			BIGINT				NOT NULL REFERENCES zcaps(zcapId),
	[zcapDetailTypeId]	BIGINT				NOT NULL REFERENCES zcapDetailTypes(zcapDetailTypeId),
	[value]				NVARCHAR(MAX)	NOT NULL,
    [startDate]			DATE NOT NULL,
    [endDate]			DATE NULL,
    [createdAt]			DATETIME NOT NULL,
    [lastUpdatedAt]			DATETIME NOT NULL)
	END
GO
--/*** END: ZCAPDETAILS ***/
--/*** START: PERSON DEPENDENCIES (LIST OF DESTINATIONS) ***/
IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'departureDestination' and [TABLE_TYPE] = 'BASE TABLE')
	BEGIN
CREATE TABLE departureDestination(	-- outra ZCAP, casa de familiares, residencia
	[departureDestinationId]	BIGINT IDENTITY(1,1) PRIMARY KEY,
	[name]						NVARCHAR(255)	NOT NULL,
	[startDate]					DATE			NOT NULL,
	[endDate]					DATE			NULL,
	[createdAt]					DATETIME		NOT NULL,
    [lastUpdatedAt]					DATETIME		NOT NULL
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
    [lastUpdatedAt]					DATETIME NOT NULL
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
    [lastUpdatedAt]		DATETIME		NOT NULL
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
    [lastUpdatedAt]				DATETIME		NOT NULL
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
    [lastUpdatedAt]			DATETIME		NOT NULL
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
    [lastUpdatedAt]					DATETIME NOT NULL
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
    [lastUpdatedAt]			DATETIME		NOT NULL
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

--/*** START: INCIDENTTYPES ***/

CREATE TABLE incidentTypes (
	[incidentTypeId]		BIGINT			IDENTITY(1,1) PRIMARY KEY,
	[name]					NVARCHAR(255)	NOT NULL,
	[startDate]				DATE			NOT NULL,
    [endDate]				DATE			NULL,
    [createdAt]				DATETIME		NOT NULL,
    [lastUpdatedAt]				DATETIME		NOT NULL
)

--/*** END: INCIDENTTYPES ***/

--/*** START: INCIDENTS ***/

CREATE TABLE incidents (
	[incidentId]			BIGINT		IDENTITY(1,1) PRIMARY KEY,
	[incidentTypeId]		BIGINT		NOT NULL REFERENCES incidentTypes(incidentTypeId),
	[startDate]				DATE		NOT NULL,
    [endDate]				DATE		NULL,
    [createdAt]				DATETIME	NOT NULL,
    [lastUpdatedAt]				DATETIME	NOT NULL
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
    [lastUpdatedAt]				DATETIME			NOT NULL
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
    [lastUpdatedAt]				DATETIME	NOT NULL
)

--/*** END: INCIDENTPERSONS ***/
--/*** START: USERDATAPROFILES ***/

CREATE TABLE userDataProfiles (
	[userDataProfileId]		BIGINT		IDENTITY(1,1) PRIMARY KEY,
	[name]					NVARCHAR(255)	NOT NULL,
	[startDate]				DATE			NOT NULL,
	[endDate]				DATE			NULL,
	[createdAt]				DATETIME		NOT NULL,
	[lastUpdatedAt]				DATETIME		NOT NULL
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
	[lastUpdatedAt]				DATETIME		NOT NULL
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
	[lastUpdatedAt]				DATETIME		NOT NULL
)

--/*** END: USERS ***/
GO
