#! /bin/bash

echo $1

if [[ $1 ]]
then
  rm -rf "data/$1.csv"
  curl -o temp.csv "http://performance.morningstar.com/Performance/stock/exportStockPrice.action?t=XNAS:$1"

  cat temp.csv | grep "2012-\|2013-" > "data/$1.csv"

else
  FILE="../config/symbol_list.txt"

  exec 0<"$FILE"
  n=0
  while read -r symbol
  do
    echo "${symbol}"
    rm -rf "data/${symbol}.csv"
echo "http://performance.morningstar.com/Performance/stock/exportStockPrice.action?t=XNYS:${symbol}"
    curl -o temp.csv "http://performance.morningstar.com/Performance/stock/exportStockPrice.action?t=XNAS:${symbol}"

    file_size=$(stat -c %s temp.csv)
    echo $file_size
    if [ $file_size > 0 ]
    then
      cat temp.csv > "../morningstar/price/${symbol}.csv"
    fi

   rm -rf temp.csv
  done
fi


