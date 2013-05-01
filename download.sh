FILE="config/symbol_list.txt"


exec 0<"$FILE"
n=0
while read -r symbol
do
  rm -rf "data/${symbol}.csv"
  curl -o temp.csv "http://ichart.finance.yahoo.com/table.csv?s=${symbol}&a=00&b=1&c=2012&d=03&e=30&f=2013&g=d&ignore=.csv"
  cat temp.csv | grep "2012-\|2013-" > "data/${symbol}.csv"

  rm -rf temp.csv
done



