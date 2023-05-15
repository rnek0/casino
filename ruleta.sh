#! /bin/bash

#set -euo pipefail

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
    echo -e "\n\n${redColour}[!] Saliendo ...${endColour}\n"
    tput cnorm
    exit 1
}

trap ctrl_c INT

# Vars
initial_bet=0
par_impar="par"

# Banner
function casino(){
    RED=$(printf '\033[31m')
    BLUE=$(printf '\033[34m')
    RESET=$(printf '\033[m')
    cat <<EOM
${RED}
    ··········································
${BLUE}          _________   _____ _____   ______ 
         / ____/   | / ___//  _/ | / / __ \\
        / /   / /| | \__ \ / //  |/ / / / /
       / /___/ ___ |___/ // // /|  / /_/ / 
       \____/_/  |_/____/___/_/ |_/\____/  
                                   
${RED}    ··········································
${RESET}
EOM
}

# Ayuda
function helpPanel(){
    echo -e "\n${yellowColour}[*]${grayColour} Uso:${purpleColour} $0${endColour}\n"
    echo -e "\t${blueColour}-m)${grayColour} Dinero con el que se desea jugar${endColour}"
    echo -e "\t${blueColour}-t)${grayColour} Téchnica a utilizar ${purpleColour}(${yellowColour}martingala${blueColour}/${yellowColour}inverseLabrouchere${purpleColour})${endColour} \n"
    exit 0
}

# Martingala
function martingala(){
    echo -e "\n${yellowColour}[+]${grayColour} Vamos a jugar con la technica ${blueColour}$technique ${endColour}"
    echo -e "\n${yellowColour}[+]${grayColour} Dinero actual:${yellowColour} $money € ${endColour}\n "
    echo -ne "${yellowColour}[?]${grayColour} Cuanto dinero tienes pensado apostar ? -> ${endColour}" && read initial_bet
    echo -ne "${yellowColour}[?]${grayColour} A que deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar
    echo -ne "\n${yellowColour}[+]${blueColour} Jugamos con una cantidad inicial de ${initial_bet} € a $par_impar ${endColour}\n\n"

    backup_bet=${initial_bet}

    # Contador de jugadas
    play_counter=0
    # Jugadas malas
    jugadas_malas="[ "
    #tope ganado
    tope_ganado=0
    ganado=0

    tput civis

    # JUGANDO   
    while true; do
    sleep 0.1
    if [ "$par_impar" == "par" ] || [ "$par_impar" == "impar" ]; then
        money=$(($money - $initial_bet))
        random_number="$(($RANDOM % 37))"
        echo -e "${yellowColour}[+]${grayColour} Ha salido el numero ${blueColour}${random_number}${endColour}"
    
        # SI SELECCIONAMOS PAR
        if [ "$par_impar" == "par" ]; then
            if [ $(($random_number % 2)) -eq 0 ]; then

                # Todos pierden, sale el 0 y gana el casino.
                if [ $random_number -eq 0 ]; then
                    echo -e "${yellowColour}[-]${grayColour} Ha salido el 0 , por tanto todos pierden.${endColour}"  
                    ganado=0
                    jugadas_malas+="$random_number "
                    # Siempre que pierdas duplicas lo apostado.
                    initial_bet=$(($initial_bet * 2))
                    #echo -e " ··· Te quedas en ${money}€ ··· "
                    echo
                    #break
                else
                    echo -e "${yellowColour}[+]${grayColour} El numero que ha salido es par, \t${greenColour}ganas !${endColour}" # suma el beneficio (apuesta x 2)
                    jugadas_malas="[ "    
                    # ganas el doble de lo apostado
                    reward=$(($initial_bet * 2))
                    ganado=$reward
                    #echo -e "${yellowColour}[+]${grayColour} Ganas un total de ${yellowColour}${reward}€${endColour}"
                    money=$(($money+$reward))
                    #echo -e "Tienes ${money}€"
                    echo
                fi
            else 
                echo -e "${yellowColour}[-]${grayColour} El numero que ha salido es impar, \t${redColour}pierdes !${endColour}"
                jugadas_malas+="$random_number "
                # Siempre que pierdas duplicas lo apostado.
                initial_bet=$(($initial_bet * 2))
                ganado=0
                #echo -e " ··· Te quedas en ${money}€ ··· "
                echo
            fi
        play_counter=$(($play_counter + 1))
        else
        # SELECCIONAMOS IMPAR

            if [ $(($random_number % 2)) -eq 1 ]; then

                # Todos pierden, sale el 0 y gana el casino.
                if [ $random_number -eq 0 ]; then
                    echo -e "${yellowColour}[-]${grayColour} Ha salido el 0 , por tanto todos pierden.${endColour}"  
                    ganado=0
                    jugadas_malas+="$random_number "
                    # Siempre que pierdas duplicas lo apostado.
                    initial_bet=$(($initial_bet * 2))
                    #echo -e " ··· Te quedas en ${money}€ ··· "
                    echo
                    #break
                else
                    echo -e "${yellowColour}[+]${grayColour} El numero que ha salido es impar, \t${greenColour}ganas !${endColour}" # suma el beneficio (apuesta x 2)
                    jugadas_malas="[ "    
                    # ganas el doble de lo apostado
                    reward=$(($initial_bet * 2))
                    ganado=$reward
                    #echo -e "${yellowColour}[+]${grayColour} Ganas un total de ${yellowColour}${reward}€${endColour}"
                    money=$(($money+$reward))
                    echo -e "Tienes ${money}€"
                    echo
                fi
            else 
                echo -e "${yellowColour}[-]${grayColour} El numero que ha salido es par, \t${redColour}pierdes !${endColour}"
                jugadas_malas+="$random_number "
                # Siempre que pierdas duplicas lo apostado.
                initial_bet=$(($initial_bet * 2))
                ganado=0
                #echo -e " ··· Te quedas en ${money}€ ··· "
                echo
            fi

        play_counter=$(($play_counter + 1))
        fi
        
    else
        echo -e "La apuesta debe ser par o impar"    
        break
    fi
    
    if [[ ${money} -gt ${tope_ganado} ]]
    then 
        tope_ganado=${money}; 
    fi

    # Fin del juego, perdiste todo el dinero, o no puedes doblar la apuesta.
    if [[ ${money} -eq 0 ]] || [[ ${money} -le 0 ]] || [[ ${money} -le ${initial_bet} ]]; then
    #if [[ ${money} -le 0 ]]; then
        echo -e "${yellowColour}[!]${redColour} Jugaste a \"${par_impar}\" y te has quedado sin pasta cabron ! o no puedes doblar la apuesta ; ${endColour}"
        echo -e "${yellowColour}[!]${grayColour} Lo maximo que ganaste fué ${blueColour}${tope_ganado}${endColour}"
        echo -e "${yellowColour}[!]${grayColour} Han habido un total de ${blueColour}${play_counter}${grayColour} jugadas.${endColour}"
        echo -e "${yellowColour}[!]${grayColour} A continuacion se van a representar las malas jugadas consecutivas que han salido ${endColour}${blueColour} ${jugadas_malas}].${endColour}"
        echo -e "${yellowColour}[+]${grayColour} Fin de las apuestas, tienes ${money} €, gracias por haber jugado en nuestro casino\n    Hasta la proxima !\n ${blueColour}${endColour}"
        break
    fi

    done
    tput cnorm
}

# inverseLabrouchere
function inverseLabrouchere(){
    declare -a my_sequence=(1 2 3 4)

    echo -e "\n${yellowColour}[+]${grayColour} Vamos a jugar con la technica ${blueColour}$technique ${endColour}"
    echo -e "\n${yellowColour}[+]${grayColour} Dinero actual:${yellowColour} $money € ${endColour}\n "
    echo -ne "${yellowColour}[?]${grayColour} A que deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

    echo -ne "${yellowColour}[+]${grayColour} Comenzamos con la secuencia [${my_sequence[@]}] ${endColour}"

    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))


    unset my_sequence[0]
    unset my_sequence[-1]
    my_sequence=(${my_sequence[@]})

    echo -ne "\n${yellowColour}[+]${grayColour} Invertimos ${yellowColour}${bet}€${grayColour} y nuestra secuencia se queda en [${my_sequence[@]}] ${endColour}"

    tput civis
    while true; do
        random_number=$(($RANDOM % 37))
        echo -e "\n${yellowColour}[+]${grayColour} Ha salido el numero ${random_number}"

        if [ "$par_impar" == "par" ]; then
            if [ "$(($random_number % 2))" -eq 0 ]; then
                echo -e "\n${yellowColour}[+]${grayColour} El numero es par ¡ Ganas !${endColour}"
            else
                echo -e "\n${redColour}[!]${grayColour} El numero es impar ¡ Pierdes !${endColour}"
            fi    
        fi
        
        sleep 2
    done
    tput cnorm
}


# sleep 5

# Banner
casino
if [[ $# -le 1 ]] ; then
    helpPanel
fi

# Menu
while getopts "m:t:,h" arg; do 
    case $arg in 
        m) money="$OPTARG";;
        t) technique="$OPTARG";;
        h) helpPanel;;
    esac
done



echo -e ">>> ${money} et ${technique} \n"

if [ $money ] && [ $technique ]; then
    
    if [[ $money -le 0 ]]
    then
        echo -e "No money, no game !!!"
        exit 0 
    else

        if [[ "$technique" == "martingala" ]]; then
           #echo -e "SE TENSO con la martingala !"
            martingala $technique $money
        elif [[ "$technique" == "inverseLabrouchere" ]]; then
            #echo -e "SE TENSO con inverseLabrouchere !"
            inverseLabrouchere $technique $money
        else
           echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}"
           helpPanel
        fi
   
    fi
else
    echo -e "[!] Olvidaste las reglas !"
    helpPanel
fi
