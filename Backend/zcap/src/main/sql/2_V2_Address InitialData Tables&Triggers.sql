


-- SELECT * FROM treeLevels

INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [updatedAt]) VALUES (1, 'Pais', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [updatedAt]) VALUES (2, 'NUTS 1', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [updatedAt]) VALUES (3, 'NUTS 2', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [updatedAt]) VALUES (4, 'NUTS 3', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [updatedAt]) VALUES (5, 'Municipio', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [updatedAt]) VALUES (6, 'Freguesia', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT treeLevels ([levelId], [name], [description], [startDate], [createdAt], [updatedAt]) VALUES (7, 'Codigo Postal', '', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

-- SELECT * FROM tree
-- INSERT COUNTRIES
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Portugal', 1, NULL, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
-- INSERT NUTS 1
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Portugal Continental', 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Regiao Autonoma dos Acores', 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Regiao Autonoma da Madeira', 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
-- INSERT NUTS 2
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Norte', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Algarve', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Centro', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Peninsula de Setubal', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Grande Lisboa', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Alentejo', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Oeste e Vale do Tejo', 3, 2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Regiao Autonoma dos Acores', 3, 3, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Regiao Autonoma da Madeira', 3, 4, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
-- INSERT NUTS 3
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Alto Minho', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Cavado', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Ave', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Area Metropolitana do Porto', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Alto Tamega e Barroso', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Tamega e Sousa', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Douro', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Terras de Tras-os-Montes', 4, 5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Algarve', 4, 6, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Regiao de Aveiro', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Regiao de Coimbra', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Regiao de Leiria', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Viseu Dao-Lafoes', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Beira Baixa', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Beiras e Serra da Estrela', 4, 7, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Peninsula de Setubal', 4, 8, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Grande Lisboa', 4, 9, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Alentejo Litoral', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Baixo Alentejo', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Alto Alentejo', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Alentejo Central', 4, 10, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Oeste', 4, 11, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Medio Tejo', 4, 11, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Leziria do Tejo', 4, 11, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Regiao Autonoma dos Acores', 4, 12, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Sao Bras de Alportel', 5, 22, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('Sao Bras de Alportel', 6, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT tree ([name], [treeLevelId], [parentId], [startDate], [createdAt], [updatedAt]) VALUES ('8150-103', 7, 40, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT treeRecordDetailTypes ([name], [unit], [startDate], [createdAt], [updatedAt]) VALUES ('Coutry Code', 'int', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [updatedAt]) VALUES (1, 1, '351', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT treeRecordDetailTypes ([name], [unit], [startDate], [createdAt], [updatedAt]) VALUES ('Nationality', 'string', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
INSERT treeRecordDetails ([treeRecordId], [detailTypeId], [valueCol],  [startDate], [createdAt], [updatedAt]) VALUES (1, 2, 'portuguesa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)


-- SELECT * FROM treeRecordDetails
-- SELECT * FROM treeRecordDetailTypes


--WITH treeHierarchy AS (
--    SELECT 
--        t1.treeLevelId AS Nivel1_ID, t1.name AS Nivel1,
--        t2.treeLevelid AS Nivel2_ID, t2.name AS Nivel2,
--        t3.treeLevelid AS Nivel3_ID, t3.name AS Nivel3,
--        t4.treeLevelid AS Nivel4_ID, t4.name AS Nivel4,
--        t5.treeLevelid AS Nivel5_ID, t5.name AS Nivel5,
--        t6.treeLevelid AS Nivel6_ID, t6.name AS Nivel6
--    FROM tree t1
--    LEFT JOIN tree t2 ON t2.parentId = t1.treeRecordid
--    LEFT JOIN tree t3 ON t3.parentId = t2.treeRecordid
--    LEFT JOIN tree t4 ON t4.parentId = t3.treeRecordid
--    LEFT JOIN tree t5 ON t5.parentId = t4.treeRecordid
--    LEFT JOIN tree t6 ON t6.parentId = t5.treeRecordid
--    WHERE t1.treeLevelId = 1
--)

--SELECT 
--    Nivel1 AS Pais, 
--    Nivel2 AS NUTS1, 
--    Nivel3 AS NUTS2, 
--    Nivel4 AS NUTS3, 
--    Nivel5 AS Municipio, 
--    Nivel6 AS Freguesia
--FROM treeHierarchy
--ORDER BY Pais, NUTS1, NUTS2, NUTS3, Municipio, Freguesia;