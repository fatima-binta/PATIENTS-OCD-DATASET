# OCD Patient Clinical Analysis | SQL Server

![SQL Server](https://img.shields.io/badge/SQL-SQL%20Server-blue)
![SSMS](https://img.shields.io/badge/Tool-SSMS-lightgrey)
![Domain](https://img.shields.io/badge/Domain-Mental%20Health%20Analytics-green)
![Metric](https://img.shields.io/badge/Metric-Y--BOCS-purple)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

> Profiling 1,500 OCD patients to show who is being diagnosed, which symptoms dominate, and where treatment resources should focus.

# Project Background

Mental health services need to know who their OCD patients are, which symptoms are most common and most severe, and whether new diagnoses are rising. Without that picture, treatment protocols and staffing are planned on assumptions. In this project I acted as the data analyst for a mental health service planning team and profiled 1,500 OCD patient records in SQL Server, using Y-BOCS (Yale-Brown Obsessive Compulsive Scale) scores as the severity measure.

Insights and recommendations are provided on the following key areas:

- **Patient demographics:** gender and ethnicity mix, with severity
- **Diagnosis trend:** monthly new cases from 2013 to 2022
- **Obsession themes:** most common types and their severity
- **Compulsion behaviors:** most common types and their severity

The SQL script used for preparation and analysis can be found here: [ocd_patient_analysis.sql](sql/ocd_patient_analysis.sql)

Dataset: [OCD Patient Dataset: Demographics & Clinical Data (Kaggle)](https://www.kaggle.com/datasets/ohinhaque/ocd-patient-dataset-demographics-and-clinical-data/). A copy of the CSV is included in the [data](data) folder for convenience.

# Data Structure & Initial Checks

The analysis uses one table, `dbo.OCD_Patient_Dataset`, with 1,500 patient records. The columns used are:

- **Patient_ID:** unique patient identifier
- **Gender, Ethnicity:** demographic fields
- **OCD_Diagnosis_Date:** date of diagnosis (converted to a `date` type for time-series analysis)
- **Obsession_Type, Compulsion_Type:** the patient's main obsession theme and compulsion behavior
- **Y_BOCS_Score_Obsessions, Y_BOCS_Score_Compulsions:** severity scores

Initial checks: reviewed the raw data with `SELECT TOP 100`, converted the diagnosis date to a date type, cast score columns to decimals before averaging so results are not truncated to whole numbers, and confirmed that category counts add up to 1,500.

# Executive Summary

**Overview of findings**

Obsession severity is nearly identical across gender and ethnicity (about 19.8 to 20.3). Differences by symptom type are larger but still modest: obsession severity ranges from 19.2 to 21.0 and compulsion severity from 17.9 to 20.7. Volume varies more than severity, with harm-related obsessions and washing compulsions the most common. New diagnoses rose steadily from 2013 to a peak in April 2018 and then plateaued through 2022.

The three main takeaways for a clinical director:
1. Severity is uniform across demographic groups, so triage should not be demographic-based.
2. Treatment protocols should weigh both symptom volume and severity, because the most common symptoms are not the most severe.
3. Diagnosis volume stopped climbing after 2018, so capacity can be planned on the plateau.

# Insights Deep Dive

## Patient demographics

- **Balanced gender mix.** Male patients number 753 (50.2%) and female 747 (49.8%). Average obsession score is 19.9 for males and 20.2 for females, a negligible gap.
- **Ethnicity.** Caucasian 398, Hispanic 392, Asian 386 and African 324 patients. Average obsession score stays within 19.8 to 20.3 across all four groups.

## Diagnosis trend

- **Steady rise, then a plateau.** Monthly new diagnoses climbed from about 9 cases per month in 2013 to a peak of 25 in April 2018, then held at 8 to 21 per month from 2019 through 2022.
- **Data edge.** November 2022 shows only 2 cases, which is most likely an incomplete month and not a real decline.

## Obsession themes

| Obsession type | Patients | Share | Avg severity |
|---|---|---|---|
| Harm-related | 333 | 22.2% | 20.7 |
| Contamination | 306 | 20.4% | 19.7 |
| Religious | 303 | 20.2% | 19.2 |
| Symmetry | 280 | 18.7% | 19.7 |
| Hoarding | 278 | 18.5% | 21.0 |

- **Harm-related is the most common** (22.2% of patients) and has the second-highest severity (20.7).
- **Hoarding is the smallest group but the most severe** (21.0), about 1.8 points above religious obsessions, the lowest.

## Compulsion behaviors

| Compulsion type | Patients | Share | Avg severity |
|---|---|---|---|
| Washing | 321 | 21.4% | 19.6 |
| Counting | 316 | 21.1% | 19.7 |
| Checking | 292 | 19.5% | 17.9 |
| Praying | 286 | 19.1% | 20.7 |
| Ordering | 285 | 19.0% | 20.2 |

- **Washing and counting are the most frequent** (42.5% of patients combined) but have mid-range severity.
- **Praying is the most severe compulsion** (20.7) despite ranking fourth by volume, while checking is the least severe (17.9).

# Recommendations

Based on the findings above, I would recommend the mental health service planning team consider the following:

1. **Build first-line protocols by volume.** Harm-related, contamination and religious obsessions cover 62.8% of patients, and washing and counting cover 42.5%.
2. **Review hoarding and praying cases more closely.** Hoarding has the highest obsession severity and praying the highest compulsion severity, even though neither is the largest group.
3. **Forecast capacity from the post-2018 plateau,** about 8 to 21 new cases a month, and exclude incomplete months such as November 2022 from forecasts.
4. **Do not triage by demographics.** Severity gaps by gender and ethnicity are about 1 point or less, too small to justify it.

# Assumptions and Caveats

- **No significance testing.** Differences in severity between groups are about 1 to 3 points and were not tested statistically, so they should be

