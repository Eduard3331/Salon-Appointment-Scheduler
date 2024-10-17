#!/bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~\n"

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU(){
  if [[ $1 ]]
  then
  echo -e "\n$1"
  else
  echo -e "\nWelcome to My Salon, how can I help you?\n"
  fi
SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services")
echo "$SERVICE_LIST" | while read SERVICE_ID BAR SERVICE_NAME
do
   echo "$SERVICE_ID) $SERVICE_NAME"
  done
read SERVICE_ID_SELECTED
VALID_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $VALID_ID ]]
then
   MAIN_MENU "Invalid service."
else
  GET_SERVICE $SERVICE_ID_SELECTED
  fi
}

GET_SERVICE(){
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$1")
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ //g')
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
    then
    echo -e "\nPlease enter your name:"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/ //g')
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nPlease set a time for your $SERVICE_NAME appointment, $CUSTOMER_NAME:"
  read SERVICE_TIME
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$1','$SERVICE_TIME')")
      SERVICE_TIME_FORMATTED=$(echo $SERVICE_TIME | sed 's/ //g')
    echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME_FORMATTED, $CUSTOMER_NAME_FORMATTED."
}

MAIN_MENU