-- 	COVID-19 PORTFOLIO PROJECT
--	By. LESMANA ADHE WIJAYA

------------------------------------------------------
--------------------TABLE CREATION--------------------
------------------------------------------------------



-- country

CREATE TABLE country
(
	country_id SERIAL PRIMARY KEY NOT NULL,
	country VARCHAR(32) NOT NULL,
	code CHAR(3) NOT NULL,
	continent VARCHAR(13) NOT NULL,
	population INT,
	population_density NUMERIC(7,2),
	median_age NUMERIC(4,2),
	gdp_per_capita NUMERIC(8,2),
	extreme_poverty NUMERIC(4,2)
);

SELECT *
FROM country;


-- cases

CREATE TABLE cases
(
	country_id INT REFERENCES country(country_id) NOT NULL,
	date DATE NOT NULL,
	new_cases INT
);

SELECT *
FROM cases;


-- deaths

CREATE TABLE deaths
(
	country_id INT REFERENCES country(country_id) NOT NULL,
	date DATE NOT NULL,
	new_deaths INT
);

SELECT *
FROM deaths;


-- tests

CREATE TABLE tests
(
	country_id INT REFERENCES country(country_id) NOT NULL,
	date DATE NOT NULL,
	new_tests INT
);

SELECT *
FROM tests;


-- stringency

CREATE TABLE stringency
(
	country_id INT REFERENCES country(country_id) NOT NULL,
	date DATE NOT NULL,
	stringency_index NUMERIC(5,2)
);

SELECT *
FROM stringency;


-- vaxes

CREATE TABLE vaxes
(
	country_id INT REFERENCES country(country_id) NOT NULL,
	date DATE NOT NULL,
	new_vaccinations BIGINT,
	people_vaccinated BIGINT
);

SELECT *
FROM vaxes;


