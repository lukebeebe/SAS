ods rtf file="C:\Users\lb943\Box\HW4_LukeBeebe_lb943_nbaplayers" style=journal;
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
/* uses quintiles to seperate player's positions beased on height and weight */
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
/* create cross tab, chisq pval=0.0419 statistically significant relationship at a=0.05 */
proc freq data=sample2;
tables height_position*weight_position / chisq;
run;
/* ANOVA table, pval<.0001 the means of 'size' are not equal at a=0.05 */
data sample3;
set sample;
if player_height>=205 then size='L';
if 195<=player_height<205 then size='M';
if player_height<195 then size='S';
run;
proc glm data=sample3;
class size;
model player_height = size;
run;
/* paired t-test, pval<.0001 the means of player_height and player_weight are not equal */
proc ttest data=sample3 alpha=0.05;
paired player_height*player_weight;
run;
/* scatter plot, pval<.0001 r=0.7166 player_weight and player_height have a statistically significant linear relationship */
proc corr data=sample3 plots=scatter(nvar=all);
var player_weight player_height;
run;
ods rtf close;
