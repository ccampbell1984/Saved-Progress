#!/bin/bash
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS OPP_GOALS
do
  #get teams from the winners field 
  if [[ $WINNER != 'winner' ]]
    then 
    #get team_id
    TEAM_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    #if not found 
    if [[ -z $TEAM_ID ]]
      then  
      #insert team
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values ('$WINNER')")
    fi
  fi
  #do the same from the opponents field
  if [[ $OPPONENT != 'opponent' ]]
    then 
    #get team_id
    TEAM_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    #IF NOT FOUND 
    if [[ -z $TEAM_ID ]]
      then 
        #insert team 
        INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values ('$OPPONENT')")
    fi
  fi
  if [[ $W_GOALS != 'winner_goals' ]]
    then
      if [[ $OPP_GOALS != 'opponent_goals' ]]
        then
        #get teamID
        WIN_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
        OPP_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
        #insert game info
        GAME=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $W_GOALS, $OPP_GOALS)")
      fi
  fi
done