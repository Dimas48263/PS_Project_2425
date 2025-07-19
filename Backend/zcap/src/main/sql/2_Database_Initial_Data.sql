
USE ZCAPNET
GO

/* 1 - Address Tables initial data START */
print 'Inserting Address Tables initial data:'
-- SELECT * FROM treeLevels

IF (SELECT COUNT(*) FROM treeLevels) = 0
BEGIN
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 'País', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (2, 'NUTS 1', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (3, 'NUTS 2 - Região', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (4, 'NUTS 3 - Sub-Região', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (5, 'Município', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [lastUpdatedAt]) VALUES (6, 'Freguesia', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
	-- INSERT NUTS 2 - Regioes
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
	-- INSERT NUTS 3 - Sub-Regioes
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
	
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Região Autónoma dos Açores', 4, 12, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Região Autónoma da Madeira', 4, 13, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

-- Municipios
IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 5 ) = 0
BEGIN
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Arcos de Valdevez', 5, 14, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Caminha', 5, 14, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Melgaço', 5, 14, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Monção', 5, 14, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Paredes de Coura', 5, 14, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ponte da Barca', 5, 14, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ponte de Lima', 5, 14, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Valença', 5, 14, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Viana do Castelo', 5, 14, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Nova de Cerveira', 5, 14, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Amares', 5, 15, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Barcelos', 5, 15, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Braga', 5, 15, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Esposende', 5, 15, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Terras de Bouro', 5, 15, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Verde', 5, 15, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Cabeceiras de Basto', 5, 16, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Fafe', 5, 16, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Guimarães', 5, 16, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mondim de Basto', 5, 16, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Póvoa de Lanhoso', 5, 16, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vieira do Minho', 5, 16, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Nova de Famalicão', 5, 16, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vizela', 5, 16, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Arouca', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Espinho', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Gondomar', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Maia', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Matosinhos', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Oliveira de Azeméis', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Paredes', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Porto', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Póvoa de Varzim', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Santa Maria da Feira', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Santo Tirso', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('São João da Madeira', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Trofa', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vale de Cambra', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Valongo', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila do Conde', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Nova de Gaia', 5, 17, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Boticas', 5, 18, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Chaves', 5, 18, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Montalegre', 5, 18, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ribeira de Pena', 5, 18, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Valpaços', 5, 18, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Pouca de Aguiar', 5, 18, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Amarante', 5, 19, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Baião', 5, 19, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Castelo de Paiva', 5, 19, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Celorico de Basto', 5, 19, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Cinfães', 5, 19, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Felgueiras', 5, 19, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Lousada', 5, 19, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Marco de Canaveses', 5, 19, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Paços de Ferreira', 5, 19, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Penafiel', 5, 19, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Resende', 5, 19, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alijó', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Armamar', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Carrazeda de Ansiães', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Freixo de Espada à Cinta', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Lamego', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mesão Frio', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Moimenta da Beira', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Murça', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Penedono', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Peso da Régua', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sabrosa', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Santa Marta de Penaguião', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('São João da Pesqueira', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sernancelhe', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tabuaço', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tarouca', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Torre de Moncorvo', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Nova de Foz Côa', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Real ', 5, 20, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alfândega da Fé', 5, 21, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Bragança', 5, 21, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Macedo de Cavaleiros', 5, 21, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Miranda do Douro', 5, 21, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mirandela', 5, 21, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mogadouro', 5, 21, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Flor', 5, 21, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vimioso', 5, 21, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vinhais', 5, 21, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Albufeira', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alcoutim', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Aljezur', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Castro Marim', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Faro', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Lagoa', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Lagos', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Loulé', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Monchique', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Olhão', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Portimão', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('São Brás de Alportel', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Silves', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tavira', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila do Bispo', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Real de Santo António', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Águeda', 5, 23, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Albergaria-a-Velha', 5, 23, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Anadia', 5, 23, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Aveiro', 5, 23, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Estarreja', 5, 23, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ílhavo', 5, 23, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Murtosa', 5, 23, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Oliveira do Bairro', 5, 23, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ovar', 5, 23, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sever do Vouga', 5, 23, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vagos', 5, 23, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Arganil', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Cantanhede', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Coimbra', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Condeixa-a-Nova', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Figueira da Foz', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Góis', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Lousã', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mealhada', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mira', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Miranda do Corvo', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Montemor-o-Velho', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mortágua', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Oliveira do Hospital', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Pampilhosa da Serra', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Penacova', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Penela', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Soure', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tábua', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Nova de Poiares', 5, 24, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alvaiázere', 5, 25, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ansião', 5, 25, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Batalha', 5, 25, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Castanheira de Pera', 5, 25, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Figueiró dos Vinhos', 5, 25, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Leiria', 5, 25, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Marinha Grande', 5, 25, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Pedrógão Grande', 5, 25, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Pombal', 5, 25, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Porto de Mós', 5, 25, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Aguiar da Beira', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Carregal do Sal', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Castro Daire', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mangualde', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Nelas', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Oliveira de Frades', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Penalva do Castelo', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Santa Comba Dão', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('São Pedro do Sul', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sátão', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tondela (cidade)', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Nova de Paiva', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Viseu', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vouzela', 5, 26, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Castelo Branco', 5, 27, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Idanha-a-Nova', 5, 27, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Oleiros', 5, 27, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Penamacor', 5, 27, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Proença-a-Nova', 5, 27, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sertã', 5, 27, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila de Rei', 5, 27, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Velha de Ródão', 5, 27, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Almeida', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Belmonte', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Celorico da Beira', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Covilhã', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Figueira de Castelo Rodrigo', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Fornos de Algodres', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Fundão', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('GouveiaCentro da cidade da Covilhã', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Guarda', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Manteigas', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mêda', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Pinhel', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sabugal', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Seia', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Trancoso', 5, 28, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alcochete', 5, 29, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Almada', 5, 29, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Barreiro', 5, 29, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Moita', 5, 29, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Montijo', 5, 29, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Palmela', 5, 29, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Seixal', 5, 29, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sesimbra', 5, 29, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Setúbal', 5, 29, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Amadora', 5, 30, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Cascais', 5, 30, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Lisboa', 5, 30, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Loures', 5, 30, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mafra', 5, 30, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Odivelas', 5, 30, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Oeiras', 5, 30, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sintra', 5, 30, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Franca de Xira', 5, 30, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alcácer do Sal', 5, 31, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Grândola', 5, 31, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Odemira', 5, 31, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Santiago do Cacém', 5, 31, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sines', 5, 31, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Aljustrel', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Almodôvar', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alvito', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Barrancos', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Beja', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Castro Verde', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Cuba', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ferreira do Alentejo', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mértola', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Moura', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ourique', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Serpa', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vidigueira', 5, 32, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alter do Chão', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Arronches', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Avis', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Campo Maior', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Castelo de Vide', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Crato', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Elvas', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Fronteira', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Gavião', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Marvão', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Monforte', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Nisa', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ponte de Sor', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Portalegre', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sousel', 5, 33, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alandroal', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Arraiolos', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Borba', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Estremoz', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Évora', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Montemor-o-Novo', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mora', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mourão', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Portel', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Redondo', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Reguengos de Monsaraz', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vendas Novas', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Viana do Alentejo', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Viçosa', 5, 34, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alcobaça', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alenquer', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Arruda dos Vinhos', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Bombarral', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Cadaval', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Caldas da Rainha', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Lourinhã', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Nazaré', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Óbidos', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Peniche', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sobral de Monte Agraço', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Torres Vedras', 5, 35, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Abrantes', 5, 36, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alcanena', 5, 36, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Constância', 5, 36, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Entroncamento', 5, 36, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ferreira do Zêzere', 5, 36, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Mação', 5, 36, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ourém', 5, 36, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Sardoal', 5, 36, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tomar', 5, 36, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Torres Novas', 5, 36, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Nova da Barquinha', 5, 36, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Almeirim', 5, 37, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Alpiarça', 5, 37, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Azambuja', 5, 37, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Benavente', 5, 37, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Cartaxo', 5, 37, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Chamusca', 5, 37, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Coruche', 5, 37, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Golegã', 5, 37, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Rio Maior', 5, 37, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Salvaterra de Magos', 5, 37, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Santarém', 5, 37, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Angra do Heroísmo', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Calheta', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Corvo', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Horta', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Lagoa', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Lajes das Flores', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Lajes do Pico', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Madalena', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Nordeste', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ponta Delgada', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Povoação', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Praia da Vitória', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ribeira Grande', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Santa Cruz das Flores', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Santa Cruz da Graciosa', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('São Roque do Pico', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Velas', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila do Porto', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Vila Franca do Campo ', 5, 38, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Calheta', 5, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Câmara de Lobos', 5, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Funchal', 5, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Machico', 5, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ponta do Sol', 5, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Porto Moniz', 5, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Porto Santo', 5, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Ribeira Brava', 5, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Santa Cruz', 5, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Santana', 5, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('São Vicente', 5, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

END

-- Freguesias
--IF (SELECT COUNT(*) FROM tree WHERE [treeLevelId] = 6 ) = 0
--BEGIN
--	INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('São Brás de Alportel', 6, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
--END


IF (SELECT COUNT(*) FROM treeRecordDetailTypes ) = 0
BEGIN
	INSERT treeRecordDetailTypes ([name], [unit], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Nationality', 'STRING', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM treeRecordDetails ) = 0
BEGIN
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'afegãa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'sul-africana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'albanesa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'alemã', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'andorrana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'angolana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'anguilana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'antiguana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'antilhana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'árabe-saudita', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'argelina', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'argentina', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'arménia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'arubana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'australiana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'austríaca', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'azeri', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'baamiana ', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'barenita', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'bangladechiana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'barbadense', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'belga', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'belizenha', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'beninesea', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'bermudense', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'bielorrussa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'boliviana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'bósnia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'botsuana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'brasileira', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'bruneína', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'búlgara', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'burquina', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'burundiana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'butanesa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'cabo-verdiana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'camaronesa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'cambojana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'canadiana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'cazaque', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'chadiana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'chilena', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'china', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'cipriota', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'colombiana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'comoriana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'congolesa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'norte-coreana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'sul-coreana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'marfinense', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'costarriquenha', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'croata', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'cubana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'curaçauense', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'dinamarquesa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'jibutiana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'dominiqua', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'egípcia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'salvadorenha', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'emiradense', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'equatoriana', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'eritreia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'escocesa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'eslovaca', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'eslovena', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'espanhola', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 'micronésia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'norte-americana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'estoniana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'etíope','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'fijiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'filipina','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'finlandesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'francesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'gabonesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'gambiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'ganesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'georgiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'granadina','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'grega','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'guadalupense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'guamesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'guatemalteca','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'guianesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'guianense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'guineana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'guinéu-equatoriana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'guineense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'haitiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'hondurenha','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'honconguesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'húngara','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'iemenita','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'caimanesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'cookense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'faroense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'salomonense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'virginense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'virginense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'indiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'indonésia','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'inglesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'iraniana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'iraquiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'irlandesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'norte-irlandesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'islanda','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'israelense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'italiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'jamaicana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'japonesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'jordana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'quiribatiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'kosovar','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'kuwaitiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'laociana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'lesotiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'letã','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'libanesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'liberiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'líbia','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'listenstainiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'lituana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'luxemburguesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'macaense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'macedônica','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'malgaxe','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'malaia','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'malauiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'maldiva','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'maltesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'marroquina','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'martinicana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'mauriciana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'mauritana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'mexicana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'birmanesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'moldava','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'monegasca','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'mongol','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'montenegrina','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'monserratense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'namibiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'nauruana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'nepalesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'nicaraguense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'nigerina','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'nigeriana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'noroeguesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'neocaledónia','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'neozelandesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'omanense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'galesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'neerlandesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'palauana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'palestiniana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'panamenha','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'papua','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'paquistanesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'paraguaia','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'peruana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'polinésia','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'polonesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'porto-riquenha','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'portuguesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'catariana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'queniana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'quirguiz','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'britânica','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'centro-africana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'tcheca','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'taiwanesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'congolesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'dominicana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'romena','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'ruandesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'russa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'são-martinhense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'samoana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'samoense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'santa-luciense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'são-cristovense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'são-marinhense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'são-tomense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'são-vicentina','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'senegalesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'serra-leonesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'sérvia','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'seichelense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'singapurense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'síria','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'somali','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'cingalesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'essuatinianoa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'sudanesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'sueca','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'suíça','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'surinamesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'tajique','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'tailandesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'taiwanesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'tanzaniana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'timorense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'togolesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'tonganesa','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'trinitária-tobagense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'tunisiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'turquense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'turquemena','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'turca','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'tuvaluana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'ucraniana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'ugandense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'uruguaia','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'usbeque','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'vanuatuense','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'vaticana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'venezuelana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'vietnamita','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'zambiana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [lastUpdatedAt]) VALUES (1,1,'zimbabuana','20200101',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
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
	INSERT buildingTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Escola', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT buildingTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Pavilhão Municipal', '20000101', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
	INSERT buildingTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Tenda', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END


IF (SELECT COUNT(*) FROM entityTypes ) = 0
BEGIN
-- INSERT ENTITYTYPES
	INSERT entityTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Bombeiros', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT entityTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Polícia de Segurança Pública', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT entityTypes ([name], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('ANEPC', '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
	INSERT entities ([name], [entityTypeId], [email], [phone1], [phone2], [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Bombeiros Voluntários de Odivelas', 1, 'email@domain.org', '219348290', NULL, '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Área(m2)', 2, 'DOUBLE', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Acesso a veículos pesados', 2, 'BOOLEAN', 0, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Capacidade c/pernoita', 2, 'INT', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Capacidade s/pernoita', 2, 'INT', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Climatização', 2, 'BOOLEAN', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Cozinha', 3, 'BOOLEAN', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Capacidade de confeção refeições', 3, 'INT', 0, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
	INSERT zcapDetailTypes ([name], detailTypeCategoryId, dataType, isMandatory, [startDate], [createdAt], [lastUpdatedAt]) VALUES ('Refeitório', 3, 'BOOLEAN', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM zcaps ) = 0
BEGIN

INSERT INTO [dbo].[zcaps] ([name],[buildingTypeId],[address],[treeRecordId],[latitude],[longitude],[entityId],[startDate],[createdAt],[lastUpdatedAt])
		VALUES ('Escola Secundária de Odivelas', 1, 'Av. Prof. Dr. Augusto Abreu Lopes 23, 2675-300 Odivelas', 233, 38.794205, -9.179649, 1, '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT INTO [dbo].[zcaps] ([name],[buildingTypeId],[address],[treeRecordId],[latitude],[longitude],[entityId],[startDate],[createdAt],[lastUpdatedAt])
		VALUES ('Pavilhão Gimnodesportivo de Santa Cruz', 1, 'Caminho Francisco Freitas Branco, Machico', 345, 32.6890444, -16.7961675, 1, '20000101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
	('zcap', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Casa de familiares', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('residencia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM persons ) = 0
BEGIN
	INSERT INTO persons([name], age, contact, placeOfResidence, entryDatetime, [createdAt], [lastUpdatedAt]) VALUES
	('Gonçalo', 23, '123456789', 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('João', 34, '987654321', 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Matilda', 86, '918273645', 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM specialNeeds ) = 0
BEGIN
	INSERT INTO specialNeeds([name], startDate, [createdAt], [lastUpdatedAt]) VALUES
	('Gravidez', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Doença', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('Medicamentos', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Outro', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) 
END

IF (SELECT COUNT(*) FROM personSpecialNeeds ) = 0
BEGIN
	INSERT INTO personSpecialNeeds(personId, specialNeedId, [description], startDate, [createdAt], [lastUpdatedAt]) VALUES
	(1, 2, NULL, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), (2, 4, 'Perna partida', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
END

IF (SELECT COUNT(*) FROM supportNeeded ) = 0
BEGIN
	INSERT INTO supportNeeded([name], startDate, [createdAt], [lastUpdatedAt]) VALUES
	('Alojamento', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Refeição', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('Vestuário', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Cuidados médicos', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Apoio psicológico', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Procura de familiar', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Outro', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
	('Mãe', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Pai', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('Filho', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Filha', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Irmão','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Irmã', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('Tio','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Tia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('Primo', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Prima','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('Avô', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Avó', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Neto','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Neta','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('Sobrinho', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Sobrinha', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	('Conjuge', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('Padrasto', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
	('Madrasta', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
	INSERT incidents([incidentTypeId], [treeRecordId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 233, '20250711', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidents([incidentTypeId], [treeRecordId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (2, 314, '20250623', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidents([incidentTypeId], [treeRecordId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (3, 299, '20250606', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidents([incidentTypeId], [treeRecordId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (4, 233, '20250502', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidents([incidentTypeId], [treeRecordId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (5, 346, '20250703', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
END

IF (SELECT COUNT(*) FROM incidentZcaps ) = 0
BEGIN
	INSERT incidentZcaps([incidentId], [zcapId], [entityId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
END

IF (SELECT COUNT(*) FROM incidentZcapPersons ) = 0
BEGIN
	INSERT incidentZcapPersons([incidentZcapId], [personId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidentZcapPersons([incidentZcapId], [personId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
	INSERT incidentZcapPersons([incidentZcapId], [personId], [startDate], [createdAt], [lastUpdatedAt]) VALUES (1, 3, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
END

/* 4 - Incident Tables initial data END */

/* 5 - User Tables initial data START */
print 'Inserting User Tables initial data:'
IF (SELECT COUNT(*) FROM userDataProfiles ) = 0
BEGIN
	INSERT userDataProfiles ([name], startDate, [createdAt], [lastUpdatedAt]) VALUES
	(' Lisboa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_add_people', N'Menu item adding People in ZCAP', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_people_departure_destinations', N'Menu item People Departure Destination in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_special_need_types', N'Menu item People Special Needs in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_settings_support_need_types', N'Menu item People Support Needs in Settings Screen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_password_change', N'Menu option to allow user to change password', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT [dbo].[userProfileAccessKeys] ([accessKey], [description], [createdAt], [lastUpdatedAt]) VALUES ( N'user_access_reset_passwords', N'Menu option to allow user to reset other users passwords', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (85, 1, 22, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (86, 2, 22, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.377' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (87, 1, 23, 0, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:44:27.003' AS DateTime))
	INSERT [dbo].[userProfileAccessAllowance] ([userProfileAccessAllowanceId], [userProfileId], [userProfileAccessKeyId], [accessType], [createdAt], [lastUpdatedAt]) VALUES (88, 2, 23, 1, CAST(N'2025-06-29T16:51:05.027' AS DateTime), CAST(N'2025-06-29T17:55:27.377' AS DateTime))
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