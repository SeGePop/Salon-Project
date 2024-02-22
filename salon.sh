#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~Welcome to Segecuts!~~~\n"

MAIN_MENU() {
if [[ $1 ]]
  then
    echo -e "\n$1"
  fi  
  # Display services
  echo -e "\nChoose a service:"
  echo -e "\n$($PSQL "SELECT * FROM services" | while read SERVICE_ID BAR NAME
  do
    if [[ -n $SERVICE_ID ]]; then
      echo "$SERVICE_ID) $NAME"
    fi
  done)"
  # choose service
  read SERVICE_ID_SELECTED
  # check if invalid service
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_ID ]]
    then
    MAIN_MENU "Invalid selection, please try again"
    else
    SELECT_SERVICE
  fi
}

SELECT_SERVICE () {
  
  # insert service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  # if valid service selected, get phone number
  echo -e "\nPlease provide a phone number:"
  read CUSTOMER_PHONE
  # if they're not a customer, ask for a name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nPlease provide a name:"
    read CUSTOMER_NAME
    # insert the new data into the table
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi
  # read customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # ask for service time
  echo -e "\nPlease select a time:"
  read SERVICE_TIME
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
  echo -e "I have put you down for a $(echo $SERVICE_NAME | sed 's/ //g') at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU