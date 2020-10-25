#!/bin/bash

LOCAL_TIME=$(date +%s)

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
    while [[ $COMMAND != "quit" ]]
    do 
        echo -n "servidor> "
        read COMMAND
        if [ $COMMAND == "list" ]
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
            quit
        fi
    done
}

function create_user() {
    echo "create_user"
    awk '{print $1}' users | grep -q $1
    if [ $? -eq 1 ]
    then
        echo $1 $2 "absent" >> users
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
        sed -i "s/$1 $2 absent/$1 $2 logged/" users
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

function cliente() {
    LOGGED=false
    while [[ $COMMAND != "quit" ]]
    do 
        echo -n "cliente> "
        read COMMAND FIRST_ARGUMENT SECOND_ARGUMENT
        if [ $COMMAND == "list" ]
        then
            cliente_list $LOGGED
        elif [ $COMMAND == "create" ]
        then
            create_user $FIRST_ARGUMENT $SECOND_ARGUMENT
        elif [ $COMMAND == "time" ]
        then 
            servidor_time
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



if [ $1 == "servidor" ]
then 
    servidor
elif [ $1 == "cliente" ]
then 
    cliente
fi



exit 1