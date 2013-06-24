#! /bin/bash

echo $1

if [[ $1 ]]
then
  rm -rf "data/$1.csv"
  curl -o temp.csv "http://ichart.finance.yahoo.com/table.csv?s=$1&a=00&b=1&c=2012&d=04&e=28&f=2013&g=d&ignore=.csv"
  cat temp.csv | grep "2012-\|2013-" > "data/$1.csv"

else
  FILE="config/symbol_list.txt"

  exec 0<"$FILE"
  n=0
  while read -r symbol
  do
    echo "${symbol}"
    rm -rf "data/${symbol}.csv"
    curl -o temp.csv "http://financials.morningstar.com/ajax/exportKR2CSV.html?t=${symbol}"
    cat temp.csv > "morningstar/${symbol}.csv"

   rm -rf temp.csv
  done
fi


