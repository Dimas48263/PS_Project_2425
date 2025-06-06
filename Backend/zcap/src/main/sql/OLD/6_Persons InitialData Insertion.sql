-- DATA INSERTION

--/*** START: PERSON DEPENDENCIES (LIST OF DESTINATIONS) ***/

INSERT INTO departureDestination([name], startDate, [createdAt], [updatedAt]) VALUES
('zcap', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('casa de familiares', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('residencia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); 

--/*** END: PERSON DEPENDENCIES ***/

--/*** START: PERSON ***/

INSERT INTO persons([name], age, contact, countryCodeId, placeOfResidence, entryDatetime, [createdAt], [updatedAt]) VALUES 
('Gonçalo', 23, '123456789', 1, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('João', 34, '987654321', 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Matilda', 86, '918273645', 1, 39, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

--/*** END: PERSON ***/

--/*** START: LISTS OF NEEDS ***/

INSERT INTO specialNeeds([name], startDate, [createdAt], [updatedAt]) VALUES 
('gravidez', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('doença', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
('medicamentos', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('outro', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); 

INSERT INTO personSpecialNeeds(personId, specialNeedId, [description], startDate, [createdAt], [updatedAt]) VALUES 
(1, 2, NULL, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), (2, 4, 'perna partida', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO supportNeeded([name], startDate, [createdAt], [updatedAt]) VALUES 
('alojamento', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('comida', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
('vestuário', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('cuidados médicos', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('apoio psicológico', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('procura de familiar', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('outro', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO personSupportNeeded(personId, supportNeededId, [description], startDate, [createdAt], [updatedAt]) VALUES 
(3, 1, NULL,'20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), (3, 2, NULL, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), (1, 2, NULL, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 3, NULL, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); 

--/*** END: LISTS OF NEEDS ***/

--/*** START: RELATIVES ***/

INSERT INTO relationType ([name], startDate, [createdAt], [updatedAt]) VALUES 
('mae', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('pai', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
('filho', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('filha', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('irmão','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('irmã', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
('tio','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('tia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
('primo', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('prima','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
('avô', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('avó', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('neto','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('neta','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
('sobrinho', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('sobrinha', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('cônjuge', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('padrasto', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
('madrasta', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO relation(personId1, personId2, relationTypeId) VALUES
(1, 2, 5)

--/*** END: RELATIVES ***/
