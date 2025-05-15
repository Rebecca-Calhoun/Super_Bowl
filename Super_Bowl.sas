# Super_Bowl
Predicted teams for the 2026 Super Bowl using SAS

FILENAME REFFILE '/home/u63794279/sasuser.v94/NFL_new.csv';

PROC IMPORT DATAFILE=REFFILE
            OUT=NFL
            DBMS=csv
            REPLACE; 
    GETNAMES=YES;
RUN;


PROC CONTENTS DATA=NFL;
RUN;

proc print data=NFL;
run;

FILENAME CONFREF '/home/u63794279/sasuser.v94/Conferences.xlsx';

PROC IMPORT DATAFILE=CONFREF
            OUT=conferences
            DBMS=XLSX
            REPLACE;
    GETNAMES=YES;
RUN;

/*sort both datasets*/
proc sort data=NFL; by Team; run;
proc sort data=conferences; by Team; run;

/*merge both datasets*/
data NFL_merge;
    merge NFL(in=a) conferences(in=b);
    by Team;
    if a; 
run;


proc contents data=NFL_merge;
run;

proc print data=NFL_merge;
run;


proc sort data=NFL_merge;
    by Team Season;
run;


/*lag the merged dataset*/
data NFL_lag;
    set NFL_merge;
    by Team Season;

    
    array orig_vars {*} 
        off_pass_att off_pass_cmp off_cmp_pct off_yds_per_att off_pass_yds off_pass_td
        off_int off_qb_rating off_first_downs off_first_down_pct off_pass_20plus
        off_pass_40plus off_sacks_taken off_sack_yds_lost off_rush_att off_rush_yds
        off_rush_avg off_rush_td off_rush_20plus off_rush_40plus off_rush_1st
        off_rush_1st_pct off_rush_fum off_rec off_rec_yds off_yds_per_rec
        off_rec_td off_rec_20plus off_rec_40plus off_rec_1st off_rec_1st_pct
        off_rec_fum off_total_td off_2pt_conv off_3rd_att off_3rd_md off_4th_att
        off_4th_md off_scrim_plays def_pass_att def_pass_cmp def_pass_cmp_pct
        def_pass_yds_per_att def_pass_yds def_pass_td_allowed def_pass_int_made
        def_opp_qb_rating def_pass_1st def_pass_1st_pct def_pass_20plus_allowed
        def_pass_40plus_allowed def_rush_att def_rush_yds def_rush_avg
        def_rush_td_allowed def_rush_20plus_allowed def_rush_40plus_allowed
        def_rush_1st def_rush_1st_pct def_rush_fum_recovered def_rec_allowed
        def_rec_yds_allowed def_yds_per_rec_allowed def_rec_td_allowed
        def_rec_20plus_allowed def_rec_40plus_allowed def_rec_1st def_rec_1st_pct
        def_rec_fum_recovered def_passes_defended def_fum_td def_safety def_int_td
        def_sacks def_comb_tackles def_assist_tackles def_solo_tackles def_3rd_att
        def_3rd_md def_4th_att def_4th_md def_scrim_plays def_forced_fumbles
        def_fum_recovered def_int_yds st_fg_made st_fg_pct st_xp_made
        st_xp_pct st_kick_return_td st_punt_return_td;

    /* lag variable array */
    array lag_vars {*} 
        lag_off_pass_att lag_off_pass_cmp lag_off_cmp_pct lag_off_yds_per_att lag_off_pass_yds lag_off_pass_td
        lag_off_int lag_off_qb_rating lag_off_first_downs lag_off_first_down_pct lag_off_pass_20plus
        lag_off_pass_40plus lag_off_sacks_taken lag_off_sack_yds_lost lag_off_rush_att lag_off_rush_yds
        lag_off_rush_avg lag_off_rush_td lag_off_rush_20plus lag_off_rush_40plus lag_off_rush_1st
        lag_off_rush_1st_pct lag_off_rush_fum lag_off_rec lag_off_rec_yds lag_off_yds_per_rec
        lag_off_rec_td lag_off_rec_20plus lag_off_rec_40plus lag_off_rec_1st lag_off_rec_1st_pct
        lag_off_rec_fum lag_off_total_td lag_off_2pt_conv lag_off_3rd_att lag_off_3rd_md lag_off_4th_att
        lag_off_4th_md lag_off_scrim_plays lag_def_pass_att lag_def_pass_cmp lag_def_pass_cmp_pct
        lag_def_pass_yds_per_att lag_def_pass_yds lag_def_pass_td_allowed lag_def_pass_int_made
        lag_def_opp_qb_rating lag_def_pass_1st lag_def_pass_1st_pct lag_def_pass_20plus_allowed
        lag_def_pass_40plus_allowed lag_def_rush_att lag_def_rush_yds lag_def_rush_avg
        lag_def_rush_td_allowed lag_def_rush_20plus_allowed lag_def_rush_40plus_allowed
        lag_def_rush_1st lag_def_rush_1st_pct lag_def_rush_fum_recovered lag_def_rec_allowed
        lag_def_rec_yds_allowed lag_def_yds_per_rec_allowed lag_def_rec_td_allowed
        lag_def_rec_20plus_allowed lag_def_rec_40plus_allowed lag_def_rec_1st lag_def_rec_1st_pct
        lag_def_rec_fum_recovered lag_def_passes_defended lag_def_fum_td lag_def_safety lag_def_int_td
        lag_def_sacks lag_def_comb_tackles lag_def_assist_tackles lag_def_solo_tackles lag_def_3rd_att
        lag_def_3rd_md lag_def_4th_att lag_def_4th_md lag_def_scrim_plays lag_def_forced_fumbles
        lag_def_fum_recovered lag_def_int_yds lag_st_fg_made lag_st_fg_pct lag_st_xp_made
        lag_st_xp_pct lag_st_kick_return_td lag_st_punt_return_td;

    /* temp array to store lag values */
    array temp_vars {102} _temporary_; 

    /* Always call lag, but only assign when not first of team */
    do i = 1 to dim(orig_vars);
        temp_vars{i} = lag(orig_vars{i});
        if first.Team then lag_vars{i} = .;
        else lag_vars{i} = temp_vars{i};
    end;

    drop i;
run;

proc print data=NFL_lag;
run;
proc contents data=NFL_lag;
run;

/*run logistic regression with lagged dataset and pre-season power rankings*/
proc logistic data=NFL_lag descending;
    class Team Conference_Type / param=ref;

model championship_win(event='1') =
 lag_off_pass_att lag_off_pass_cmp lag_off_cmp_pct lag_off_yds_per_att lag_off_pass_yds lag_off_pass_td
        lag_off_int lag_off_qb_rating lag_off_first_downs lag_off_first_down_pct lag_off_pass_20plus
        lag_off_pass_40plus lag_off_sacks_taken lag_off_sack_yds_lost lag_off_rush_att lag_off_rush_yds
        lag_off_rush_avg lag_off_rush_td lag_off_rush_20plus lag_off_rush_40plus lag_off_rush_1st
        lag_off_rush_1st_pct lag_off_rush_fum lag_off_rec lag_off_rec_yds lag_off_yds_per_rec
        lag_off_rec_td lag_off_rec_20plus lag_off_rec_40plus lag_off_rec_1st lag_off_rec_1st_pct
        lag_off_rec_fum lag_off_total_td lag_off_2pt_conv lag_off_3rd_att lag_off_3rd_md lag_off_4th_att
        lag_off_4th_md lag_off_scrim_plays lag_def_pass_att lag_def_pass_cmp lag_def_pass_cmp_pct
        lag_def_pass_yds_per_att lag_def_pass_yds lag_def_pass_td_allowed lag_def_pass_int_made
        lag_def_opp_qb_rating lag_def_pass_1st lag_def_pass_1st_pct lag_def_pass_20plus_allowed
        lag_def_pass_40plus_allowed lag_def_rush_att lag_def_rush_yds lag_def_rush_avg
        lag_def_rush_td_allowed lag_def_rush_20plus_allowed lag_def_rush_40plus_allowed
        lag_def_rush_1st lag_def_rush_1st_pct lag_def_rush_fum_recovered lag_def_rec_allowed
        lag_def_rec_yds_allowed lag_def_yds_per_rec_allowed lag_def_rec_td_allowed
        lag_def_rec_20plus_allowed lag_def_rec_40plus_allowed lag_def_rec_1st lag_def_rec_1st_pct
        lag_def_rec_fum_recovered lag_def_passes_defended lag_def_fum_td lag_def_safety lag_def_int_td
        lag_def_sacks lag_def_comb_tackles lag_def_assist_tackles lag_def_solo_tackles lag_def_3rd_att
        lag_def_3rd_md lag_def_4th_att lag_def_4th_md lag_def_scrim_plays lag_def_forced_fumbles
        lag_def_fum_recovered lag_def_int_yds lag_st_fg_made lag_st_fg_pct lag_st_xp_made
        lag_st_xp_pct lag_st_kick_return_td lag_st_punt_return_td
        normalized_power_rank
        / selection=stepwise slentry=0.3 slstay=0.3;
run;

/*use firth to fix convergence*/
/*lowest AIC Firth with entry/stay 0.3*/
proc logistic data=NFL_lag descending;
    class Team Conference_Type / param=ref;
model championship_win(event='1')=
normalized_power_rank
lag_def_fum_td
lag_off_3rd_md
lag_def_pass_td_allowed
lag_def_fum_recovered
lag_def_rush_40plus_allowed
/firth;
run;

/* Firth with residuals output */
proc logistic data=NFL_lag descending;
    class Team Conference_Type / param=ref;
    model championship_win(event='1') =
        normalized_power_rank
        lag_def_fum_td
        lag_off_3rd_md
        lag_def_pass_td_allowed
        lag_def_fum_recovered
        lag_def_rush_40plus_allowed
        / firth;

    output out=residuals_data
        pred=pred_prob
        resdev=dev_residual
        reschi=pearson_residual;
run;

proc print data=residuals_data;
    var Team Season championship_win pred_prob dev_residual pearson_residual;
    title "Residual Analysis from Firth Logistic Model";
run;

proc univariate data=residuals_data;
    var dev_residual pearson_residual;
    histogram;
    title "Distribution of Residuals";
run;

proc sgplot data=residuals_data;
    scatter x=pred_prob y=dev_residual / markerattrs=(symbol=circlefilled color=BIOY);
    refline 0 / axis=y lineattrs=(color=red pattern=shortdash);
    title "Deviance Residuals vs. Predicted Probability";
    xaxis label="Predicted Probability";
    yaxis label="Deviance Residual";
run;

proc sgplot data=residuals_data;
    scatter x=pred_prob y=pearson_residual / markerattrs=(symbol=circlefilled color=BIOY);
    refline 0 / axis=y lineattrs=(color=red pattern=shortdash);
    title "Pearson Residuals vs. Predicted Probability";
    xaxis label="Predicted Probability";
    yaxis label="Pearson Residual";
run;

proc sgplot data=residuals_data;
    histogram dev_residual / fillattrs=(color=BIOY) transparency=0.2;
    density dev_residual / type=normal lineattrs=(color=black);
    title "Histogram of Deviance Residuals";
run;

proc sgplot data=residuals_data;
    histogram pearson_residual / fillattrs=(color=BIOY) transparency=0.2;
    density pearson_residual / type=normal lineattrs=(color=black);
    title "Histogram of Pearson Residuals";
run;

proc means data=residuals_data min max mean stddev;
    var dev_residual pearson_residual;
run;

data flagged_residuals;
    set residuals_data;
    flag_dev = (abs(dev_residual) > 2);
    flag_pearson = (abs(pearson_residual) > 2);
run;

proc freq data=flagged_residuals;
    tables flag_dev flag_pearson;
run;

proc print data=flagged_residuals;
    where flag_dev = 1 or flag_pearson = 1;
    var Team Season championship_win pred_prob dev_residual pearson_residual;
    title "Observations with High Deviance or Pearson Residuals";
run;




/*check for correlation*/
proc corr data=NFL_lag;
var
normalized_power_rank
lag_def_fum_td
lag_off_3rd_md
lag_def_pass_td_allowed
lag_def_fum_recovered
lag_def_rush_40plus_allowed;
run;

/*none extremely corr, leave as is*/

/*make predictions*/
/*predict 2025*/


data NFL_2025;
    set NFL_lag;
    if Season = 2025;
run;



proc logistic data=NFL_lag descending;
    class Team Conference_Type / param=ref;
model championship_win(event='1')=
normalized_power_rank
lag_def_fum_td
lag_off_3rd_md
lag_def_pass_td_allowed
lag_def_fum_recovered
lag_def_rush_40plus_allowed
/firth;
    score data=NFL_2025
          out=pred_2025
          priorevent=0.0625; /* 2 winners from 32 teams — 2/32 = 0.0625 */
run;

proc sort data=pred_2025;
    by descending P_1;
run;


proc print data=pred_2025;
    var Team Season championship_win P_1 Conference Conference_Type Conference_Region preseaon_power_rank; /* P_1 is the predicted prob of win=1 */
run;

/*predict 2024*/


data NFL_2024;
    set NFL_lag;
    if Season = 2024;
run;



proc logistic data=NFL_lag descending;
    class Team Conference_Type / param=ref;
model championship_win(event='1')=
normalized_power_rank
lag_def_fum_td
lag_off_3rd_md
lag_def_pass_td_allowed
lag_def_fum_recovered
lag_def_rush_40plus_allowed
/firth;
    score data=NFL_2024
          out=pred_2024
          priorevent=0.0625; /* 2 winners from 32 teams — 2/32 = 0.0625 */
run;

proc sort data=pred_2024;
    by descending P_1;
run;


proc print data=pred_2024;
    var Team Season championship_win P_1 Conference Conference_Type Conference_Region; /* P_1 is the predicted prob of win=1 */
run;

/*predict 2023*/


data NFL_2023;
    set NFL_lag;
    if Season = 2023;
run;



proc logistic data=NFL_lag descending;
    class Team Conference_Type / param=ref;
model championship_win(event='1')=
normalized_power_rank
lag_def_fum_td
lag_off_3rd_md
lag_def_pass_td_allowed
lag_def_fum_recovered
lag_def_rush_40plus_allowed
/firth;
    score data=NFL_2023
          out=pred_2023
          priorevent=0.0625; /* 2 winners from 32 teams — 2/32 = 0.0625 */
run;

proc sort data=pred_2023;
    by descending P_1;
run;


proc print data=pred_2023;
    var Team Season championship_win P_1 Conference Conference_Type Conference_Region Preseaon_power_rank; /* P_1 is the predicted prob of win=1 */
run;

/*predict 2022*/


data NFL_2022;
    set NFL_lag;
    if Season = 2022;
run;



proc logistic data=NFL_lag descending;
    class Team Conference_Type / param=ref;
model championship_win(event='1')=
normalized_power_rank
lag_def_fum_td
lag_off_3rd_md
lag_def_pass_td_allowed
lag_def_fum_recovered
lag_def_rush_40plus_allowed
/firth;
    score data=NFL_2022
          out=pred_2022
          priorevent=0.0625; /* 2 winners from 32 teams — 2/32 = 0.0625 */
run;

proc sort data=pred_2022;
    by descending P_1;
run;


proc print data=pred_2022;
    var Team Season championship_win P_1 Conference Conference_Type Conference_Region; /* P_1 is the predicted prob of win=1 */
run;

/*predict 2021*/


data NFL_2021;
    set NFL_lag;
    if Season = 2021;
run;



proc logistic data=NFL_lag descending;
    class Team Conference_Type / param=ref;
model championship_win(event='1')=
normalized_power_rank
lag_def_fum_td
lag_off_3rd_md
lag_def_pass_td_allowed
lag_def_fum_recovered
lag_def_rush_40plus_allowed
/firth;
    score data=NFL_2021
          out=pred_2021
          priorevent=0.0625; /* 2 winners from 32 teams — 2/32 = 0.0625 */
run;

proc sort data=pred_2021;
    by descending P_1;
run;


proc print data=pred_2021;
    var Team Season championship_win P_1 Conference Conference_Type Conference_Region preseaon_power_rank; /* P_1 is the predicted prob of win=1 */
run;

/*predict 2020*/


data NFL_2020;
    set NFL_lag;
    if Season = 2020;
run;



proc logistic data=NFL_lag descending;
    class Team Conference_Type / param=ref;
model championship_win(event='1')=
normalized_power_rank
lag_def_fum_td
lag_off_3rd_md
lag_def_pass_td_allowed
lag_def_fum_recovered
lag_def_rush_40plus_allowed
/firth;
    score data=NFL_2020
          out=pred_2020
          priorevent=0.0625; /* 2 winners from 32 teams — 2/32 = 0.0625 */
run;

proc sort data=pred_2020;
    by descending P_1;
run;


proc print data=pred_2020;
    var Team Season championship_win P_1 Conference Conference_Type Conference_Region; /* P_1 is the predicted prob of win=1 */
run;

