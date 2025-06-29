
USE ZCAPNET
GO

/* 1 - Address Tables initial data START */
print 'Inserting Address Tables initial data:'
-- SELECT * FROM treeLevels

IF (SELECT COUNT(*) FROM treeLevels) = 0
BEGIN
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 'País', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (2, 'NUTS 1', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (3, 'NUTS 2', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (4, 'NUTS 3', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (5, 'Município', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Região Autonoma dos Acores', 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Região Autonoma da Madeira', 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 3 ) = 0
BEGIN
	-- INSERT NUTS 2
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Norte', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Algarve', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Centro', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Península de Setúbal', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Grande Lisboa', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alentejo', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Oeste e Vale do Tejo', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Região Autónoma dos Açores', 3, 3, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Região Autónoma da Madeira', 3, 4, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 4 ) = 0
BEGIN
	-- INSERT NUTS 3
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alto Minho', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Cávado', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ave', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Área Metropolitana do Porto', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alto Tâmega e Barroso', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tâmega e Sousa', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Douro', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Terras de Trás-os-Montes', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Algarve', 4, 6, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Região de Aveiro', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Região de Coimbra', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Região de Leiria', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Viseu Dão-Lafoes', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Beira Baixa', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Beiras e Serra da Estrela', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Península de Setúbal', 4, 8, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Grande Lisboa', 4, 9, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alentejo Litoral', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Baixo Alentejo', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alto Alentejo', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alentejo Central', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Oeste', 4, 11, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Médio Tejo', 4, 11, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Lezíria do Tejo', 4, 11, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Região Autonoma dos Açores', 4, 12, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 5 ) = 0
BEGIN
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('São Brás de Alportel', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 6 ) = 0
BEGIN
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('São Brás de Alportel', 6, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 7 ) = 0
BEGIN
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('8150-103', 7, 40, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM treeRecordDetailTypes ) = 0
BEGIN
	INSERT treeRecordDetailTypes ([name], [unit], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Country Code', 'int', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetailTypes ([name], [unit], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Nationality', 'string', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM treeRecordDetails ) = 0
BEGIN
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, '351', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 2, 'portuguesa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM treeLevelDetailType ) = 0
BEGIN
	INSERT treeLevelDetailType([treeLevelId], [detailTypeId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevelDetailType([treeLevelId], [detailTypeId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

/* 1 - Address Tables initial data END */

/* 2 - Zcap Tables initial data Start */
print 'Inserting Zcap Tables initial data:'
IF (SELECT COUNT(*) FROM buildingTypes ) = 0
BEGIN
-- INSERT BUILDINGTYPES
	INSERT buildingTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Escola', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT buildingTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Pavilhão Municipal', '20000101', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
	INSERT buildingTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Tenda', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END


IF (SELECT COUNT(*) FROM entityTypes ) = 0
BEGIN
-- INSERT ENTITYTYPES
	INSERT entityTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Bombeiros', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT entityTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Polícia de Segurança Pública', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT entityTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* ANEPC', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

--IF (SELECT COUNT(*) FROM datatypes ) = 0
-- INSERT DATATYPES
--BEGIN
--	INSERT datatypes ([name]) VALUES ('boolean')
--	INSERT datatypes ([name]) VALUES ('int')
--	INSERT datatypes ([name]) VALUES ('double')
--	INSERT datatypes ([name]) VALUES ('char')
--	INSERT datatypes ([name]) VALUES ('string')
--END

IF (SELECT COUNT(*) FROM entities ) = 0
BEGIN
-- INSERT ENTITIES
	INSERT entities ([name], [entityTypeId], [email], [phone1], [phone2], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Bombeiros Voluntários de Odivelas', 1, 'email@domain.org', '219348290', NULL, '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM detailTypeCategories ) = 0
BEGIN
-- INSERT DETAILTYPECATEGORIES
	INSERT detailTypeCategories ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Atributos Gerais', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT detailTypeCategories ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Específicos', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT detailTypeCategories ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Área de Refeições', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
--SELECT * FROM detailTypeCategories
END

IF (SELECT COUNT(*) FROM zcapDetailTypes ) = 0
BEGIN
-- INSERT ZCAPDETAILTYPES
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Área(m2)', 2, 'DOUBLE', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Acesso a veículos pesados', 2, 'BOOLEAN', 0, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Capacidade c/pernoita', 2, 'INT', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Capacidade s/pernoita', 2, 'INT', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Climatização', 2, 'BOOLEAN', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Cozinha', 3, 'BOOLEAN', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Capacidade de confeção refeições', 3, 'INT', 0, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('*TEST* Refeitório', 3, 'BOOLEAN', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM zcaps ) = 0
BEGIN

INSERT INTO [dbo].[zcaps] ([name],[buildingTypeId],[address],[treeRecordId],[latitude],[longitude],[entityId],[startDate],[createdAt],[lastUpdatedAt])
		VALUES ('Escola Secundária de Odivelas', 1, 'Av. Prof. Dr. Augusto Abreu Lopes 23, 2675-300 Odivelas', 30, 38.794205, -9.179649, 1, '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM zcapDetails ) = 0
BEGIN
-- INSERT ZCAPDETAILS
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [valueCol], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 1301.55, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [valueCol], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 2, 0, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [valueCol], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 3, 130, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [valueCol], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 4, 290, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [valueCol], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 5, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [valueCol], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 6, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [valueCol], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 7, 1666, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [valueCol], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 8, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
	('Gonçalo', 23, '123456789', 1, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('João', 34, '987654321', 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Matilda', 86, '918273645', 1, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM specialNeeds ) = 0
BEGIN
	INSERT INTO specialNeeds([name], startDate, [createdAt], [lastUpdatedAt]) VALUES
	('gravidez', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('doença', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
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
	('vestuário', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('cuidados médicos', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('apoio psicológico', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('procura de familiar', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
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
	('irmão','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('irmã', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('tio','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('tia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('primo', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('prima','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('avô', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('avó', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('neto','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('neta','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('sobrinho', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('sobrinha', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('conjuge', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('padrasto', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
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
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Incêndio rural/florestal', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Incêndio urbano', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Incêndio industrial', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Incêndios', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sismo / Terramoto', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tsunami / Maremoto', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Inundações', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Enxurrada', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Colapso de barragem', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Avalanche', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Onda de frio', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Onda de calor', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vento forte', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ciclone', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tornado', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tempestades', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tempestade de areia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tempestade tropical', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Trovoada', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Chuva ácida', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Poluição atmosférica', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Seca', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Infestação de insetos', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Falta de energia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Epidemia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Erupção vulcânica', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Desmoronamento', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Colapso estrutural', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Colapso de edifício', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Colapso ou desmoronamento da mina', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Desastre aéreo', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Desastre terrestre', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Desastre marítimo', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Industrial/tecnológico', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Acidente', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Explosões', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Explosões químicas', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Explosão nuclear ou termonuclear', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Explosão de mina', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Conflito Nacional civil, guerra civil', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Conflito Internacional', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Refugiados', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT incidentTypes([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Pessoas deslocadas', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
	('admin', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('read-only', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('tecnico','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('diretor', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM userProfileAccessKeys ) = 0
BEGIN
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_screen_zcaps', N'Menu item ZCAPS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_screen_incidents', N'Menu item Incidents', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_screen_settings', N'Menu item Settings', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_tree_levels', N'Menu item Structure Levels in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_tree_elements', N'Menu item Structure Elements in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_tree_detail_types', N'Menu item Structure Detail Types in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_tree_details', N'Menu item Structure Details in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_tree_detail_association', N'Menu item Structure Level-Detail association in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_incident_types', N'Menu item Incident types in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_users', N'Menu item Users in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_user_profiles', N'Menu item User Profiles in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_users_data', N'Menu item Users Data in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_entity_types', N'Menu item Entity Types in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_entities', N'Menu item Entities in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_building_types', N'Menu item Building Types in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_detail_category', N'Menu item Detail Category in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_zcap_detail_type', N'Menu item Zcap Detail Type in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_detail_per_zcap', N'Menu item Zcap Detail in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_people_relation_types', N'Menu item People Relation in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_special_need_types', N'Menu item People Special Needs in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_support_need_types', N'Menu item People Support Needs in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM userProfileAccessAllowance) = 0
BEGIN
	SET IDENTITY_INSERT [dbo].[userProfileAccessAllowance] ON 
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 1, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.000' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (2, 1, 2, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.000' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (3, 1, 3, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.000' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (4, 1, 4, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.000' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (5, 1, 5, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.000' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (6, 1, 6, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.000' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (7, 1, 7, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.000' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (8, 1, 8, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.000' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (9, 1, 9, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.000' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (10, 1, 10, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.000' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (11, 1, 11, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.000' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (12, 1, 12, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (13, 1, 13, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (14, 1, 14, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (15, 1, 15, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (16, 1, 16, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (17, 1, 17, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (18, 1, 18, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (19, 1, 19, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (20, 1, 20, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (21, 1, 21, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (22, 2, 1, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (23, 2, 2, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (24, 2, 3, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (25, 2, 4, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (26, 2, 5, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (27, 2, 6, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (28, 2, 7, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (29, 2, 8, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (30, 2, 9, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (31, 2, 10, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (32, 2, 11, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (33, 2, 12, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (34, 2, 13, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.357' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (35, 2, 14, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.377' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (36, 2, 15, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.377' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (37, 2, 16, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.377' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (38, 2, 17, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.377' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (39, 2, 18, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.377' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (40, 2, 19, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.377' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (41, 2, 20, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.377' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (42, 2, 21, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.377' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (43, 3, 1, 2, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (44, 3, 2, 2, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (45, 3, 3, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (46, 3, 4, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (47, 3, 5, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (48, 3, 6, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (49, 3, 7, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (50, 3, 8, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (51, 3, 9, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (52, 3, 10, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (53, 3, 11, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (54, 3, 12, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (55, 3, 13, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (56, 3, 14, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (57, 3, 15, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (58, 3, 16, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (59, 3, 17, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (60, 3, 18, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (61, 3, 19, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (62, 3, 20, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (63, 3, 21, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (64, 4, 1, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (65, 4, 2, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (66, 4, 3, 2, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (67, 4, 4, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (68, 4, 5, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (69, 4, 6, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (70, 4, 7, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (71, 4, 8, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (72, 4, 9, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (73, 4, 10, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (74, 4, 11, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (75, 4, 12, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (76, 4, 13, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (77, 4, 14, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (78, 4, 15, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (79, 4, 16, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (80, 4, 17, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (81, 4, 18, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (82, 4, 19, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (83, 4, 20, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (84, 4, 21, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T19:11:18.940' AS DateTime))
	SET IDENTITY_INSERT [dbo].[userProfileAccessAllowance] OFF
END

IF (SELECT COUNT(*) FROM users ) = 0
BEGIN
	INSERT [dbo].[users] ([userName], [name], [password], [userProfileId], [userDataProfileId], [startDate], [endDate], [createdAt], [lastUpdatedAt])
	VALUES (N'admin', N'Administrator', N'$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 1, 1, CAST(N'2020-01-01' AS Date), NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

	INSERT users ([userName], [name], [password], userProfileId, userDataProfileId, startDate, [createdAt], [lastUpdatedAt]) VALUES
	('dimas02'	, 'Gonçalo'	, '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('xpto97', 'Antonio', '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 2, 1,'20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('SirP'		, 'Paulo'	, '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 3, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('SirDirector', 'Joao', '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 4, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('lalves'	, 'Luis'	, '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END
/* 5 - User Tables initial data END */