
--SELECT * FROM incidentTypes

INSERT incidentTypes([name], [startDate], [createdAt], [updatedAt]) VALUES ('Sismo', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT incidentTypes([name], [startDate], [createdAt], [updatedAt]) VALUES ('Maremoto', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT incidentTypes([name], [startDate], [createdAt], [updatedAt]) VALUES ('Pandemia', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT incidentTypes([name], [startDate], [createdAt], [updatedAt]) VALUES ('Despejamento', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT incidentTypes([name], [startDate], [createdAt], [updatedAt]) VALUES ('Incêndio', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

--SELECT * FROM incidents

INSERT incidents([incidentTypeId], [startDate], [createdAt], [updatedAt]) VALUES (1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT incidents([incidentTypeId], [startDate], [createdAt], [updatedAt]) VALUES (2, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT incidents([incidentTypeId], [startDate], [createdAt], [updatedAt]) VALUES (3, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT incidents([incidentTypeId], [startDate], [createdAt], [updatedAt]) VALUES (4, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT incidents([incidentTypeId], [startDate], [createdAt], [updatedAt]) VALUES (5, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

--SELECT * FROM incidentZcaps

INSERT incidentZcaps([incidentId], [zcapId], [entityId], [startDate], [createdAt], [updatedAt]) VALUES (1, 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

--SELECT * FROM incidentZcapPersons

INSERT incidentZcapPersons([incidentZcapId], [personId], [startDate], [createdAt], [updatedAt]) VALUES (1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

