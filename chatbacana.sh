#!/bin/bash

LOCAL_TIME=$(date +%s)
# This could be used to prevent dumb shit
LOGGED_TOKEN
ABSENT_TOKEN

function list() {
    grep "logged" users | awk '{print $1}'
}

# $1 -> Logged status
function cliente_list {
    if [ $1 = true ]
    then 
        grep "logged" users | awk '{print $1}'
        return 0
    else 
        echo "ERRO"
        return 1
    fi
}

function servidor_time() {
    NEW_TIME=$(date +%s)
    echo $(($NEW_TIME - $LOCAL_TIME))

}

function reset() {
    echo > users
}

function servidor_quit() {
    echo "quit"
    rm users
}

function servidor() {
    > users
    while [[ $COMMAND != "quit" ]]
    do 
        echo -n "servidor> "
        read COMMAND
        if [ -z $COMMAND ]
        then
            continue
        elif [ $COMMAND == "list" ]
        then
            list
        elif [ $COMMAND == "time" ]
        then 
            servidor_time
        elif [ $COMMAND == "reset" ]
        then 
            reset
        elif [ $COMMAND == "quit" ]
        then 
            servidor_quit
        fi
    done
}

function change_password() {
    USERNAME=$1
    OLD_PASSWORD=$2
    NEW_PASSWORD=$3
    grep -Eq "$USERNAME $OLD_PASSWORD (logged|absent)" users 
    if [ $? -eq 0 ]
    then
        sed -ir "s/$USERNAME $OLD_PASSWORD \([a-zA-Z0-9]*\)/$USERNAME $NEW_PASSWORD \1/" users
        return 0
    else 
        echo "ERRO"
        return 1
    fi
}


function check_user_existence() {
    USERNAME=$1
    awk '{print $1}' users | grep -q $USERNAME
    return $?
}

function create_user() {
    echo "create_user"
    check_user_existence $1
    if [ $? -eq 1 ]
    then
        echo $1 $2 "absent /dev/pts/0" >> users
        return 0
    else 
        echo "ERRO"
        return 1
    fi

}

function login() {
    echo "login"
    # Check if the user exists, the password is right and user is absent
    grep -q "$1 $2 absent" users
    # If both conditions are true, check if the 
    if [[ $? -eq 0 && $3 == false ]]
    then
        TERMINAL_ADDRESS=$(tty)
        sed -ir "s|$1 $2 absent /dev/pts/[0-9]*|$1 $2 logged $TERMINAL_ADDRESS|" users
        return 0
    else 
        echo "ERRO"
        return 1
    fi
}

# $1 -> username $2 -> logged
function cliente_logout() {
    echo "logout"
    if [ $2 = true ]
    then
        sed -ir "s/$1 \([a-zA-Z0-9]*\) logged/$1 \1 absent/" users
        return 0
    else 
        echo "ERRO"
        return 1
    fi
}

function msg_user() {
    LOGGED_STATUS=$1
    SENDER_USERNAME=$2
    RECEIVER_USERNAME=$3
    MESSAGE_STRING=${@:4}
    # Check if both sender and receiver are logged
    read _ _ _ TERMINAL_ADRESS < <(grep -E "$RECEIVER_USERNAME [a-zA-Z0-9]* logged" users)
    if [[ $? == 0 && $LOGGED_STATUS == true ]]
    then 
        #TERMINAL_ADRESS="/dev/pts/3"
        echo "[Mensagem do $SENDER_USERNAME]:" $MESSAGE_STRING > "$TERMINAL_ADRESS"
        return 0
    else 
        echo "ERRO"
        return 1
    fi
}

function cliente() {
    LOGGED=false
    while [[ $COMMAND != "quit" ]]
    do 
        echo -n "cliente> "
        read COMMAND FIRST_ARGUMENT SECOND_ARGUMENT THIRD_ARGUMENT
        # Check for null argumet
        if [ -z $COMMAND ]
        then 
            continue
        elif [ $COMMAND == "list" ]
        then
            cliente_list $LOGGED
        elif [ $COMMAND == "create" ]
        then
            create_user $FIRST_ARGUMENT $SECOND_ARGUMENT
        elif [ $COMMAND == "msg" ]
        then 
            msg_user $LOGGED $USER $FIRST_ARGUMENT $SECOND_ARGUMENT $THIRD_ARGUMENT
        elif [ $COMMAND == "passwd" ]
        then 
            change_password $FIRST_ARGUMENT $SECOND_ARGUMENT $THIRD_ARGUMENT
        elif [ $COMMAND == "login" ]
        then 
            login $FIRST_ARGUMENT $SECOND_ARGUMENT $LOGGED
            if [ $? -eq 0 ]
            then 
                USER=$FIRST_ARGUMENT
                LOGGED=true
            fi
        elif [ $COMMAND == "logout" ]
        then 
            cliente_logout $USER $LOGGED
            LOGGED=false
        elif [ $COMMAND == "quit" ]
        then 
            cliente_quit $USER $LOGGED
        fi
    done
}

function cliente_quit() {
    echo "quit"
    USERNAME=$1
    LOGGED_STATUS=$2
    if [ $LOGGED_STATUS  = true ]
    then
        cliente_logout $USERNAME $LOGGED_STATUS
    fi
    return 0
}

function main() {
    if [ $# -ne 1 ]
    then 
        exit 1
    elif [ $1 == "servidor" ]
    then 
        servidor
    elif [ $1 == "cliente" ]
    then 
        cliente
    fi
}

main $1

exit 0
