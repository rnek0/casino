#!/bin/bash
#
# Les Arrays 
#

declare -a myArray=(1 2 3 4)

declare -i number=1

myArray+=(5)
myArray+=(5 6 7 8)

echo
echo " Nombre d'éléments dans l'array ${#myArray[@]}"
echo
echo " Tous les éléments : ${myArray[@]}"
echo
echo " Premier element : ${myArray[0]}"
echo " Dernier élément : ${myArray[-1]}"
echo

unset myArray[0]
unset myArray[-1]

echo " On a supprimé deux éléments"
echo " Nombre d'éléments :${#myArray[@]}"
echo
echo " Tous les éléments : ${myArray[@]}"

myArray=(${myArray[@]}) # CECI EST IMPORTANT LORSQU'ON EFFACE L'ELEMENT 0 IL FAUT REASIGNER SINON LA SORTIE DU PREMIER ELEMENT EST FAUSSE !!!

echo
echo " Premier element : ${myArray[0]}"
echo " Dernier élément : ${myArray[-1]}"
echo