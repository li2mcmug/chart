#! /bin/bash

echo $1

if [[ $1 ]]
then
  rm -rf "data/$1.csv"
  curl -o temp.csv "http://ichart.finance.yahoo.com/table.csv?s=$1&a=00&b=1&c=2001&d=10&e=28&f=2013&g=d&ignore=.csv"
  cat temp.csv | grep "2000-\|2001-\|2002-\|2003-\|2004-\|2005-\|2006-\|2007-\|2008-\|2009-\|2010-\|2011-\|2012-\|2013-" > "data/$1.csv"

else
  FILE="config/symbol_list.txt"

  exec 0<"$FILE"
  n=0
  while read -r symbol
  do
    echo "${symbol}"
    rm -rf "data/${symbol}.csv"
    curl -o temp.csv "http://ichart.finance.yahoo.com/table.csv?s=${symbol}&a=00&b=1&c=2001&d=10&e=28&f=2013&g=d&ignore=.csv"
    cat temp.csv | grep "2000-\|2001-\|2002-\|2003-\|2004-\|2005-\|2006-\|2007-\|2008-\|2009-\|2010-\|2011-\|2012-\|2013-" > "data/${symbol}.csv"

   rm -rf temp.csv
  done
fi


