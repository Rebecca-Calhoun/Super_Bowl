# Super_Bowl.sas

This project uses SAS to predict which NFL teams are most likely to win their conference championship (and potentially reach the Super Bowl) based on regular-season performance metrics. After extensive preprocessing, lagged feature engineering, and modeling with logistic regression, predictions are generated for the 2021–2025 seasons.

## Highlights

- Imported and merged team-level stats from [NFL.com](https://www.nfl.com/stats/team-stats) with conference classification data.
- Created lagged features from 100+ variables to reflect performance from the prior season.
- Applied logistic regression with:
  - Stepwise selection (SL entry/stay = 0.3)
  - AIC for model comparison
  - Firth correction to address convergence issues and rare events
- Evaluated model residuals using Pearson and Deviance diagnostics.
- Generated championship predictions for multiple seasons with ranked probabilities.

## Tools Used

- SAS 9.4 / SAS Studio
- `PROC IMPORT`, `PROC LOGISTIC`, `PROC SORT`, `PROC CORR`, `PROC FREQ`
- Stepwise variable selection and Firth correction for logistic models
- Residual diagnostics with `PROC UNIVARIATE` and `PROC SGPLOT`
- Scoring new data with `PRIORMODEL` and `SCORE` statements

## Dataset

- **Source**: Publicly available data from [NFL.com/stats](https://www.nfl.com/stats/team-stats/) and [NFL.com/standings](https://www.nfl.com/standings/)
- **NFL_new.csv**: Contains 100+ regular-season metrics and preseason rankings
- **Conferences.xlsx**: Adds contextual grouping by conference and region from [NFL.com/standings](https://www.nfl.com/standings/)
- Data includes 224 team-season observations across 106+ variables, later expanded to over 200 variables with lagged features.

*Note: You may need to adjust file paths when running locally.*

## Prediction Summary (Championship Win Probability)

### Top Predicted Teams by Conference


|   Season | Top AFC Teams (probability)      | Top NFC Teams   (probability)      |
|---------:|:---------------------------------|:-----------------------------------|
|     2025 | Chiefs (0.575), Ravens (0.387)   | Eagles (0.485), Seahawks (0.132)   |
|     2024 | Chiefs (0.718), Raiders (0.036)  | Eagles (0.696), Lions (0.155)      |
|     2023 | Chiefs (0.754), Steelers (0.215) | 49ers (0.173), Cowboys (0.436)     |
|     2022 | Chiefs (0.324), Bills (0.086)    | Eagles (0.931), Buccaneers (0.073) |
|     2021 | Ravens (0.328), Bills (0.194)    | Buccaneers (0.400), Rams (0.129)   |
|     2020 | Chiefs (0.896), Ravens (0.217)   | Buccaneers (0.519), 49ers (0.212)  |



## Goal

To determine whether preseason ranking and prior-season team performance can accurately predict NFL conference championship winners, and to assess whether logistic regression with penalization and lag features can outperform traditional metrics.

## Author

**Rebecca Calhoun**  
M.S. in Data Analytics (July 2025)  
[LinkedIn](https://www.linkedin.com/in/rebecca-calhoun9/) | 
