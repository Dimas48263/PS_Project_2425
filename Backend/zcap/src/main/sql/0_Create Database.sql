USE [master]
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'ZCAPNET')
BEGIN
    CREATE DATABASE ZCAPNET;
    PRINT 'Base de dados ZCAPNET criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'A base de dados ZCAPNET já existe.';
END;
GO

USE ZCAPNET
GO