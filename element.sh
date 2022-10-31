PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"

# function to get information about an element from the database
GET_INFO() {
  if [[ $1 =~ ^[0-9]$ ]]
  then
    ELEMENT_INFORMATION=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                          FROM elements AS e 
                            INNER JOIN properties AS p USING(atomic_number)
                            INNER JOIN types AS t USING(type_id)
                            WHERE e.atomic_number = $1;")
  else
    ELEMENT_INFORMATION=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                          FROM elements AS e 
                            INNER JOIN properties AS p USING(atomic_number)
                            INNER JOIN types AS t USING(type_id)
                            WHERE e.symbol = '$1' OR e.name = '$1';")
  fi

  # If query returns empty
  if [[ -z $ELEMENT_INFORMATION ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT_INFORMATION | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
}

# If the script is missing an argument, message the user and exit
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # fetch info from database
  GET_INFO $1
fi
