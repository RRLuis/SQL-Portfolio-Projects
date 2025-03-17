# Happiness Index (2018-2019) Data Exploration in SQL
## Overview

This project focuses on performing an exploratory data analysis (EDA) on the Happiness Index (2018-2019) dataset using SQL. The dataset, sourced from Kaggle, contains metrics related to happiness scores and factors influencing happiness across different countries for the years 2018 and 2019.

The goal of this project is to explore the dataset, uncover trends, and derive insights using SQL queries. The analysis includes examining happiness scores, regional comparisons, and the impact of various factors such as GDP per capita, social support, life expectancy, freedom, generosity, and corruption on happiness.
Dataset Description

The dataset consists of two main tables:

    2018 Happiness Index: Contains data for the year 2018.

    2019 Happiness Index: Contains data for the year 2019.

Each table includes the following columns:

    Overall rank: Rank of the country based on the happiness score.

    Country or region: Name of the country or region.

    Score: Happiness score.

    GDP per capita: Contribution of GDP per capita to the happiness score.

    Social support: Contribution of social support to the happiness score.

    Healthy life expectancy: Contribution of life expectancy to the happiness score.

    Freedom to make life choices: Contribution of freedom to the happiness score.

    Generosity: Contribution of generosity to the happiness score.

    Perceptions of corruption: Contribution of corruption perception to the happiness score.

## SQL Queries

The SQL queries used for the analysis are stored in the Happiness_Exploration.sql file. These queries include:

    Basic data exploration (e.g., counting rows, checking for missing values).

    Comparison of happiness scores between 2018 and 2019.

    Analysis of regional trends in happiness scores.

    Correlation analysis between happiness scores and contributing factors.

    Identification of top and bottom-performing countries in terms of happiness.

## How to Use

    Download the Dataset: Download the dataset from Kaggle (data source: https://www.kaggle.com/datasets/sougatapramanick/happiness-index-2018-2019)

    Set Up the Database: Import the dataset into your preferred SQL database (e.g., MySQL, PostgreSQL, SQLite).

    Run the Queries: Execute the SQL queries from the happiness_index_analysis.sql file to reproduce the analysis.

    Explore Insights: Use the results of the queries to understand trends and patterns in the data.

## Key Insights

    Country with the biggest improvement in happiness score from 2018 to 2019.

    Ranking of countries according to their happiness score in 2018, considering categories based on intervals.

    Bottom 5 Least Happy Countries (2019)

    Regional Comparison

## Tools Used

    SQL: For data exploration and analysis.

    Database Management System: PostgreSQL.
