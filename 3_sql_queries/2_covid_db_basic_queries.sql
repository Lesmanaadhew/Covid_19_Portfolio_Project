-- COVID-19 PORTFOLIO PROJECT
-- By. LESMANA ADHE WIJAYA


--------------------------------------------------------
----------------------BASIC QUERIES---------------------
--------------------------------------------------------
--------------------DATA EXPLORATION--------------------
--------------------------------------------------------



--------------------CASES QUERIES--------------------


-- total cases (by country)

SELECT country, SUM(new_cases) AS total_cases
FROM cases INNER JOIN country
	ON cases.country_id = country.country_id
GROUP BY country
ORDER BY country;


-- total cases (by continent)

SELECT continent, SUM(new_cases) AS total_cases
FROM cases INNER JOIN country
	ON cases.country_id = country.country_id
	INNER JOIN continent
		ON country.continent_id = continent.continent_id
GROUP BY continent
ORDER BY continent;


-- monthly cases (date only)

SELECT EXTRACT(YEAR FROM date) AS year, EXTRACT(MONTH FROM date) AS month, SUM(new_cases) AS monthly_cases
FROM cases
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
ORDER BY year;

	--or--

SELECT DATE_TRUNC('MONTH', date) AS month_start, SUM(new_cases) AS monthly_cases
FROM cases
GROUP BY DATE_TRUNC('MONTH', date)
ORDER BY month_start ASC;


-- monthly cases (by country)

SELECT country, DATE_TRUNC('MONTH', date) AS date, SUM(new_cases) AS monthly_cases
FROM cases INNER JOIN country
	ON cases.country_id = country.country_id
GROUP BY country, DATE_TRUNC('MONTH', date)
ORDER BY country;


-- monthly cases (by continent)

SELECT continent, DATE_TRUNC('MONTH', date) AS month_start, SUM(new_cases) AS monthly_cases
FROM cases INNER JOIN country
	ON cases.country_id = country.country_id
GROUP BY continent, DATE_TRUNC('MONTH', date)
ORDER BY continent;


-- monthly cases cumulative (date only)

SELECT month_start, SUM(monthly_cases) OVER (ORDER BY month_start) AS monthly_cases_cum
FROM
	(SELECT DATE_TRUNC('MONTH', date) AS month_start, SUM(new_cases) AS monthly_cases
	FROM cases
	GROUP BY DATE_TRUNC('MONTH', date))
ORDER BY month_start;


-- monthly cases cumulative (by country)

SELECT country, month_start, SUM(monthly_cases) OVER (PARTITION BY country ORDER BY month_start) AS monthly_cases_cum
FROM
	(SELECT country, DATE_TRUNC('MONTH', date) AS month_start, SUM(new_cases) AS monthly_cases
	FROM cases INNER JOIN country
		ON cases.country_id = country.country_id
	GROUP BY country, DATE_TRUNC('MONTH', date)
	ORDER BY country)
ORDER BY country, month_start;


-- monthly cases cumulative (by continent)

SELECT continent, month_start, SUM(monthly_cases) OVER (PARTITION BY continent ORDER BY month_start)
FROM
	(SELECT continent, DATE_TRUNC('MONTH', date) AS month_start, SUM(new_cases) AS monthly_cases
	FROM cases INNER JOIN country
		ON cases.country_id = country.country_id
	GROUP BY continent, DATE_TRUNC('MONTH', date)
	ORDER BY continent)
ORDER BY continent;




--------------------DEATHS QUERIES-------------------------


-- total deaths (by country)

SELECT country, SUM(new_deaths) AS total_deaths
FROM deaths INNER JOIN country
	ON deaths.country_id = country.country_id
GROUP BY country
ORDER BY country;


-- total deaths (by continent)

SELECT continent, SUM(new_deaths) AS total_deaths
FROM deaths INNER JOIN country
	ON deaths.country_id = country.country_id
GROUP BY continent
ORDER BY continent;


-- monthly deaths (date only)

SELECT DATE_TRUNC('MONTH', date) AS date, SUM(new_deaths) AS monthly_deaths
FROM deaths
GROUP BY DATE_TRUNC('MONTH', date)
ORDER BY date;


-- monthly deaths (by country)

SELECT country, DATE_TRUNC('MONTH', date) AS date, SUM(new_deaths) AS monthly_deaths
FROM deaths INNER JOIN country
	ON deaths.country_id = country.country_id
GROUP BY country, DATE_TRUNC('MONTH', date)
ORDER BY country;


-- monthly deaths (by continent)

SELECT continent, DATE_TRUNC('MONTH', date) AS month_start, SUM(new_deaths) AS monthly_deaths
FROM deaths INNER JOIN country
		ON country.country_id = deaths.country_id
GROUP BY continent, DATE_TRUNC('MONTH', date)
ORDER BY continent;


-- monthly deaths cumulative (date only)

SELECT month_start, SUM(monthly_deaths) OVER (ORDER BY month_start) monthly_deaths_cum
FROM
	(SELECT DATE_TRUNC('MONTH', date) AS month_start, SUM(new_deaths) AS monthly_deaths
	FROM deaths
	GROUP BY DATE_TRUNC('MONTH', date)
	ORDER BY month_start)
ORDER BY month_start;


-- monthly deaths cumulative (by country)

SELECT country, month_start, SUM(monthly_deaths) OVER (PARTITION BY country ORDER BY month_start)
FROM
	(SELECT country, DATE_TRUNC('MONTH', date) AS month_start, SUM(new_deaths) AS monthly_deaths
	FROM deaths INNER JOIN country
		ON deaths.country_id = country.country_id
	GROUP BY country, DATE_TRUNC('MONTH', date)
	ORDER BY country)
ORDER BY country;




--------------------TESTS QUERIES-------------------------


-- total tests (by country)

SELECT country, SUM(new_tests) AS total_tests
FROM tests INNER JOIN country
	ON tests.country_id = country.country_id
GROUP BY country
ORDER BY country;


-- total tests (by continent)

SELECT continent, SUM(new_tests) AS total_tests
FROM tests INNER JOIN country
	ON tests.country_id = country.country_id
GROUP BY continent
ORDER BY continent;


-- monthly tests (date only)

SELECT DATE_TRUNC('MONTH', date) AS date, SUM(new_tests) AS monthly_tests
FROM tests 
GROUP BY DATE_TRUNC('MONTH', date)
ORDER BY date;


-- monthly tests (by country)

SELECT country, DATE_TRUNC('MONTH', date) AS date, SUM(new_tests) AS monthly_tests
FROM tests INNER JOIN country
	ON tests.country_id = country.country_id
GROUP BY country, DATE_TRUNC('MONTH', date)
ORDER BY country;


-- monthly tests (by continent)

SELECT continent, DATE_TRUNC('MONTH', date) AS month_start, SUM(new_tests) AS monthly_tests
FROM tests INNER JOIN country
	ON tests.country_id = country.country_id
GROUP BY continent, DATE_TRUNC('MONTH', date)
ORDER BY continent;


-- monthly test cumulative (date only)

SELECT month_start, SUM(monthly_test) OVER (ORDER BY month_start)
FROM
	(SELECT DATE_TRUNC('MONTH', date) AS month_start, SUM(new_tests) AS monthly_test
	FROM tests
	GROUP BY DATE_TRUNC('MONTH', date)
	ORDER BY month_start)
ORDER BY month_start;


-- monthly tests cumulative (by country)

SELECT country, month_start, SUM(monthly_tests) OVER (PARTITION BY country ORDER BY month_start)
FROM
	(SELECT country, DATE_TRUNC('MONTH', date) AS month_start, SUM(new_tests) AS monthly_tests
	FROM tests INNER JOIN country
		ON tests.country_id = country.country_id
	GROUP BY country, DATE_TRUNC('MONTH', date)
	ORDER BY country)
ORDER BY country;




--------------------STRINGENCY QUERIES-------------------------


-- average stringency per month (date only)

SELECT DATE_TRUNC('MONTH', date) AS month_start, ROUND(AVG(stringency_index), 2) AS avg_stringency
FROM stringency
GROUP BY DATE_TRUNC('MONTH', date)
ORDER BY month_start;


-- average stringency per month (by country)

SELECT country, DATE_TRUNC('MONTH', date) AS month_start, ROUND(AVG(stringency_index), 2) AS avg_stringency
FROM stringency INNER JOIN country
	ON stringency.country_id = country.country_id
GROUP BY country, DATE_TRUNC('MONTH', date)
ORDER BY country;


-- average stringency per month (by continent)

SELECT continent, DATE_TRUNC('MONTH', date) AS month_start, ROUND(AVG(stringency_index), 2) AS avg_stringency
FROM stringency INNER JOIN country
	ON stringency.country_id = country.country_id
GROUP BY continent, DATE_TRUNC('MONTH', date)
ORDER BY continent;




--------------------VAXES QUERIES--------------------


-- total vaccinations (by country)

SELECT country, SUM(new_vaccinations) AS total_vaccinations
FROM vaxes INNER JOIN country
	ON vaxes.country_id = country.country_id
GROUP BY country
ORDER BY country;


-- total vaccinations (by continent)

SELECT continent, SUM(new_vaccinations) AS total_vaccinations
FROM vaxes INNER JOIN country
	ON vaxes.country_id = country.country_id
GROUP BY continent
ORDER BY continent;


-- monthly vaccinations (date only)

SELECT DATE_TRUNC('MONTH', date) AS month_start, SUM(new_vaccinations) AS monthly_vaxes
FROM vaxes
GROUP BY DATE_TRUNC('MONTH', date)
ORDER BY month_start;


-- monthly vaccinations (by country)

SELECT country, DATE_TRUNC('MONTH', date) AS month_start, SUM(new_vaccinations) AS monthly_vaxes
FROM vaxes INNER JOIN country
	ON vaxes.country_id = country.country_id
GROUP BY country, DATE_TRUNC('MONTH', date)
ORDER BY country;


-- monthly vaccinations (by continent)

SELECT continent, DATE_TRUNC('MONTH', date) AS month_start, SUM(new_vaccinations) AS monthly_vaxes
FROM vaxes INNER JOIN country
	ON vaxes.country_id = country.country_id
GROUP BY continent, DATE_TRUNC('MONTH', date)
ORDER BY continent;


-- monthly vaccinations cumulative (date only)

SELECT month_start, SUM(monthly_vaxes) OVER (ORDER BY month_start) AS monthly_vaxes_cum
FROM
	(SELECT DATE_TRUNC('MONTH', date) AS month_start, SUM(new_vaccinations) AS monthly_vaxes
	FROM vaxes
	GROUP BY DATE_TRUNC('MONTH', date)
	ORDER BY month_start) AS monthly_vaxes
ORDER BY month_start;


-- monthly vaccinations cumulative (by country)

SELECT country, month_start, SUM(monthly_vaxes) OVER (PARTITION BY country ORDER BY month_start) AS monthly_vaxes_cum
FROM
	(SELECT country, DATE_TRUNC('MONTH', date) AS month_start, SUM(new_vaccinations) AS monthly_vaxes
	FROM vaxes INNER JOIN country
		ON vaxes.country_id = country.country_id
	GROUP BY country, DATE_TRUNC('MONTH', date)
	ORDER BY country) AS monthly_vaxes
ORDER BY country;


-- monthly vaccinations cumulative (by continent)

SELECT continent, month_start, SUM(monthly_vaxes) OVER (PARTITION BY continent ORDER BY month_start) AS monthly_vaxes_cum
FROM
	(SELECT continent, DATE_TRUNC('MONTH', date) AS month_start, SUM(new_vaccinations) AS monthly_vaxes
	FROM vaxes INNER JOIN country
		ON vaxes.country_id = country.country_id
	GROUP BY continent, DATE_TRUNC('MONTH', date)
	ORDER BY continent)
ORDER BY continent;


-- people vaxxed cumulative (date only)

SELECT month_start, SUM(max_vaxes) AS people_vaxxed_cum
FROM
	(SELECT country, DATE_TRUNC('MONTH', date) AS month_start, MAX(people_vaccinated) AS max_vaxes
	FROM vaxes INNER JOIN country
		ON vaxes.country_id = country.country_id
	GROUP BY country, DATE_TRUNC('MONTH', date)
	ORDER BY country)
GROUP BY month_start
ORDER BY month_start;


-- people vaxxed cumulative (by country)

SELECT country, DATE_TRUNC('MONTH', date) As month_start, MAX(people_vaccinated) AS people_vaxxed_cum
FROM vaxes INNER JOIN country
	ON vaxes.country_id = country.country_id
GROUP BY country, DATE_TRUNC('MONTH', date)
ORDER BY country;


-- monthly death per case (date only)

SELECT DATE_TRUNC('MONTH', cases.date) AS month_start, SUM(new_cases) AS monthly_cases, SUM(new_deaths) AS monthly_deaths, 
	ROUND((SUM(new_deaths)::float/NULLIF(SUM(new_cases), 0))::numeric, 4) AS monthly_death_per_case
FROM country LEFT JOIN cases
	ON country.country_id = cases.country_id
	LEFT JOIN deaths
		ON country.country_id = deaths.country_id AND cases.date = deaths.date
GROUP BY DATE_TRUNC('MONTH', cases.date)
ORDER BY month_start;


-- monthly death per case (by country)

SELECT country, DATE_TRUNC('MONTH', cases.date) AS month_start, SUM(new_cases) AS monthly_cases, SUM(new_deaths) AS monthly_deaths,
	ROUND((SUM(new_deaths)::float / NULLIF(SUM(new_cases),0))::numeric, 4) AS monthly_death_per_case
FROM country INNER JOIN cases
	ON country.country_id = cases.country_id
	INNER JOIN deaths
		ON country.country_id = deaths.country_id AND cases.date = deaths.date
GROUP BY country, DATE_TRUNC('MONTH', cases.date)
ORDER BY country;


-- people vaccinated per population (by country)

SELECT country, MAX(population) AS population, MAX(people_vaccinated) AS people_vaxxed,
	ROUND((MAX(people_vaccinated)::float/MAX(population))::numeric, 2) AS people_vaxxed_percentage
FROM country INNER JOIN vaxes
	ON country.country_id = vaxes.country_id
GROUP BY country;


-- people vaccinated per population (by continent)

SELECT continent, SUM(population) population, SUM(people_vaxxed) AS people_vaxxed,
	ROUND((SUM(people_vaxxed)::FLOAT / SUM(population))::NUMERIC, 2) AS people_vaxxed_percentage
FROM
	(SELECT country, continent, MAX(population) AS population, MAX(people_vaccinated) AS people_vaxxed
	FROM country INNER JOIN vaxes
		ON country.country_id = vaxes.country_id
	GROUP BY country, continent
	ORDER BY country)
GROUP BY continent
ORDER BY continent;
