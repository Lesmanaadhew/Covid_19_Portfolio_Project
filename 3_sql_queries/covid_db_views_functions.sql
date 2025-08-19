-- COVID-19 PORTFOLIO PROJECT
-- By. LESMANA ADHE WIJAYA



-------------------------VIEWS-------------------------


-- full monthly report (by country)

CREATE OR REPLACE VIEW v_full_monthly_report AS
SELECT c.country, c.continent, MAX(c.population) AS population, DATE_TRUNC('MONTH', ca.date)::DATE AS month_start, 
		SUM(ca.new_cases) AS monthly_cases, SUM(de.new_deaths) AS monthly_deaths, 
		(SUM(de.new_deaths)::float / NULLIF(SUM(new_cases),0))::numeric AS death_per_cases, 
		SUM(te.new_tests) AS monthly_tests, AVG(st.stringency_index)/100 AS avg_stringency, 
		SUM(new_vaccinations)::BIGINT AS monthly_vaxes, MAX(va.people_vaccinated) AS people_vaxxed_cum, 
		(MAX(va.people_vaccinated)::float / NULLIF(MAX(c.population),0))::numeric AS people_vaxxed_per_population
FROM country AS c LEFT JOIN cases AS ca
	ON c.country_id = ca.country_id
	LEFT JOIN deaths AS de
		ON c.country_id = de.country_id AND ca.date = de.date
		LEFT JOIN tests AS te
			ON c.country_id = te.country_id AND ca.date = te.date
			LEFT JOIN stringency AS st
				ON c.country_id = st.country_id AND ca.date = st.date
				LEFT JOIN vaxes AS va
					ON c.country_id = va.country_id AND ca.date = va.date
GROUP BY country, continent, DATE_TRUNC('MONTH', ca.date)
ORDER BY country, month_start;

SELECT *
FROM v_full_monthly_report;


-- 

CREATE OR REPLACE VIEW v_full_monthly_report_continent AS
SELECT c.continent, MAX(c.population) AS population, DATE_TRUNC('MONTH', ca.date)::DATE AS month_start, 
		SUM(ca.new_cases) AS monthly_cases, SUM(de.new_deaths) AS monthly_deaths, 
		(SUM(de.new_deaths)::float / NULLIF(SUM(new_cases),0))::numeric AS death_per_cases, 
		SUM(te.new_tests) AS monthly_tests, AVG(st.stringency_index)/100 AS avg_stringency, 
		SUM(new_vaccinations)::BIGINT AS monthly_vaxes, MAX(va.people_vaccinated) AS people_vaxxed_cum, 
		(MAX(va.people_vaccinated)::float / NULLIF(MAX(c.population),0))::numeric AS people_vaxxed_per_population
FROM country AS c LEFT JOIN cases AS ca
	ON c.country_id = ca.country_id
	LEFT JOIN deaths AS de
		ON c.country_id = de.country_id AND ca.date = de.date
		LEFT JOIN tests AS te
			ON c.country_id = te.country_id AND ca.date = te.date
			LEFT JOIN stringency AS st
				ON c.country_id = st.country_id AND ca.date = st.date
				LEFT JOIN vaxes AS va
					ON c.country_id = va.country_id AND ca.date = va.date
GROUP BY c.continent, DATE_TRUNC('MONTH', ca.date)
ORDER BY c.continent, month_start;

SELECT *
FROM v_full_monthly_report_continent;


-- people vaccinated per month cumulative

CREATE OR REPLACE VIEW v_people_vaxxed AS
SELECT country, DATE_TRUNC('MONTH', date)::DATE AS month_start, MAX(people_vaccinated) AS people_vaxxed
FROM country LEFT JOIN vaxes
	ON country.country_id = vaxes.country_id
GROUP BY country, DATE_TRUNC('MONTH', date)
ORDER BY country, month_start;




-------------------------FUNCTIONS-------------------------


-- top 10 total cases by country

CREATE OR REPLACE FUNCTION fn_get_total_cases_top(row_limit INT)
RETURNS TABLE (country VARCHAR, total_cases BIGINT)
AS
$body$
BEGIN
	RETURN QUERY
		SELECT v.country, SUM(v.monthly_cases)::BIGINT AS total_cases
		FROM v_full_monthly_report AS v
		WHERE v.monthly_cases IS NOT NULL
		GROUP BY v.country
		ORDER BY total_cases DESC
		LIMIT row_limit;
END;
$body$
LANGUAGE PLPGSQL;

SELECT (fn_get_total_cases_top(5)).*


-- top 10 total deaths by country

CREATE OR REPLACE FUNCTION fn_get_total_deaths_top(row_limit INT)
RETURNS TABLE (country VARCHAR, total_deaths BIGINT)
AS
$body$
BEGIN
	RETURN QUERY
		SELECT v.country, SUM(v.monthly_deaths)::BIGINT AS total_deaths
		FROM v_full_monthly_report AS v
		WHERE v.monthly_deaths IS NOT NULL
		GROUP BY v.country
		ORDER BY total_deaths DESC
		LIMIT row_limit;
END;
$body$
LANGUAGE PLPGSQL;

SELECT (fn_get_total_deaths_top(5)).*


-- top 10 people vaxxed rate by country

CREATE OR REPLACE FUNCTION fn_get_people_vaxxed_rate_top(row_limit INT)
RETURNS TABLE (country VARCHAR, people_vaxxed_per_population NUMERIC)
AS
$body$
BEGIN
	RETURN QUERY
		SELECT v.country, ROUND(MAX(v.people_vaxxed_per_population),4) AS people_vaxxed_rate
		FROM v_full_monthly_report AS v
		WHERE v.people_vaxxed_per_population IS NOT NULL
		GROUP BY v.country
		ORDER BY people_vaxxed_rate DESC
		LIMIT row_limit;
END;
$body$
LANGUAGE PLPGSQL;

SELECT (fn_get_people_vaxxed_rate_top(20)).*


-- top cases by date

CREATE OR REPLACE FUNCTION fn_get_cases_by_date_top(row_limit INT)
RETURNS TABLE (month_start DATE, monthly_cases BIGINT)
AS
$body$
BEGIN
	RETURN QUERY
	SELECT v.month_start, SUM(v.monthly_cases)::BIGINT AS monthly_cases
	FROM v_full_monthly_report AS v
	GROUP BY v.month_start
	ORDER BY monthly_cases DESC
	LIMIT row_limit;
END;
$body$
LANGUAGE PLPGSQL;

SELECT (fn_get_cases_by_date_top(10)).*


-- top deaths by date

CREATE OR REPLACE FUNCTION fn_get_deaths_by_date_top(row_limit INT)
RETURNS TABLE (month_start DATE, monthly_deaths BIGINT)
AS
$body$
BEGIN
	RETURN QUERY
	SELECT v.month_start, SUM(v.monthly_deaths)::BIGINT AS monthly_deaths
	FROM v_full_monthly_report AS v
	GROUP BY v.month_start
	ORDER BY monthly_deaths DESC
	LIMIT row_limit;
END;
$body$
LANGUAGE PLPGSQL;

SELECT (fn_get_deaths_by_date_top(10)).*


-- monthly report by country

CREATE OR REPLACE FUNCTION fn_get_monthly_report_by_country(country_name VARCHAR)
RETURNS TABLE (country VARCHAR, continent VARCHAR,population INT,month_start DATE, monthly_cases BIGINT, monthly_deaths BIGINT, 
				death_per_case NUMERIC,	monthly_tests BIGINT, avg_stringency NUMERIC, monthly_vaxes BIGINT, people_vaxxed_cum BIGINT,
				people_vaxxed_per_population NUMERIC)
AS
$body$
BEGIN
	RETURN QUERY
		SELECT *
		FROM v_full_monthly_report AS v
		WHERE v.country = country_name;
END
$body$
LANGUAGE PLPGSQL;

SELECT (fn_get_monthly_report_by_country('Indonesia')).*


-- fixed people vaccinated cumulative (by date)

CREATE OR REPLACE FUNCTION fn_fx_people_vaxxed_date()
RETURNS TABLE (month_start DATE, people_vaxxed BIGINT)
AS
$body$
DECLARE
	rec_vax RECORD;
	last_vax BIGINT;
BEGIN
	FOR rec_vax IN
		SELECT pv.month_start AS month_start, SUM(pv.people_vaxxed) AS people_vaxxed
		FROM v_people_vaxxed AS pv
		GROUP BY pv.month_start
		ORDER BY month_start
	LOOP
		month_start := rec_vax.month_start;
		IF rec_vax.people_vaxxed IS NOT NULL THEN
			last_vax := rec_vax.people_vaxxed;
			people_vaxxed := rec_vax.people_vaxxed;
		ELSE
			rec_vax.people_vaxxed := last_vax;
		END IF;
		RETURN NEXT;
	END LOOP;
END;
$body$
LANGUAGE PLPGSQL;

SELECT (fn_fx_people_vaxxed_date()).*


-- fixed people vaccinated cumulative (by country)

CREATE OR REPLACE FUNCTION fn_fx_people_vaxxed_country()
RETURNS TABLE (country VARCHAR, month_start DATE, people_vaxxed BIGINT)
AS
$body$
DECLARE
	rec_vax RECORD;
	last_vax BIGINT := NULL;
	last_country VARCHAR := NULL;
BEGIN
	FOR rec_vax IN
		SELECT *
		FROM v_people_vaxxed
	LOOP
		IF rec_vax.country IS DISTINCT FROM last_country THEN
			last_vax := NULL;
			last_country := rec_vax.country;
		END IF;

		country := rec_vax.country;
		month_start = rec_vax.month_start;

		IF rec_vax.people_vaxxed IS NOT NULL THEN
			last_vax := rec_vax.people_vaxxed;
			people_vaxxed := rec_vax.people_vaxxed;
		ELSE
			people_vaxxed := last_vax;
		END IF;
		RETURN NEXT;
	END LOOP;
END;
$body$
LANGUAGE PLPGSQL;

SELECT (fn_fx_people_vaxxed_country()).*



-------------------------TRIGGER-------------------------


-- notice when the table is updated or inserted


CREATE OR REPLACE FUNCTION fn_tr_update_notice()
RETURNS TRIGGER
AS
$body$
DECLARE
	row_data TEXT;
BEGIN
	row_data := row_to_json(NEW)::TEXT;
	IF TG_OP = 'INSERT' THEN
		RAISE NOTICE 'Insert into (%): %', TG_TABLE_NAME, row_data;
	ELSEIF TG_OP = 'UPDATE' THEN
		RAISE NOTICE 'Update table (%): %', TG_TABLE_NAME, row_data;
	END IF;
	RETURN NEW;
END;
$body$
LANGUAGE PLPGSQL;

	-- for cases

CREATE TRIGGER tr_update_insert_notice
AFTER INSERT OR UPDATE ON cases
FOR EACH ROW
EXECUTE FUNCTION fn_tr_update_notice();

	-- for deaths

CREATE TRIGGER tr_update_insert_notice
AFTER INSERT OR UPDATE ON deaths
FOR EACH ROW
EXECUTE FUNCTION fn_tr_update_notice();

	-- for tests

CREATE TRIGGER tr_update_insert_notice
AFTER INSERT OR UPDATE ON tests
FOR EACH ROW
EXECUTE FUNCTION fn_tr_update_notice();

	-- for stringency

CREATE TRIGGER tr_update_insert_notice
AFTER INSERT OR UPDATE ON stringency
FOR EACH ROW
EXECUTE FUNCTION fn_tr_update_notice();

	-- for vaxes

CREATE TRIGGER tr_update_insert_notice
AFTER INSERT OR UPDATE ON vaxes
FOR EACH ROW
EXECUTE FUNCTION fn_tr_update_notice();

	-- for country

CREATE TRIGGER tr_update_insert_notice
AFTER INSERT OR UPDATE ON country
FOR EACH ROW
EXECUTE FUNCTION fn_tr_update_notice();


-- trigger to block the same id and date to be inserted into a table

CREATE OR REPLACE FUNCTION fn_tr_date_exists_check()
RETURNS TRIGGER
AS
$body$
BEGIN
	IF EXISTS (
		SELECT 1 FROM cases
		WHERE country_id = NEW.country_id AND date = NEW.date
		) THEN
			RAISE EXCEPTION 'Date (%) for country_id (%) already exists in table (%)', NEW.date, NEW.country_id, TG_TABLE_NAME;
	END IF;
	RETURN NEW;
END;
$body$
LANGUAGE PLPGSQL;

	-- for cases

CREATE TRIGGER tr_date_exists_check
BEFORE INSERT ON cases
FOR EACH ROW
EXECUTE FUNCTION fn_tr_date_exists_check();

	-- for deaths

CREATE TRIGGER tr_date_exists_check
BEFORE INSERT ON deaths
FOR EACH ROW
EXECUTE FUNCTION fn_tr_date_exists_check();

	-- for tests

CREATE TRIGGER tr_date_exists_check
BEFORE INSERT ON tests
FOR EACH ROW
EXECUTE FUNCTION fn_tr_date_exists_check();

	-- for stringency

CREATE TRIGGER tr_date_exists_check
BEFORE INSERT ON stringency
FOR EACH ROW
EXECUTE FUNCTION fn_tr_date_exists_check();

	-- for vaxes

CREATE TRIGGER tr_date_exists_check
BEFORE INSERT ON vaxes
FOR EACH ROW
EXECUTE FUNCTION fn_tr_date_exists_check();

	-- for country

CREATE TRIGGER tr_date_exists_check
BEFORE INSERT ON country
FOR EACH ROW
EXECUTE FUNCTION fn_tr_date_exists_check();


