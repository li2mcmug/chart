#!/usr/bin/ruby

require 'mysql'
require 'csv'
require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'

con = Mysql.new 'localhost', 'root', 'comp0707', 'stocks'
csv_to_field = {
  "Revenue.*Mil" => "revenue",
  "GrossMargin.*%" => "gross_margin_percent",
  "OperatingIncome.*Mil" => "operating_income",
  "OperatingMargin.*%" => "operating_margin_percent",
  "NetIncome.*Mil" => "net_income",
  "EarningsPerShare" => "eps",
  "Dividends" => "dividends",
  "PayoutRatio.*%" => "payout_ratio",
  "Shares.*Mil" => "shares",
  "BookValuePerShare" => "bvps",
  "OperatingCashFlow.*Mil" => "operating_cash_flow",
  "CapSpending.*Mil" => "cap_spending",
  "FreeCashFlow.*Mil" => "free_cash_flow",
  "FreeCashFlowPerShare" => "free_cash_flow_per_share",
  "WorkingCapital.*Mil" => "working_capital"
}
multiples = {
  "revenue" => 1000000,
  "operating_income" => 1000000,
  "net_income" => 1000000,
  "shares" => 1000000,
  "operating_cash_flow" => 1000000,
  "cap_spending" => 1000000,
  "free_cash_flow" => 1000000,
  "working_capital" => 1000000
}


begin
  Dir.foreach("/home/li2mcmug/workspace/chart/morningstar") do |file|
    puts file
    years = nil
    symbol = nil
    year_values = {} 

    next if !file.match("csv") || File.directory?("/home/li2mcmug/workspace/chart/morningstar/#{file}")

    CSV.foreach("/home/li2mcmug/workspace/chart/morningstar/#{file}", { quote_char: "\x00"}) do |row|
      symbol = file.split(".")[0]
      row = row.join(',').gsub(/(?m),(?=[^"]*"(?:[^"\r\n]*"[^"]*")*[^"\r\n]*$)/,'')
              .gsub(' ','').split(',')

      if row.any?{|field| /201\d-/.match(field)}
        years = row.map{|field| field ? field + "-01": ''}
      end

      break if (row[0] && row[0].match("CAD")) || file.split(".").size() > 2

      next if row[0].nil? || csv_to_field.select{|k| row[0].match(k)}.empty?
      field_name = csv_to_field.select{|k, v| row[0].match(k)}.first.last

      for i in 1..10
        next if row[i].nil?
        row[i].sub!(',', '')
        row[i].sub!('"', '')
        amount = row[i].to_f
        if year_values.has_key?(years[i])
          year_values[years[i]] << [field_name, amount]
        else
          year_values[years[i]] = [[field_name, amount]]
        end
      end
    end

    year_values.keys.each do |year|
      next if year_values[year].empty?
      insert_stmt = "insert into symbols(symbol, year"
      value_stmt = " values(\'#{symbol}\',\'#{year}\'"
      update_stmt = " on duplicate key update "
      year_values[year].each do |field_value|
	column_name = field_value.first
        column_value = field_value.last.to_f
        if multiples.has_key?(column_name)
          column_value *= multiples[column_name]
        end
        insert_stmt += ", #{column_name}"
        value_stmt += ", #{column_value}"
        update_stmt += "#{column_name} = #{column_value}, "
      end
      insert_stmt += ")"
      value_stmt += ")"
      update_stmt = update_stmt.chop.chop
      query = insert_stmt + value_stmt + update_stmt
      puts query
      rs = con.query query
    end    
   
  end
rescue Mysql::Error => e
  puts e.errno
  puts e.error
    
ensure
  con.close if con
end
