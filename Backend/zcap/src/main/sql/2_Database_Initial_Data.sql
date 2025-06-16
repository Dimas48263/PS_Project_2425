
USE ZCAPNET
GO

/* 1 - Address Tables initial data START */
print 'Inserting Address Tables initial data:'
-- SELECT * FROM treeLevels

IF (SELECT COUNT(*) FROM treeLevels) = 0
BEGIN
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 'Pais', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (2, 'NUTS 1', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (3, 'NUTS 2', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (4, 'NUTS 3', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (5, 'Municipio', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (6, 'Freguesia', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (7, 'Codigo Postal', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END


IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 1 ) = 0
BEGIN
	-- INSERT COUNTRIES
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Portugal', 1, NULL, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 2 ) = 0
BEGIN
	-- INSERT NUTS 1
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Portugal Continental', 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Regiao Autonoma dos Acores', 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Regiao Autonoma da Madeira', 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 3 ) = 0
BEGIN
	-- INSERT NUTS 2
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Norte', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Algarve', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Centro', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Peninsula de Setubal', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Grande Lisboa', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alentejo', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Oeste e Vale do Tejo', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Regiao Autonoma dos Acores', 3, 3, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Regiao Autonoma da Madeira', 3, 4, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 4 ) = 0
BEGIN
	-- INSERT NUTS 3
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alto Minho', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Cavado', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ave', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Area Metropolitana do Porto', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alto Tamega e Barroso', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tamega e Sousa', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Douro', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Terras de Tras-os-Montes', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Algarve', 4, 6, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Regiao de Aveiro', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Regiao de Coimbra', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Regiao de Leiria', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Viseu Dao-Lafoes', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Beira Baixa', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Beiras e Serra da Estrela', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Peninsula de Setubal', 4, 8, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Grande Lisboa', 4, 9, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alentejo Litoral', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Baixo Alentejo', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alto Alentejo', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alentejo Central', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Oeste', 4, 11, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Medio Tejo', 4, 11, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Leziria do Tejo', 4, 11, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Regiao Autonoma dos Acores', 4, 12, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 5 ) = 0
BEGIN
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sao Bras de Alportel', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 6 ) = 0
BEGIN
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sao Bras de Alportel', 6, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 7 ) = 0
BEGIN
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('8150-103', 7, 40, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM treeRecordDetailTypes ) = 0
BEGIN
	INSERT treeRecordDetailTypes ([name], [unit], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Coutry Code', 'int', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetailTypes ([name], [unit], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Nationality', 'string', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM treeRecordDetails ) = 0
BEGIN
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, '351', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 2, 'portuguesa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

/* 1 - Address Tables initial data END */

/* 2 - Zcap Tables initial data Start */
print 'Inserting Zcap Tables initial data:'
IF (SELECT COUNT(*) FROM buildingTypes ) = 0
BEGIN
-- INSERT BUILDINGTYPES
	INSERT buildingTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Escola', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT buildingTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Pavilh�o Municipal', '20000101', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
	INSERT buildingTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Tenda', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END


IF (SELECT COUNT(*) FROM entityTypes ) = 0
BEGIN
-- INSERT ENTITYTYPES
	INSERT entityTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Bombeiros', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT entityTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Pol�cia de Seguran�a P�blica', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT entityTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* ANEPC', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM datatypes ) = 0
-- INSERT DATATYPES
BEGIN
	INSERT datatypes ([name]) VALUES ('boolean')
	INSERT datatypes ([name]) VALUES ('int')
	INSERT datatypes ([name]) VALUES ('double')
	INSERT datatypes ([name]) VALUES ('char')
	INSERT datatypes ([name]) VALUES ('string')
END

IF (SELECT COUNT(*) FROM entities ) = 0
BEGIN
-- INSERT ENTITIES
	INSERT entities ([name], [entityTypeId], [email], [phone1], [phone2], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Bombeiros Volunt�rio de Odivelas', 1, 'email@domain.org', '219348290', NULL, '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM detailTypeCategories ) = 0
BEGIN
-- INSERT DETAILTYPECATEGORIES
	INSERT detailTypeCategories ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Atributos Gerais', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT detailTypeCategories ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Espec�ficos', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT detailTypeCategories ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Area de Refei��es', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
--SELECT * FROM detailTypeCategories
END

IF (SELECT COUNT(*) FROM zcapDetailTypes ) = 0
BEGIN
-- INSERT ZCAPDETAILTYPES
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Area(m2)', 2, 3, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Acesso a ve�culos pesados', 2, 1, 0, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Capacidade c/pernoita', 2, 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Capacidade s/pernoita', 2, 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Climatiza��o', 2, 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Cozinha', 3, 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Capacidade de confecao refeicoes', 3, 2, 0, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Refeit�rio', 3, 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM zcaps ) = 0
BEGIN
-- INSERT ZCAPS
	INSERT zcaps ([name], [buildingTypeId], [address], [entityId], [startDate], [createdAt], [lastUpdatedAt])
		VALUES ('*TEST* Escola Secund�ria de Odivelas', 1, 'Av. Prof. Dr. Augusto Abreu Lopes 23, 2675-300 Odivelas', 1, '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM zcapDetails ) = 0
BEGIN
-- INSERT ZCAPDETAILS
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 1301.55, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 2, 0, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 3, 130, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 4, 290, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 5, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 6, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 7, 1666, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 8, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

/* 2 - Zcap Tables initial data END */

/* 3 - Person Tables initial data START */
print 'Inserting Person Tables initial data:'
IF (SELECT COUNT(*) FROM departureDestination ) = 0
BEGIN
	INSERT INTO departureDestination([name], startDate, [createdAt], [lastUpdatedAt]) VALUES
	('zcap', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('casa de familiares', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('residencia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM persons ) = 0
BEGIN
	INSERT INTO persons([name], age, contact, countryCodeId, placeOfResidence, entryDatetime, [createdAt], [lastUpdatedAt]) VALUES
	('Gon�alo', 23, '123456789', 1, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Jo�o', 34, '987654321', 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Matilda', 86, '918273645', 1, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM specialNeeds ) = 0
BEGIN
	INSERT INTO specialNeeds([name], startDate, [createdAt], [lastUpdatedAt]) VALUES
	('gravidez', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('doen�a', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('medicamentos', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('outro', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) 
END

IF (SELECT COUNT(*) FROM personSpecialNeeds ) = 0
BEGIN
	INSERT INTO personSpecialNeeds(personId, specialNeedId, [description], startDate, [createdAt], [lastUpdatedAt]) VALUES
	(1, 2, NULL, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), (2, 4, 'perna partida', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM supportNeeded ) = 0
BEGIN
	INSERT INTO supportNeeded([name], startDate, [createdAt], [lastUpdatedAt]) VALUES
	('alojamento', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('comida', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('vestu�rio', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('cuidados m�dicos', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('apoio psicol�gico', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('procura de familiar', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('outro', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM personSupportNeeded ) = 0
BEGIN
	INSERT INTO personSupportNeeded(personId, supportNeededId, [description], startDate, [createdAt], [lastUpdatedAt]) VALUES
	(3, 1, NULL,'20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), (3, 2, NULL, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), (1, 2, NULL, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	(1, 3, NULL, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) 
END

IF (SELECT COUNT(*) FROM relationType ) = 0
BEGIN
	INSERT INTO relationType ([name], startDate, [createdAt], [lastUpdatedAt]) VALUES
	('mae', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('pai', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('filho', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('filha', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('irm�o','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('irm�', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('tio','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('tia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('primo', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('prima','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('av�', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('av�', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('neto','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('neta','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('sobrinho', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('sobrinha', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('c�njuge', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('padrasto', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('madrasta', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM relation ) = 0
BEGIN
	INSERT INTO relation(personId1, personId2, relationTypeId) VALUES
	(1, 2, 5)
END
/* 3 - Person Tables initial data END */

/* 4 - Incident Tables initial data START */
print 'Inserting Incident Tables initial data:'

IF (SELECT COUNT(*) FROM incidentTypes ) = 0
BEGIN
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sismo', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Maremoto', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Pandemia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Despejamento', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Inc�ndio', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
END

IF (SELECT COUNT(*) FROM incidents ) = 0
BEGIN
	INSERT incidents([incidentTypeId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidents([incidentTypeId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidents([incidentTypeId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (3, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidents([incidentTypeId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (4, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidents([incidentTypeId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
END

IF (SELECT COUNT(*) FROM incidentZcaps ) = 0
BEGIN
	INSERT incidentZcaps([incidentId], [zcapId], [entityId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
END

IF (SELECT COUNT(*) FROM incidentZcapPersons ) = 0
BEGIN
	INSERT incidentZcapPersons([incidentZcapId], [personId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
END

/* 4 - Incident Tables initial data END */

/* 5 - User Tables initial data START */
print 'Inserting User Tables initial data:'
IF (SELECT COUNT(*) FROM userDataProfiles ) = 0
BEGIN
	INSERT userDataProfiles ([name], startDate, [createdAt], [lastUpdatedAt]) VALUES
	('*TEST* Lisboa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM userDataProfileDetails ) = 0
BEGIN
	INSERT userDataProfileDetails (userDataProfileId, treeRecordId) VALUES
	(1, 1), (1, 3)
END

IF (SELECT COUNT(*) FROM userProfiles ) = 0
BEGIN

	INSERT userProfiles ([name], startDate, [createdAt], [lastUpdatedAt]) VALUES
	('admin', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('read-only', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('tecnico','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('diretor', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM users ) = 0
BEGIN
	INSERT [dbo].[users] ([userName], [name], [password], [userProfileId], [userDataProfileId], [startDate], [endDate], [createdAt], [lastUpdatedAt])
	VALUES (N'admin', N'Administrator', N'$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 1, 1, CAST(N'2020-01-01' AS Date), NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

	INSERT users ([userName], [name], [password], userProfileId, userDataProfileId, startDate, [createdAt], [lastUpdatedAt]) VALUES
	('dimas02'	, 'Gon�alo'	, '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('xpto97', 'Antonio', '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 2, 1,'20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('SirP'		, 'Paulo'	, '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 3, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('SirDirector', 'Joao', '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 4, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('lalves'	, 'Luis'	, '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END
/* 5 - User Tables initial data END */