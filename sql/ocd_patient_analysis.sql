---OCD Patient Clinical Analysis | SQL Server
---Purpose: Profile OCD patients by demographics, diagnosis trend,obsession themes and compulsion behaviors (Y-BOCS scores) 
---Source: dbo.OCD_Patient_Dataset (1,500 patients)

USE OCD_Patients;
GO

---Explore the raw data
SELECT COUNT(*) AS Row_Count FROM dbo.OCD_Patient_Dataset;
SELECT TOP 100 * FROM dbo.OCD_Patient_Dataset;
GO

---Data preparation 
---Convert the diagnosis date to a date type for time-series analysis
ALTER TABLE dbo.OCD_Patient_Dataset
ALTER COLUMN OCD_Diagnosis_Date DATE;
GO

---Q1: What is the gender distribution and average obsession severity by gender?
---Result: Male 753 (50.2%), avg 19.9 | Female 747 (49.8%), avg 20.2
WITH GenderStats AS (
    SELECT Gender,
 COUNT(Patient_ID) AS Patient_Count,
 AVG(CAST(Y_BOCS_Score_Obsessions AS DECIMAL(10,4))) AS Avg_OBS_Score
 FROM dbo.OCD_Patient_Dataset
 GROUP BY Gender)
SELECT Gender,Patient_Count,
CAST(100.0 * Patient_Count / SUM(Patient_Count) OVER () AS DECIMAL(5,1)) AS Percentage,
CAST(Avg_OBS_Score AS DECIMAL(5,1)) AS Avg_OBS_Score
FROM GenderStats
ORDER BY Patient_Count DESC;
GO

---Q2: Which ethnic groups have the most patients, and what is their average obsession severity?
---Result: Caucasian 398 (19.8) | Hispanic 392 (20.3) | Asian 386 (20.3) | African 324 (19.8)
SELECT Ethnicity,
COUNT(Patient_ID) AS Patient_Count,
CAST(AVG(CAST(Y_BOCS_Score_Obsessions AS DECIMAL(10,4))) AS DECIMAL(5,1)) AS Avg_Obsession_Severity
FROM dbo.OCD_Patient_Dataset
GROUP BY Ethnicity
ORDER BY Patient_Count DESC;
GO

---Q3: What is the monthly diagnosis trend? Are new cases increasing or decreasing?
---Result: rose from about 9 cases/month (2013) to a peak of 25 (April 2018),
---then plateaued at 8-21 per month through 2022.
---Note: 2022-11 shows only 2 cases, likely an incomplete month.
SELECT
DATEFROMPARTS(YEAR(OCD_Diagnosis_Date), MONTH(OCD_Diagnosis_Date), 1) AS Diagnosis_Month,
COUNT(Patient_ID) AS Patient_Count
FROM dbo.OCD_Patient_Dataset
GROUP BY DATEFROMPARTS(YEAR(OCD_Diagnosis_Date), MONTH(OCD_Diagnosis_Date), 1)
ORDER BY Diagnosis_Month;
GO

---Q4: Which obsession types are most common, and how severe are they?
---Result: Harm-related 333 (20.7) | Contamination 306 (19.7) | Religious 303 (19.2)
---Symmetry 280 (19.7) | Hoarding 278 (21.0, highest severity)
SELECT Obsession_Type,
COUNT(Patient_ID) AS Patient_Count,
CAST(100.0 * COUNT(Patient_ID) / SUM(COUNT(Patient_ID)) OVER () AS DECIMAL(5,1)) AS Pct_Of_Patients,
CAST(AVG(CAST(Y_BOCS_Score_Obsessions AS DECIMAL(10,4))) AS DECIMAL(5,1)) AS Avg_Obsession_Severity
FROM dbo.OCD_Patient_Dataset
GROUP BY Obsession_Type
ORDER BY Patient_Count DESC;
GO

---Q5: Which compulsion types are most common, and how severe are they?
---Result: Washing 321 (19.6) | Counting 316 (19.7) | Checking 292 (17.9)
---Praying 286 (20.7, highest severity) | Ordering 285 (20.2)
SELECT Compulsion_Type,
 COUNT(Patient_ID) AS Patient_Count,
 CAST(100.0 * COUNT(Patient_ID) / SUM(COUNT(Patient_ID)) OVER () AS DECIMAL(5,1)) AS Pct_Of_Patients,
 CAST(AVG(CAST(Y_BOCS_Score_Compulsions AS DECIMAL(10,4))) AS DECIMAL(5,1)) AS Avg_Compulsion_Severity
FROM dbo.OCD_Patient_Dataset
GROUP BY Compulsion_Type
ORDER BY Patient_Count DESC;
GO