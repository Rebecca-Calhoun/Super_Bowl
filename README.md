# SAS Projects: Graduate Work

Welcome to my collection of SAS-based analytics projects! These scripts demonstrate statistical modeling techniques used for forecasting, classification, and time series analysis. All code was developed as part of my graduate coursework in Data Analytics.

## Project Overview

### 1. `Super_Bowl.sas`
- Implements Logistic Regression to forecast AFC and NFC winners—predicting the teams most likely to play in the upcoming Super Bowl.
- Includes stepwise selection (entry/stay criteria = 0.3), AIC-based model comparison, and Firth correction to address convergence issues in small or imbalanced samples.



## Datasets
- NFL_new.csv: Data extracted from [NFL.com/team-stats/stats](https://www.nfl.com/stats/team-stats/) for over 100 variables for seasons 2019-2024, plus pre-season power rankings from NFL.com
- Conferences.xlsx: Data extracted from [NFL.com/standings/](https://www.nfl.com/standings/) regarding team locations, conferences, and regions.

## Requirements

- SAS 9.4+ or access to SAS Studio
- Datasets in `.csv` or `.xlsx` format
- No additional libraries required

## How to Use

1. Clone or download this repo.
2. Open `.sas` files in SAS Studio or your local SAS environment.
3. Modify file paths in the `libname` and `infile` statements to match your local setup.
4. Run scripts section by section to explore model outputs.

## Notes

- All models were created for educational purposes.
- Please credit or reference this repo if adapting the code for your own work.

## Connect

Feel free to connect with me on [LinkedIn](https://linkedin.com/in/YOUR-PROFILE) or check out my [resume](https://yourportfolio.com) for more about my work in data analytics.

