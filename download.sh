symbols=("AA" "GE")

for i in {0..1}
do
    symbol=${symbols[$i]}
    rm -rf temp.csv
    curl -o temp.csv "http://ichart.finance.yahoo.com/table.csv?s=${symbol}&a=00&b=1&c=2012&d=03&e=30&f=2013&g=d&ignore=.csv"
    cat temp.csv | grep "2012-\|2013-" > "${symbol}.csv"
done
