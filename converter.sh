#!/bin/bash
function display_help
{
  clear
  echo "This script converts currencies"
  echo "By default it converts EUR to PLN"
  echo "USAGE:"
  echo "./converter.sh [OPTIONS] [VALUE]"
  echo "OPTIONS:"
  echo "-h/--help Displays help"
  echo "-f [CURRENCY]/--from=[CURRENCY] Currency you want to convert"
  echo "-t [CURRENCY]/--to=[CURRENCY] Curency you want to convert to"
  echo "-d [DATE]/--date=[DATE] Date of considered rates in format YYYY-MM-DD"
  echo "EXAMPLE:"
  echo "./converter.sh -f GBP -t USD -d 2018-10-16 10.37"
  exit
}
base="EUR"
to="PLN"
update=0
updatetime=3000
tmp="/tmp/rates.json"
date="$(date +'%Y-%m-%d')"
xdate="\"$date\""
xbase="\"$base\""
while getopts "h:f:t:d:-:" OPTION
do
case $OPTION in
h) display_help;;
f) base="$OPTARG";;
t) to="$OPTARG";;
d) date="$OPTARG";;
-) case $OPTARG in
           help    )  display_help ;;
           from=*)
                    base=${OPTARG#*=}
                    ;;
           to=*)  to=${OPTARG#*=} ;;
           date=*)  date=${OPTARG#*=} ;;
           '' )        break ;;
           * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
         esac ;;
*) echo "Błędna opcja"; exit 1;;
esac
done
shift $((OPTIND-1))
key="https://api.exchangeratesapi.io/$date?base=$base"
function updateData()
{
	curl --create-dirs -o $tmp $key
}
function getData()
{
	if [ -f $tmp ]
	then
		currentDate="$(date +%s)"
		tmpModTime="$(date -r $tmp +%s)"
		modTime=$((currentDate-tmpModTime))
		tmpDate="$(cat $tmp | jq '.date')"
    tmpBase="$(cat $tmp | jq '.base')"
		if [[ "$xdate" != "$tmpDate" ]] && [[ "$xbase" != "$tmpBase" ]]
		then
			modTime=$(($updatetime+1))
		fi
	else
			modTime=$(($updatetime+1))
	fi
	if [[ $modTime -gt $updatetime ]]
	then
		updateData
	fi
}
getData
toString=".rates.$to"
jsonEuro="$(cat $tmp | jq "$toString")"
clear
if [ -z "$1" ]
  then
  echo "No value to convert"
  else
  echo "$base to $to"
  echo "$base value $jsonEuro"
  echo "scale=2;
  ($jsonEuro * $1)/1;" | bc
fi
