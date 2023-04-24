ods rtf file="C:\Users\lb943\Box\HW2_LukeBeebe_lb943_nbaplayers" style=journal;
/* import data */
proc import out=all_seasons
datafile="C:\Users\lb943\Box\all_seasons.csv"
dbms=csv
replace;
getnames=YES;
run;
/* same simple random sample from HW1 */
proc surveyselect data=all_seasons
out=sample
method=srs
sampsize=30
seed=123;
run;
/* avg_height=200.61 cm avg_weight=100.37 kg (from population data) */
data sample1;
set sample;
height1=player_height-200.61;
weight1=player_weight-100.37;
run;
/* t-test on player's heights and weights */
proc means data=sample1 n mean std t prt;
var height1 weight1;
run; /* We do not reject the null on either */
/* finds quintiles */
proc univariate data=sample;
var player_height;
output out=quintile_height
pctlpts = 0 20 40 60 80 100
pctlpre = Q_;
run;
proc univariate data=sample;
var player_weight;
output out=quintile_weight
pctlpts = 0 20 40 60 80 100
pctlpre = Q_;
run;
proc print data=quintile_height;
run;
proc print data=quintile_weight;
run;
/* uses quintiles to seperate player's positions based on height and weight */
data sample2;
set sample;
if player_height>=209.55 then position=5;
if 203.2<=player_height<209.55 then position=4;
if 198.12<=player_height<203.2 then position=3;
if 193.04<=player_height<198.12 then position=2;
if player_height<193.04 then position=1;
run;
data sample3;
set sample;
if player_weight>=115.212 then position=5;
if 107.048<=player_weight<115.212 then position=4;
if 98.2027<=player_weight<107.048 then position=3;
if 92.3060<=player_weight<98.2027 then position=2;
if player_weight<92.3060 then position=1;
run;
proc print data=sample2;
var player_name position;
run;
proc print data=sample3;
var player_name position;
run;
proc freq data=sample2;
tables position;
run;
proc freq data=sample3;
tables position;
run;
/* interesting the quintiles didn't work out for player_height,
might've messed up somewhere */
proc corr data=sample;
var player_height;
with player_weight;
run;
/* strong, positive correlation between the variables at R^2=0.71655 */
ods rtf close;
