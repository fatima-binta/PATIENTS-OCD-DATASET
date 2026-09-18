USE OCD_Patients;
Go

--- Quick look at the raw data
SELECT TOP 100 * FROM dbo.OCD_Patient_Dataset;


---Q1: WHAT IS THE GENDER DISTRIBUTION OF OCD PATIENT VOLUME, AND AVERAGE SYMPTOM SEVERITY BY GENDER?
WITH GenderStats AS (
SELECT
Gender,
COUNT(Patient_ID) AS Patient_Count,
AVG(CAST(Y_BOCS_Score_Obsessions AS DECIMAL(10,4))) AS Avg_OBS_Score
FROM dbo.OCD_Patient_Dataset
GROUP BY Gender
)
SELECT
Gender,
Patient_Count,
CAST(100.0 * Patient_Count / SUM(Patient_Count) OVER () AS DECIMAL(5,1)) AS Percentage,
CAST(Avg_OBS_Score AS DECIMAL(5,1)) AS Avg_OBS_Score
FROM GenderStats
ORDER BY Patient_Count DESC;
--- the gender distribution for male is 753 patients,50.2% cohort. and avg obs score is 19.9.
--- for the female is 747 patients,49.8% of cohort.avg obs score is 20.2

---Q2 WHICH ETHNIC GROUPS HAVE THE HIGHEST OCD PREVALANCE AND AVERAGE SYMPTOM SEVERITY?
SELECT 
Ethnicity,
COUNT(Patient_ID) AS Patient_Count,
CAST(AVG(CAST (Y_BOCS_Score_Obsessions AS DECIMAL(10,4))) AS DECIMAL(5,1)) AS AVG_Obsession_severity
FROM dbo.OCD_Patient_Dataset
GROUP BY Ethnicity
ORDER BY Patient_Count DESC;
--- the enithnic groups with the highest ocd are Caucasian,at 398,avg at 19.8,Hispanic,at 392,avg at 20.3,
--- Asian,at 386,avg at 20.3, AND African, at 324,vg at 19.8

---Q3 WHAT IS OUR MONTHLY OCD DIAGNOSIS TREND? ARE WE SEEING AN INCREASE OR DECREASE IN NEW CASES?
alter table dbo.OCD_Patient_Dataset
alter column OCD_diagnosis_date date;

SELECT
FORMAT(OCD_diagnosis_date, 'yyyy-MM') AS Diagnosis_Month,
COUNT(Patient_ID) AS Patient_Count
FROM dbo.OCD_Patient_Dataset
GROUP BY FORMAT(OCD_diagnosis_date, 'yyyy-MM')
ORDER BY Diagnosis_Month;
---the monthly OCD diagnosis trend shows a steady increase from 2013 to 2018 
---(rising from 9 cases/month to a peak of 25 in April 2018), followed by a 
---plateau from 2019-2022 with counts fluctuating between 8-21 per month rather 
---than continuing to climb. note: 2022-11 shows only 2 cases, likely an 
---incomplete month rather than a real decline.

---Q4 WHAT ARE THE COMMON OBSESSIONS TYPE,MOST PREVALANT OBESSION THEMES,AND WHAT IS THEIR AVERAGE SEVERITY TO PROITIZE TREATMENT PROTOCOLS?
select 
obsession_Type,
COUNT(Patient_ID) AS Patient_Count,
AVG(Y_BOCS_Score_Obsessions) AS AVG_Obsession_severity
FROM [OCD_Patients].dbo.OCD_Patient_Dataset
GROUP BY obsession_Type
ORDER BY Patient_Count DESC;
----the most common obsession type is harm-related with the most prevalent obeddion theme ith 333 patients avg severity 20,
----fellowed by contamination 306 avg 19 and religious 303 avg 19. symmetry 208 and hoarding shows highest avg seerity 21.

---Q5 WHICH COMPUlSION BEHAVIOURS ARE MOST FREQUENT,AND HOW SEVER ARE THEY ON AVERAGE TO INFORM TREATMENT PATHWAYS?
select
compulsion_Type,
COUNT(Patient_ID) AS Patient_Count,
AVG(Y_BOCS_Score_Obsessions) AS AVG_Obsession_severity
FROM  [OCD_Patients].dbo.OCD_Patient_Dataset
GROUP BY compulsion_Type
ORDER BY Patient_Count DESC;
---- the most frequent compulsion is washing with 321 patients avg severity 19, fellowed by counting 316 avg 20.
---- checking 292, avg 19. praying 286 avg 20, and ordering 285 avg 20, are also highly prevalent with severity 19-20.

