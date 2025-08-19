# COVID-19 PORTFOLIO PROJECT

### _Preview_
![dashboard_excel_covid](https://github.com/user-attachments/assets/3a0ce71b-eda5-41d7-b3d7-8bd3d14e0b5b)


# Introduction
Hi! I am **Lesmana Adhe Wijaya**, a 22-year-old university fresh graduate from Indonesia, currently developing a data analysis skillset.

## Background
This project is a series of data analysis works on COVID-19 database, starting from data cleaning to data visualization. The project mainly explores the health related impacts of COVID-19, such as, number of cases, number of deaths, number of people vaccinated, etc.

### Database Source
The dataset used in this project based on **Our World In Data** COVID-19 dataset that can be accessed in:  

  [COVID-19 COMPACT DATASET](https://catalog.ourworldindata.org/garden/covid/latest/compact/compact.csv)
  or 
  [1_covid_data_raw](https://github.com/Lesmanaadhew/Covid_19_Portfolio_Project/tree/main/1_database_raw) (for the .XLSX version)

### Tools or Softwares
Upon this project I used 3 (three) tools or softwares to analyze the COVID-19 dataset.
1. **Excel**: this software is used for data cleaning and data visualization.
2. **PostgreSQL**: this tool is mainly used for data exploration.
3. **Tableau**: This software is used for data visualization.

### The Questions
For this project, I have several questions regarding COVID-19 that I wanted to answer through my analysis.
1. How many COVID-19 cases were recorded worldwide from 2020 to 2025?
2. How many people were reported died from COVID-19 between 2020 and 2025?
3. How were the COVID-19 fatality rates between 2020 and 2025?
4. How strict the countries were during the COVID-19 pandemic?
5. How many people have been vaccinated worldwide from 2020 to 2025?


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
  
<img width="240" height="207" alt="Example 1" src="https://github.com/user-attachments/assets/01f6b4cc-ed6d-47eb-8389-9fd589673b34" /> 
<img width="240" height="207" alt="Example 2" src="https://github.com/user-attachments/assets/e684fe71-3334-47fe-9792-8ad82dc15d42" />

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
For the SQL database, tables is created based on the categorized columns from the previous process.





