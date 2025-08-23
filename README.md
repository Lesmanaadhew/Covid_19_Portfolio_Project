# COVID-19 PORTFOLIO PROJECT

### _Preview_
_Excel dashboard preview (please kindly wait for the preview to show up):_  
_The Excel dashboard (.XLSX) file can be accessed in [here](https://github.com/Lesmanaadhew/Covid_19_Portfolio_Project/tree/main/4_dashboard/1_excel_dashboard)_
![dashboard_excel_covid](https://github.com/user-attachments/assets/3a0ce71b-eda5-41d7-b3d7-8bd3d14e0b5b)  

_Tableau dashboard preview (please kindly wait for the preview to show up):_  
_The Tableau dashboard (online) can be accessed in [here](https://public.tableau.com/app/profile/lesmana.aw/viz/covid_19_dashboard_17557145588000/COVID-19DASHBOARD)_  
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

### Tools or Software
Upon this project I used 3 (three) tools or software to analyze the COVID-19 dataset.
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
There are some queries that is used to analyze the data based on the questions asked in the introduction. These following queries are highlighted in here because they answered the questions. But there are more data exploration queries from the basic to the advanced queries with a purpose to mimic the real world application. Those complete data exploration queries can be accessed in [here](https://github.com/Lesmanaadhew/Covid_19_Portfolio_Project/tree/main/3_sql_queries)

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
		ROUND((NULLIF(SUM(new_deaths),0)::float / NULLIF(SUM(new_cases),0))::numeric, 4) AS death_per_case
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

#### 4. Stringency
For the next data exploration, I examined how strict each country's policy  was throughout the COVID-19 pandemic. Our Wolrd in Data's COVID-19 dataset has an indicator for a country strictness towards the pandemic called _stringency index_, and is calculated based on 9 (nine) metrics such as school closures; workplace closures; cancellation of public events; restrictions on public gatherings; closures of public transport; stay-at-home requirements; public information campaigns; restrictions on internal movements; and international travel controls.[^1]

[^1]: Max Roser, "What is the COVID-19 Stringency Index?", _Our World in Data_, https://ourworldindata.org/metrics-explained-covid19-stringency-index

 I used the following query to calculate the average stringency for each month from 2020 to 2025:
 ```
SELECT country, DATE_TRUNC('MONTH', date) AS month_start, ROUND(AVG(stringency_index), 2) AS avg_stringency
FROM stringency INNER JOIN country
	ON stringency.country_id = country.country_id
GROUP BY country, DATE_TRUNC('MONTH', date)
ORDER BY country;
```

#### 5. vaxes
There are 3 analyses that I made for this table, the first one is the total COVID-19 vaccinations of each country. This analysis is calculated by accumulating the recorded _new_vaccinations_ data, in which it might be inaccurate because a lot of countries didn't have daily vaccinations recorded. But here is the query that I used:
```
SELECT country, SUM(new_vaccinations) AS total_vaccinations
FROM vaxes INNER JOIN country
	ON vaxes.country_id = country.country_id
GROUP BY country
ORDER BY country;
```

And here is the query for the top 10 countries with the most COVID-19 vaccinations:
```
SELECT country, SUM(new_vaccinations) AS total_vaccinations
FROM vaxes INNER JOIN country
	ON vaxes.country_id = country.country_id
WHERE new_vaccinations IS NOT NULL
GROUP BY country
ORDER BY total_vaccinations DESC
LIMIT 10;
```
  
The result shows that _China_, _India_, and _United States_ are among the top 3 countries with the most vaccinations. The result makes a lot of sense since they are also among the top populated countries worldwide, although China as the second most populated country surpassed India in the total vaccinations by 61 percent.
<img width="1578" height="543" alt="total_vaxes_top10" src="https://github.com/user-attachments/assets/8be90985-d84e-4154-9049-e49cfb93c77a" />

 And it's also the case with the total people vaccinated for each country. I examined the total people vaccinated for each country using the following query, and I purposefully using **MAX(people_vaccinated)** instead of **SUM(people_vaccinated)** because by default the _people_vaccinated_ data is presented in a cumulative manner in the dataset.

 ```
SELECT country, MAX(people_vaccinated) AS people_vaxxed_cum
FROM vaxes INNER JOIN country
	ON vaxes.country_id = country.country_id
GROUP BY country, DATE_TRUNC('MONTH', date)
ORDER BY country;
```

 And here is the query for the top 10:
 ```
SELECT country, MAX(people_vaccinated) AS people_vaxxed_cum
FROM vaxes INNER JOIN country
	ON vaxes.country_id = country.country_id
WHERE people_vaccinated IS NOT NULL
GROUP BY country
ORDER BY people_vaxxed_cum DESC
LIMIT 10;
```
	
 And the result is aligned with the previous analysis (total vaccinations by country). The top 3 countries are still the countries with the most population in the world, that is _China_, _India_, and _United States_, and China also surpassed India in this analysis.
<img width="1578" height="546" alt="total_peoplevaxxed_top10" src="https://github.com/user-attachments/assets/5fa0e36b-400a-491d-b2ad-93056e97f509" />

 	
Because the significant population inequality worldwide, I also analyzed people vaccinated rate for each country relative to its population. Here is the query:
```
SELECT country, MAX(population) AS population, MAX(people_vaccinated) AS people_vaxxed,
	ROUND((MAX(people_vaccinated)::float/MAX(population))::numeric, 2) AS people_vaxxed_percentage
FROM country INNER JOIN vaxes
	ON country.country_id = vaxes.country_id
GROUP BY country;
```

I also examined the top 10 using this query:
```
SELECT country,
	ROUND((MAX(people_vaccinated)::float/MAX(population))::numeric, 2) AS people_vaxxed_percentage
FROM country INNER JOIN vaxes
	ON country.country_id = vaxes.country_id
WHERE people_vaccinated IS NOT NULL
GROUP BY country
ORDER BY people_vaxxed_percentage DESC
LIMIT 10;
```

The result shows that the top 10 countries with the most people vaccinated are not among this analysis.
<img width="1578" height="546" alt="total_peoplevaxxed_percent_top10" src="https://github.com/user-attachments/assets/a5b8635f-7ef8-4f01-9bee-898518cc17ef" />


# Data Visualization
Based on the results of previous data explorations, I created two interactive dashboards to visualize the analysis using Excel and Tableau.

 In general, I use 4 particular chart types, that is:
 1. **Donut chart**
 2. **Map chart**
 3. **Line chart**
 4. **Bar/column chart**

## Excel dashboard
![dashboard_excel_covid](https://github.com/user-attachments/assets/94de4f4f-2f2b-4412-9d20-ac4033d9646f)

 For the Excel version, I created 6 visualizations that are linked to two dropdown lists, and 1 independent visualization.

### 1. Dropdown list
<img width="211" height="115" alt="excel_dropdown" src="https://github.com/user-attachments/assets/e3412a5b-f5d6-4752-9bfe-4d07642567d6" />

To make the dashboard interactive, I use 2 dropdown list in the Excel version.  
  
The upper dropdown list contains 7 types of analysis that can be applied to the charts.  
<img width="232" height="139" alt="excel_dropdown_upper" src="https://github.com/user-attachments/assets/1513db12-9383-4844-90f9-3ca1581f7eff" />
  
The second dropdown list contains a list of countries and an aggregate of all countries called _World_.  
<img width="232" height="147" alt="excel_dropdown_bottom" src="https://github.com/user-attachments/assets/fe33333d-0abb-490a-92f1-6d9706152b5f" />

### 2. Donut chart
<img width="208" height="218" alt="excel_donut_cases" src="https://github.com/user-attachments/assets/dc6f38fc-b4c7-4ead-aa3c-4a82a9308687" />
<img width="204" height="206" alt="excel_donut_deaths" src="https://github.com/user-attachments/assets/76b0e9e7-eb11-4644-a985-f342e6c4cd64" />
<img width="224" height="203" alt="excel_donut_vaxxed" src="https://github.com/user-attachments/assets/5acc5dc9-5dfc-407e-878f-ff1add26b2a7" />

 There are 3 donut charts that serve as KPIs, summarizing the results of three analyses, that is Total Cases, Total Deaths, and People Vaxxed.  
  
The outer layer of each graph represents the top 5 countries in the analysis, while the inner layer shows the aggregate of the data. The outer layer is an independent layer, while the inner layer is linked to the country dropdown list. Thus, the value of the inner layer will change depending on the country selected.  
  
Here is the example if United States is selected:  
<img width="205" height="213" alt="excel_donut_cases_us" src="https://github.com/user-attachments/assets/d9089398-4ea4-4513-a316-5959bcd90cc6" />
<img width="196" height="194" alt="excel_donut_deaths_us" src="https://github.com/user-attachments/assets/f6f7dcfe-078d-4f43-a1c7-adf6fc8a1bdf" />
<img width="220" height="197" alt="excel_donut_vaxxed_us" src="https://github.com/user-attachments/assets/2ff5dca5-c904-4722-b9d6-6b1fc24b0df6" />


### 3. Map Chart
<img width="500" height="320" alt="excel_map" src="https://github.com/user-attachments/assets/bcafc284-5ec6-4982-9a73-5843a6d31f8a" />
  
The next one is a map chart. The chart is linked to the upper dropdown list and its value and caption will change depending on the type selected.  
  
Here is the example if the _deaths_ type is selected:  
<img width="500" height="320" alt="excel_map_deaths" src="https://github.com/user-attachments/assets/22acef49-a27a-4f5a-8404-4b0f9ddb6ec3" />


### 4. Line chart






 
 















