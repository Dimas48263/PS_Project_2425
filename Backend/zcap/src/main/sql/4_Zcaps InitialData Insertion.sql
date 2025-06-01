-- DATA INSERTION
-- INSERT BUILDINGTYPES
INSERT buildingTypes ([name], [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Escola', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT buildingTypes ([name], [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Pavilhão Municipal', '20000101', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
INSERT buildingTypes ([name], [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Tenda', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
-- SELECT * FROM buildingTypes

-- INSERT ENTITYTYPES
INSERT entityTypes ([name], [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Bombeiros', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT entityTypes ([name], [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Polícia de Segurança Pública', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT entityTypes ([name], [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* ANEPC', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
-- SELECT * FROM entityTypes

-- INSERT DATATYPES
	INSERT datatypes ([name]) VALUES ('boolean')
	INSERT datatypes ([name]) VALUES ('int')
	INSERT datatypes ([name]) VALUES ('double')
	INSERT datatypes ([name]) VALUES ('char')
	INSERT datatypes ([name]) VALUES ('string')
--SELECT * FROM dataTypes

-- INSERT ENTITIES
INSERT entities ([name], [entityTypeId], [email], [phone1], [phone2], [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Bombeiros Voluntário de Odivelas', 1, 'email@domain.org', '219348290', NULL, '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
-- SELECT * FROM entities

-- INSERT DETAILTYPECATEGORIES
	INSERT detailTypeCategories ([name], [startDate], [createdAt], [updatedAt]) VALUES ('Atributos Gerais', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT detailTypeCategories ([name], [startDate], [createdAt], [updatedAt]) VALUES ('Específicos', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT detailTypeCategories ([name], [startDate], [createdAt], [updatedAt]) VALUES ('Area de Refeições', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
--SELECT * FROM detailTypeCategories

-- INSERT ZCAPDETAILTYPES
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Area(m2)', 2, 3, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Acesso a veículos pesados', 2, 1, 0, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Capacidade c/pernoita', 2, 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Capacidade s/pernoita', 2, 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Climatização', 2, 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Cozinha', 3, 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Capacidade de confecao refeicoes', 3, 2, 0, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataTypeId, isMandatory, [startDate], [createdAt], [updatedAt]) VALUES ('*TEST* Refeitório', 3, 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
--SELECT * FROM zcapDetailTypes

-- INSERT ZCAPS
	INSERT zcaps ([name], [buildingTypeId], [address], [entityId], [startDate], [createdAt], [updatedAt])
		VALUES ('*TEST* Escola Secundária de Odivelas', 1, 'Av. Prof. Dr. Augusto Abreu Lopes 23, 2675-300 Odivelas', 1, '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
-- SELECT * FROM zcaps

-- INSERT ZCAPDETAILS
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [updatedAt]) VALUES (1, 1, 1301.55, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [updatedAt]) VALUES (1, 2, 0, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [updatedAt]) VALUES (1, 3, 130, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [updatedAt]) VALUES (1, 4, 290, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [updatedAt]) VALUES (1, 5, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [updatedAt]) VALUES (1, 6, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [updatedAt]) VALUES (1, 7, 1666, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetails (zcapId, zcapDetailTypeId, [value], [startDate], [createdAt], [updatedAt]) VALUES (1, 8, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
-- SELECT * FROM zcapDetails

