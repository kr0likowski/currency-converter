# Currency-converter
This script converts currencies
By default it converts EUR to PLN

## USAGE:
./converter.sh [OPTIONS] [VALUE]

## OPTIONS:
-h/--help Displays help
-f [CURRENCY]/--from=[CURRENCY] Currency you want to convert
-t [CURRENCY]/--to=[CURRENCY] Curency you want to convert to
-d [DATE]/--date=[DATE] Date of considered rates in format YYYY-MM-DD

## EXAMPLE:
./converter.sh -f GBP -t USD -d 2018-10-16 10.37
