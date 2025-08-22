# COVID-19 PORTFOLIO PROJECT

### _Preview_
_Excel dashboard preview (please wait):_  
_Insert Excel link_  
![dashboard_excel_covid](https://github.com/user-attachments/assets/3a0ce71b-eda5-41d7-b3d7-8bd3d14e0b5b)  

_Tableau dashboard preview (please wait):_  
_Insert Tableau link_  
![dashboard_tableau_covid](https://github.com/user-attachments/assets/2631abe2-366a-4ee8-9612-4eca2d4ecd9b)


# Introduction
Hi! I am **Lesmana Adhe Wijaya**, a 22-year-old university fresh graduate from Indonesia, currently developing a data analysis skillset.

## Background
This project is a series of data analysis works on COVID-19 database, starting from data cleaning to data visualization. The project mainly explores the health related impacts of COVID-19, such as, number of cases, number of deaths, number of people vaccinated, etc.

### Database Source
Dataset used in this project based on **Our World In Data** COVID-19 dataset that can be accessed in:  

  [COVID-19 COMPACT DATASET](https://catalog.ourworldindata.org/garden/covid/latest/compact/compact.csv)
  or 
  [1_database_raw](https://github.com/Lesmanaadhew/Covid_19_Portfolio_Project/tree/main/1_database_raw) (for the .XLSX version)

### Tools or Softwares
Upon this project I used 3 (three) tools or softwares to analyze the COVID-19 dataset.
1. **Excel**: this software is used for data cleaning and data visualization.
2. **PostgreSQL**: this tool is mainly used for data exploration.
3. **Tableau**: This software is used for data visualization.

### The Questions
For this project, I have several questions regarding COVID-19 that I wanted to answer through my analysis.
1. _How many COVID-19 cases were recorded worldwide from 2020 to 2025?_
2. _How many people were reported died from COVID-19 between 2020 and 2025?_
3. _How were the COVID-19 fatality rates between 2020 and 2025?_
4. _How strict the countries were during the COVID-19 pandemic?_
5. _How many people have been vaccinated worldwide from 2020 to 2025?_


# Data Cleaning Process
In this project I used **Ms. Excel** to perform data cleaning process. To transform the dataset I used a built-in ETL (extract, transform, load) tool in Ms. Excel called _Power Query_.

### Removes unnecessary columns
The work to do in the data cleaning process is to remove columns that don't relate to the questions asked in the introduction.
The initial dataset of Our World In Data COVID-19 dataset contained 61 columns before cleaned into 15 potential and necessary columns.  

The following is the list of columns that being kept:
1. country
2. date
3. new_cases
4. new_deaths
5. stringency_index
6. new_tests
7. people_vaccinated
8. new_vaccinations
9. code
10. continent	population
11. population_density
12. median_age
13. gdp_per_capita
14. extreme_poverty

I also added a new column, _country_id_, that can be convenient for the data exploration process using SQL.

### Removes unwanted rows
The initial dataset also contained rows with unwanted _country_ values, such as cumulative of continents, Olympics, low and high-income countries, and world.  
  
  _Examples:_
  
<img width="360" height="312" alt="Example 1" src="https://github.com/user-attachments/assets/01f6b4cc-ed6d-47eb-8389-9fd589673b34" /> 
<img width="360" height="312" alt="Example 2" src="https://github.com/user-attachments/assets/e684fe71-3334-47fe-9792-8ad82dc15d42" />

### Fixes data types
For the excel visualization, I fixed some of the numeric data types because the initial dataset was formated as .csv and it had some unmatched and unrecognized numeric data types in Excel. The unrecogized numeric data types should be fixed because it couldn't be calculated in Excel for further analysis.

### Categorizes columns
For the SQL data exploration, before I imported the dataset into the PostgreSQL database, I categorized the columns into 6 tables, that is:
1. **country** (contains: country_id,	country,	code,	continent,	population,	population_density,	median_age,	gdp_per_capita,	extreme_poverty)
2. **cases** (contains: country_id,	date,	new_cases)
3. **deaths** (contains: country_id, date,	new_deaths)
4. **tests** (contains: country_id,	date,	new_tests)
5. **stringency** (contains: country_id, date,	stringency_index)
6. **vaxes** (contains: country_id,	date,	new_vaccinations, people_vaccinated)


# Data Exploration

## PostgreSQL Data Exploration
### Table Creation
For the SQL database, tables are created based on the categorized columns from the previous process. The following is the list of the tables and their queries:
1. **country**
```
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
```
2. **cases**
```
CREATE TABLE cases
(
	country_id INT REFERENCES country(country_id) NOT NULL,
	date DATE NOT NULL,
	new_cases INT
);
```
3. **deaths**
```
CREATE TABLE deaths
(
	country_id INT REFERENCES country(country_id) NOT NULL,
	date DATE NOT NULL,
	new_deaths INT
);
```
4. **tests**
```
CREATE TABLE tests
(
	country_id INT REFERENCES country(country_id) NOT NULL,
	date DATE NOT NULL,
	new_tests INT
);
```
5. **stringency**
```
CREATE TABLE stringency
(
	country_id INT REFERENCES country(country_id) NOT NULL,
	date DATE NOT NULL,
	stringency_index NUMERIC(5,2)
);
```
6. **vaxes**
```
CREATE TABLE vaxes
(
	country_id INT REFERENCES country(country_id) NOT NULL,
	date DATE NOT NULL,
	new_vaccinations BIGINT,
	people_vaccinated BIGINT
);
```

### Data exploration
There are some queries that is used to analyze the data based on the questions asked in the introduction.
#### 1. cases	
For the first data exploration of this table, I analyzed total cases by country using the following query:
 ```
SELECT country, SUM(new_cases) AS total_cases
FROM cases INNER JOIN country
	ON cases.country_id = country.country_id
GROUP BY country
ORDER BY country;
```
 
 I also tried to find the top 10 countries with the most recorded COVID-19 cases using some little modifications of the previous query:
 ```
SELECT country, SUM(new_cases) AS total_cases
FROM cases INNER JOIN country
	ON cases.country_id = country.country_id
WHERE new_cases IS NOT NULL
GROUP BY country
ORDER BY total_cases
LIMIT 10;
```
   
 Then I made a raw-visualization using PG Admin built-in data visualizer so I could understand the statistics better. It shows that _United States_ has the highest recorded COVID-19 cases worldwide with over 100 million, followed by _China_ that almost surpassed 100 million cases. Both of those countries have significant cases gaps compared to the third position that is _India_ with only around 40 million cases recorded.
 <img width="1578" height="635" alt="total_cases_top10" src="https://github.com/user-attachments/assets/b2feae65-69fc-4baa-ad9a-5eebc3dff611" />
  
 For the next stage, I seek to examine the distribution of COVID-19 cases for each month throughout the COVID-19 pandemic using the following query.
```
SELECT country, DATE_TRUNC('MONTH', date) AS date, SUM(new_cases) AS monthly_cases
FROM cases INNER JOIN country
	ON cases.country_id = country.country_id
GROUP BY country, DATE_TRUNC('MONTH', date)
ORDER BY country;
```  

#### 2. deaths
For this table, I analyzed the data using a similar approach to the previous one: first, I calculated the total COVID-19 deaths by country, and then I identified the top 10 countries.	
Here is the first query:
```
SELECT country, SUM(new_deaths) AS total_deaths
FROM deaths INNER JOIN country
	ON deaths.country_id = country.country_id
GROUP BY country
ORDER BY country;
```

Then here is the top 10 countries with the most recorded COVID-19 deaths:
```
SELECT country, SUM(new_deaths) AS total_deaths
FROM deaths INNER JOIN country
	ON deaths.country_id = country.country_id
WHERE new_deaths IS NOT NULL
GROUP BY country
ORDER BY total_deaths
LIMIT 10;
```

 I also visualize it using PG Admin. The data shows that _United States_ is once again the country with the most COVID-19 deaths with 1.2 million people died from COVID-19. The second most COVID-19 deaths is held by Brazil with around 700 thousand deaths.
 <img width="1578" height="635" alt="total_deaths_top10" src="https://github.com/user-attachments/assets/4d78e490-27e5-49bf-b8dc-3bef42b49388" />

 Similar to the previous table, I also analyzed COVID-19 deaths by date from 2020 to 2025 using this query:
 ```
SELECT country, DATE_TRUNC('MONTH', date) AS date, SUM(new_deaths) AS monthly_deaths
FROM deaths INNER JOIN country
	ON deaths.country_id = country.country_id
GROUP BY country, DATE_TRUNC('MONTH', date)
ORDER BY country;
```

#### 3. Fatality rate
Using both _cases_ and _deaths_ tables, I can calculate the fatality rate of COVID-19. In the following query I divided _death_ with _cases_ to calculate the fatality rate:
```
SELECT country,
	ROUND((SUM(new_deaths)::float / NULLIF(SUM(new_cases),0))::numeric, 4) AS death_per_case
FROM country INNER JOIN cases
	ON country.country_id = cases.country_id
	INNER JOIN deaths
		ON country.country_id = deaths.country_id AND cases.date = deaths.date
GROUP BY country
ORDER BY country;
```

I also identified the top 10 countries with the most COVID-19 fatality rate:
```
SELECT country, death_per_case
FROM(
	SELECT country,
		NULLIF(ROUND((NULLIF(SUM(new_deaths),0)::float / NULLIF(SUM(new_cases),0))::numeric, 4),1) AS death_per_case
	FROM country INNER JOIN cases
		ON country.country_id = cases.country_id
		INNER JOIN deaths
			ON country.country_id = deaths.country_id AND cases.date = deaths.date
	GROUP BY country
	ORDER BY death_per_case DESC)
WHERE death_per_case IS NOT NULL
LIMIT 10;
```

 The result shows that _Yemen_ is the country with the highest fatality rate, that is 18 percent. The second place is held by _Sudan_ and is significantly lower than _Yemen_ by 55 percent that is 7.9 percent fatality rate.
<img width="1578" height="637" alt="total_deathpercase_top10" src="https://github.com/user-attachments/assets/b55e1499-0dce-42f8-855c-49e2c9d391a3" />

  I also examined how the fatality rate changed throughout the COVID-19 pandemic. For the examination I used the following query:
  ```
SELECT country, DATE_TRUNC('MONTH', cases.date) AS month_start, SUM(new_cases) AS monthly_cases, SUM(new_deaths) AS monthly_deaths,
	ROUND((SUM(new_deaths)::float / NULLIF(SUM(new_cases),0))::numeric, 4) AS monthly_death_per_case
FROM country INNER JOIN cases
	ON country.country_id = cases.country_id
	INNER JOIN deaths
		ON country.country_id = deaths.country_id AND cases.date = deaths.date
GROUP BY country, DATE_TRUNC('MONTH', cases.date)
ORDER BY country;
```

#### 4. Stringency index










These queries are highlighted in here because they answered the questions. But there are more data exploration queries from the basic to the advanced queries with a purpose to mimic the real world application. Those complete data exploration queries can be accessed in **_(insert link)_**
