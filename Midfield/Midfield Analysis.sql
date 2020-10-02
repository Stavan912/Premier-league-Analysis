# 1. PLayer Fitness & Potential Form

# Query below the players from Liverpool and Manchester City operating primarily in the midfield. The playing_time and player_info tables have been joined on player_id to allow for filtering on position.
# We select the the matches played, matches started, minutes played, minutes played per match and of team minutes played percent. This illustrates how playing time was distributed throughout the midfielders available in each squad.
# A disperced map of stats would indicate there are certain cogs in the machine that can't be replaced, limiting the effectiveness and efficiency in matches where players are rested, injured or having an off game.
# A tighter spread would indicate a relatively equal share of minutes and would allow an easier plug and play system, allowing the team to continuously performing at their maximum levels.

#Liverpool and Manchester City Midfield - General Stats
SELECT pInfo.player_id, pInfo.squad, pInfo.player_name, pTime.match_played, pTime.match_start, pTime.mins_played, pTime.mins_played_permatch, pTime.ofteammins_played_perc
FROM player_info pInfo LEFT JOIN playing_time pTime ON pTime.player_id = pInfo.player_id
WHERE ( (pInfo.squad = "Liverpool" OR pInfo.squad = "Manchester City") AND pInfo.player_position LIKE "MF%" ) AND pTime.mins_played > 380
GROUP BY pInfo.player_id
ORDER BY pInfo.squad DESC, pTime.mins_played DESC;

#####################################################################################################################################################################

# 2. Passing & Ball Progression

# Query below expands on the focus of each team's midfield squad. Here, we take a look at which player's ability to pass the ball.
# Though this is a collection of basis stats, it gives us insight to the overall ability of the midfield to spread play effectively and who the team relies on to control the flow of possession.

#Liverpool and Manchester City Midfield - Pass Completion Percentage
SELECT pInfo.player_id, pInfo.squad, pInfo.player_name, pss.pass_complt_perc, pss.short_pass_complt_perc, pss.med_pass_compltd_perc, pss.long_pass_compltd_perc
FROM player_info pInfo LEFT JOIN passing pss ON pss.player_id = pInfo.player_id LEFT JOIN playing_time pTime ON pInfo.player_id = pTime.player_id
WHERE ( (pInfo.squad = "Liverpool" OR pInfo.squad = "Manchester City") AND pInfo.player_position LIKE "MF%" ) AND pTime.mins_played > 380
GROUP BY pInfo.player_id
ORDER BY pInfo.squad DESC, pss.pass_complt_perc DESC;

# Query below focuses more on each squad's ability to play progressively (passes moving forward towards the opponent goal), meaning moving the play forward, or taking the ball forward, and key passes,
# opportunities that lead to shots at goal. Connecting the play and moving the ball forward is essential in creating chances. Goals are created by playing the ball and creating opportunities
# It is the responsbility of the midfield to take the ball forward and the forwards to work the space between/behind the oppossing players to finish the chances.
# If the forwards have to drop back or come back to assist in build up play, there is no one to capitalize on the created chances in the final 24 yards.

#Liverpool and Manchester City Midfield - Progressive Play
SELECT pInfo.player_id, pInfo.squad, pInfo.player_name, pss.pass_progressive, pss.pass_progressive/pTime.match_played AS pass_progressive_permatch, pss.pass_pen, pss.pass_pen/pTime.match_played AS pass_pen_permatch, pss.key_passes, pss.key_passes/pTime.match_played AS key_passes_permatch
FROM player_info pInfo LEFT JOIN passing pss ON pss.player_id = pInfo.player_id LEFT JOIN playing_time pTime ON pInfo.player_id = pTime.player_id
WHERE ( (pInfo.squad = "Liverpool" OR pInfo.squad = "Manchester City") AND pInfo.player_position LIKE "MF%" ) AND pTime.mins_played > 380
GROUP BY pInfo.player_id
ORDER BY pInfo.squad DESC, pass_progressive_permatch DESC;

# Query below show the ability of each midfield to handle possession - pass while being pressed, not being dispossessed easily, ability to offer to receive a pass and receive it successfully.
# Any elite midfield needs to be able to hold possession to allow them to play their game and control the rhytm of the game to suit their needs.

#Liverpool and Manchester City Midfield - Possession
SELECT pInfo.player_id, pInfo.squad, pInfo.player_name, psst.pass_press, poss.dispossessed, poss.pass_target, poss.pass_recvd_perc, ((poss.touch_att_third + poss.touch_att_pen)/poss.touches)*100 AS touch_att_space_perc
FROM player_info pInfo LEFT JOIN passing_types psst ON psst.player_id = pInfo.player_id LEFT JOIN playing_time pTime ON pInfo.player_id = pTime.player_id LEFT JOIN possession poss ON pInfo.player_id = poss.player_id
WHERE ( (pInfo.squad = "Liverpool" OR pInfo.squad = "Manchester City") AND pInfo.player_position LIKE "MF%" ) AND pTime.mins_played > 380
GROUP BY pInfo.player_id
ORDER BY pInfo.squad DESC, poss.pass_recvd_perc DESC;

#####################################################################################################################################################################

# 3. Goal & Shot Creation

# Query below looks at the underlying numbers to shwocase the creativity at play in the midfields. Creativity is what leads to breaking down the opposition and opportunities.
# Creating opportunities for shots is important. However it is only a shot and forwards are candid with their shots. That is why we are looking at the conversion of these shots.
# This allows us to 

#Liverpool and Manchester City Midfield - Creativty
SELECT pInfo.player_id, pInfo.squad, pInfo.player_name, pss.passes_atmptd, (pss.pass_finalthird/pss.passes_atmptd) AS passes_finalthird_perc, pss.pass_finalthird, (pss.pass_pen/pss.pass_finalthird) AS pass_pen_perc, psst.through_ball, pss.key_passes, pss.key_passes/pTime.match_played AS key_passes_permatch, stan.xA, (stan.xA/stan.match_played) AS xA_permatch
FROM player_info pInfo LEFT JOIN passing pss ON pInfo.player_id = pss.player_id LEFT JOIN passing_types psst on pInfo.player_id = psst.player_id LEFT JOIN playing_time pTime ON pInfo.player_id = pTime.player_id LEFT JOIN standard stan ON pInfo.player_id = stan.player_id
WHERE ( (pInfo.squad = "Liverpool" OR pInfo.squad = "Manchester City") AND pInfo.player_position LIKE "MF%" ) AND pTime.mins_played > 380
GROUP BY pInfo.player_id
ORDER BY pInfo.squad DESC, pss.key_passes DESC;

#Liverpool and Manchester City Midfield - Opportunities
SELECT pInfo.player_id, pInfo.squad, pInfo.player_name, gsc.shot_creat_act, gsc.shot_creat_act_per90, (gsc.shot_creat_act/pTime.match_played) AS shot_creat_act_permatch, gsc.goal_creat_act, gsc.goal_creat_act_per90, (gsc.goal_creat_act/pTime.match_played) AS goal_creat_act_permatch
FROM player_info pInfo LEFT JOIN goal_shot_creation gsc ON pInfo.player_id = gsc.player_id LEFT JOIN playing_time pTime ON pInfo.player_id = pTime.player_id
WHERE ( (pInfo.squad = "Liverpool" OR pInfo.squad = "Manchester City") AND pInfo.player_position LIKE "MF%" ) AND pTime.mins_played > 380
GROUP BY pInfo.player_id
ORDER BY pInfo.squad DESC, gsc.shot_creat_act DESC;

#####################################################################################################################################################################

# 4. Success Contribution

# Queries below examine the contributions by each squad's midfield to the total squad tallies. Comparisons are made to their own team's totals and as well as the averages for the league.
# We dive into also looking at the midfield performing as a unit when compared to the other teams in the league. A midfield that contributes to their team's success in goals and
# chance creation is overall a great assest as it lessens the burden of the forwards to score or in dire situations create chances for the players around them, allowing them to focus on what they do best - score.

#Manchester City Midfield - Contributions
WITH
	mancity_goaltotal(mc_totalgoals) AS (SELECT goals_for FROM league_table WHERE squad = "Manchester City"),
    mancity_assisttotal(mc_totalassists) AS (select SUM(assists) FROM standard WHERE squad = "Manchester City")
SELECT pInfo.player_id, pInfo.squad, pInfo.player_name, stan.assists, stan.assists_per90, (stan.assists/mancity_assisttotal.mc_totalassists) AS assist_perc, stan.xA, stan.xA_per90, stan.goals_scored, stan.penkicks_scored, stan.goals_scored_nonpen_per90, stan.goals_scored/mancity_goaltotal.mc_totalgoals AS goal_perc, stan.xG_nonpen, stan.xG_nonpen_per90
FROM standard stan LEFT JOIN player_info pInfo ON stan.player_id = pInfo.player_id LEFT JOIN playing_time pTime ON stan.player_id = pTime.player_id, mancity_goaltotal, mancity_assisttotal
WHERE (stan.squad = "Manchester City" AND pInfo.player_position LIKE "MF%") AND pTime.mins_played > 380
GROUP BY stan.player_id
ORDER BY stan.squad DESC, stan.goals_scored DESC;

#Liverpool Midfield - Contributions
WITH
	liverpool_goaltotal(lp_totalgoals) AS (SELECT goals_for FROM league_table WHERE squad = "Liverpool"),
    liverpool_assisttotal(lp_totalassists) AS (select SUM(assists) FROM standard WHERE squad = "Liverpool")
SELECT pInfo.player_id, pInfo.squad, pInfo.player_name, stan.assists, stan.assists_per90, (stan.assists/liverpool_assisttotal.lp_totalassists) AS assist_perc, stan.xA, stan.xA_per90, stan.goals_scored, stan.penkicks_scored, stan.goals_scored_nonpen_per90, stan.goals_scored/liverpool_goaltotal.lp_totalgoals AS goal_perc, stan.xG_nonpen, stan.xG_nonpen_per90
FROM standard stan LEFT JOIN player_info pInfo ON stan.player_id = pInfo.player_id LEFT JOIN playing_time pTime ON stan.player_id = pTime.player_id, liverpool_goaltotal, liverpool_assisttotal
WHERE (stan.squad = "Liverpool" AND pInfo.player_position LIKE "MF%") AND pTime.mins_played > 380
GROUP BY stan.player_id
ORDER BY stan.squad DESC, stan.goals_scored DESC;

#League Midfield Average Per Team For Player Average Comparison
SELECT stan.squad, AVG(stan.assists), AVG(stan.assists_per90), AVG(stan.xA), AVG(stan.xA_per90), AVG(stan.goals_scored), AVG(stan.goals_scored_nonpen_per90), AVG(stan.xG_nonpen), AVG(stan.xG_nonpen_per90)
FROM standard stan LEFT JOIN player_info pInfo ON stan.player_id = pInfo.player_id LEFT JOIN playing_time pTime ON stan.player_id = pTime.player_id
WHERE ( (stan.squad <> "Liverpool" AND stan.squad <> "Manchester City") AND pInfo.player_position LIKE "MF%" ) AND pTime.mins_played > 380
GROUP BY stan.squad
ORDER BY stan.squad ASC;

#League Midfield Average Per Team For Team Average Comparison
SELECT stan.squad, AVG(stan.assists), AVG(stan.assists_per90), AVG(stan.xA), AVG(stan.xA_per90), AVG(stan.goals_scored), AVG(stan.goals_scored_nonpen_per90), AVG(stan.xG_nonpen), AVG(stan.xG_nonpen_per90)
FROM standard stan LEFT JOIN player_info pInfo ON stan.player_id = pInfo.player_id LEFT JOIN playing_time pTime ON stan.player_id = pTime.player_id
WHERE pInfo.player_position LIKE "MF%" AND pTime.mins_played > 380
GROUP BY stan.squad
ORDER BY stan.squad ASC;

#League Midfield Average Per Team For Player Average Comparison (Excluding Liverpool and Manchester City)
SELECT AVG(stan.assists) AS avg_assists, AVG(stan.assists_per90) AS avg_assists_per90, AVG(stan.xA) AS avg_xA, AVG(stan.xA_per90) AS avg_xA_per90, AVG(stan.goals_scored) AS avg_goals, AVG(stan.goals_scored_nonpen_per90) AS avg_goals_scored_nonpen_per90, AVG(stan.xG_nonpen) AS avg_xG_nonpen, AVG(stan.xG_nonpen_per90) AS xG_nonpen_per90
FROM standard stan LEFT JOIN player_info pInfo ON stan.player_id = pInfo.player_id LEFT JOIN playing_time pTime ON stan.player_id = pTime.player_id
WHERE ( (stan.squad <> "Liverpool" AND stan.squad <> "Manchester City") AND pInfo.player_position LIKE "MF%" ) AND pTime.mins_played > 380;

#League Midfield Average Per Team For Player Average Comparison (Including Liverpool and Manchester City)
SELECT AVG(stan.assists) AS avg_assists, AVG(stan.assists_per90) AS avg_assists_per90, AVG(stan.xA) AS avg_xA, AVG(stan.xA_per90) AS avg_xA_per90, AVG(stan.goals_scored) AS avg_goals, AVG(stan.goals_scored_nonpen_per90) AS avg_goals_scored_nonpen_per90, AVG(stan.xG_nonpen) AS avg_xG_nonpen, AVG(stan.xG_nonpen_per90) AS xG_nonpen_per90
FROM standard stan LEFT JOIN player_info pInfo ON stan.player_id = pInfo.player_id LEFT JOIN playing_time pTime ON stan.player_id = pTime.player_id
WHERE pInfo.player_position LIKE "MF%" AND pTime.mins_played > 380;