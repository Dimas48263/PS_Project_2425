--SELECT * FROM userDataProfiles
--SELECT * FROM userDataProfileDetails
--SELECT * FROM userProfiles
--SELECT * FROM users

-- DATA INSERTION

INSERT userDataProfiles ([name], startDate, [createdAt], [updatedAt]) VALUES
('*TEST* Lisboa', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT userDataProfileDetails (userDataProfileId, treeRecordId) VALUES
(1, 1), (1, 3)

INSERT userProfiles ([name], startDate, [createdAt], [updatedAt]) VALUES
('admin', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('read-only', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('tecnico','20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('diretor', '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT [dbo].[users] ([userName], [name], [password], [userProfileId], [userDataProfileId], [startDate], [endDate], [createdAt], [updatedAt]) 
VALUES (N'admin', N'Administrator', N'$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 1, 1, CAST(N'2020-01-01' AS Date), NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

INSERT users ([userName], [name], [password], userProfileId, userDataProfileId, startDate, [createdAt], [updatedAt]) VALUES
('dimas02'	, 'Gonçalo'	, '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 1, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('xpto97', 'Antonio', '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 2, 1,'20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('SirP'		, 'Paulo'	, '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 3, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), ('SirDirector', 'Joao', '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 4, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('lalves'	, 'Luis'	, '$2a$10$EHkQyjg3ARUW3ZlgmES7mu7GrNJhkjSZHnuSJkXM7aUPyRsWM3boS', 2, 1, '20200101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)


--SELECT * FROM userDataProfiles
