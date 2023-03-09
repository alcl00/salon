#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c "

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "Welcome to My Salon, how can I help you?\n"
  SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id")

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo -e "$SERVICE_ID) $NAME"
  done
  echo -e "6) Exit"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SET_APPOINTMENT 1 ;;
    2) SET_APPOINTMENT 2;;
    3) SET_APPOINTMENT 3 ;;
    4) SET_APPOINTMENT 4 ;;
    5) SET_APPOINTMENT 5 ;;
    6) EXIT ;;
    *) MAIN_MENU "Please enter a valid option"
  esac

}

SET_APPOINTMENT(){

  SERVICE_ID_SELECTED=$1
  SERVICE_NAME="$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")"

  echo -e "What is your phone number?"
  read CUSTOMER_PHONE

  # get customer info
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi

  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  # get appointment time
  echo "What time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
  read SERVICE_TIME

  # Add appointment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id,time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  MAIN_MENU
}

EXIT() {
  echo -e "Have a nice day!"
}
MAIN_MENU
