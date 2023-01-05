
-- Subjects
INSERT INTO subject
VALUES (NULL, 'SQL');

INSERT INTO subject (label)
VALUES ('GIT');

-- Cities
INSERT INTO city
VALUES (NULL, 'Clermont-Ferrand', '63000');

INSERT INTO city
VALUES (NULL, 'Clermont-Ferrand', '63100');

-- Addresses
INSERT INTO address
VALUES (
	NULL,
	1,
	'14 rue Molière',
	NULL
);

INSERT INTO address
VALUES (
	NULL,
	1,
	'22 allée Allan Turing',
	'Bât. Turing 22'
);


-- Campus
INSERT INTO campus
VALUES (
	NULL,
	2
	'IPME Clermont-Ferrand'
);


-- Class
-- id	campus_id	name	description	begin_year	end_year
INSERT INTO `class`
VALUES (
	NULL,
	1,
	'POEC DevOps',
	'POEC DevOps',
	2022,
	2023
);

-- Student
INSERT INTO `student`
VALUES (
    NULL,
    2,
    1,
    'DUBOIS',
    'Marc',
    'mdubois@ipme.com',
    '@toto#dubois',
    '1998-06-06',
    '0698754123',
    'H'
);

-- Rank
INSERT INTO rank
VALUES (
  	NULL,
    1,
    1,
    14.0
);



