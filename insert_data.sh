#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

# While loop with multiple if statements for insertion of data into the teams table

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Nested if statements for the insertion of data into the teams table

  TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

  if [[ $WINNER != "winner" ]]
    then
      if [[ -z $TEAMS ]]
        then
          FIRST_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")

          if [[ $FIRST_TEAM_INSERT == "INSERT 0 1" ]]
            then
              echo Inserted into teams, $TEAMS
          fi
      fi
  fi

  OTHER_TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

  if [[ $OPPONENT != "opponent" ]]
    then
      if [[ -z $OTHER_TEAMS ]]
        then
          SECOND_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")

          if [[ $SECOND_TEAM_INSERT == "INSERT 0 1" ]]
            then
              echo Inserted into teams, $OTHER_TEAMS
          fi
      fi
  fi

# Nested if statements for the insertion of data into the games table

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -n $WINNER_ID || -n $OPPONENT_ID ]]
    then
      if [[ $YEAR != "year" ]]
        then
          INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
        
          if [[ $INSERT_GAMES == "INSERT 0 1" ]]
            then
              echo Inserted into games, $YEAR
          fi
      fi    
  fi
done
