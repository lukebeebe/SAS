ods rtf file="C:\Users\lb943\Box\HW3_LukeBeebe_lb943_nbaplayers" style=journal;
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
/* uses quintiles to seperate player's positions based on height and weight */
data sample2;
set sample;
if player_height>=209.55 then height_position=5;
if 203.2<=player_height<209.55 then height_position=4;
if 198.12<=player_height<203.2 then height_position=3;
if 193.04<=player_height<198.12 then height_position=2;
if player_height<193.04 then height_position=1;
if player_weight>=115.212 then weight_position=5;
if 107.048<=player_weight<115.212 then weight_position=4;
if 98.2027<=player_weight<107.048 then weight_position=3;
if 92.3060<=player_weight<98.2027 then weight_position=2;
if player_weight<92.3060 then weight_position=1;
run;
/* create bar charts */
proc chart data=sample2;
vbar height_position;
title1 'Bar Chart of Positions in NBA by height n=30';
run;
proc chart data=sample2;
vbar weight_position;
title1 'Bar Chart of Positions in NBA by weight n=30';
run;
/* create histograms */
proc univariate data=sample2;
var height_position;
histogram height_position;
title1 'Freq of Positions in NBA by height n=30';
run;
proc univariate data=sample2;
var weight_position;
histogram weight_position;
title1 'Freq of Positions in NBA by weight n=30';
run;
/* create freq tables */
proc freq data=sample2;
tables height_position;
run;
proc freq data=sample2;
tables weight_position;
run;
/* table for two classification vars */
proc tabulate data=sample2;
var height_position weight_position;
table (height_position weight_position)*(N MEAN STD MIN MAX);
title1 'Height vs Weight positioning';
run;
/* boxplots for height and weight */
proc sgplot data=sample2;
vbox player_height;
title1 'Height of NBA players n=30';
run;
proc sgplot data=sample2;
vbox player_weight;
title1 'Weight of NBA player n=30';
run;
/* scatter plot for height by weight */
proc plot data=sample2;
plot player_weight*player_height;
run;
ods rtf close;
