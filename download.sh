symbols=("AA" "S")

for i in {0..1}
do
    symbol=${symbols[$i]}
    echo symbol
    rm -rf temp.csv
    rm -rf "data/${symbol}.csv"
    curl -o temp.csv "http://ichart.finance.yahoo.com/table.csv?s=${symbol}&a=00&b=1&c=2012&d=03&e=30&f=2013&g=d&ignore=.csv"
    cat temp.csv | grep "2012-\|2013-" > "data/${symbol}.csv"
done
