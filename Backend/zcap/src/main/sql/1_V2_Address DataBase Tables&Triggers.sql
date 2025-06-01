

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
    [updatedAt]		DATETIME NOT NULL
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
    [updatedAt]		DATETIME NOT NULL
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
    [updatedAt]		DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
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
    [updatedAt]		DATETIME NOT NULL
);
	END
GO

/**********************************************************************************************/

--CREATE TRIGGER TR_Validate_Tree_Parent_Insert
--ON tree
--INSTEAD OF INSERT
--AS
--BEGIN
--    -- Verifica se o parent pertence ao nível anterior ao do registo
--    IF (
--		(SELECT treeLevelId FROM inserted) > 1
--		AND  ((SELECT [treeLevelId] FROM inserted) - (SELECT [treeLevelId] FROM tree WHERE [treeRecordId] = (SELECT [parentId] FROM inserted)) != 1 )
--		)
--    BEGIN
--        RAISERROR('O registo associado não pertence ao nível hierarquico correto.', 16, 1);
--        ROLLBACK TRANSACTION;
--        RETURN;
--    END

--    -- Se não houver erro, insere normalmente
--	INSERT INTO tree ([name], [treeLevelId], [parentId], [startDate], [timestamp]) 
--	SELECT  [name], [treeLevelId], [parentId], [startDate], CURRENT_TIMESTAMP FROM inserted
--END;
--GO