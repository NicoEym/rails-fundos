class DownloadJob < ApplicationJob
  queue_as :default
  require "date"
  require "csv"
  require "open-uri"
  require 'stringio'

  def get_date(date)
    # method to get the date
    year = date[0, 4].to_i
    puts year
    month = date[5, 7].to_i
    puts month
    day = date[8, 10].to_i
    puts day
    date_format_YMD = Date.new(year, month, day)

    date_calendar = Calendar.find_by(day: date_format_YMD)
    date_calendar = Calendar.create(day: date_format_YMD) if date_calendar.nil?

    date_calendar
  end

  def write_daily_data_fund
    # we list the url from economatica to get the fund data
    urlCDI = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/j9ScUlOFDYYsEOihvscfgPe8qHolC%2FqwVKR5cDK3HBkiPMrVtIT7uj3uP7JKxcZ0Xc5BU%2FJ7gwMns0rbucgaWGYy2RMtS9xEQtSqvF5wM4C8mGbog2dZW4bydAuisQo%2BKTS0TJ%2Fyfg7C6JScf7qZK2SbS0IBJsB1hcbYce%2BHBtTsNag9Wy%2F3FBUUXPUqWIDTPq1bDk6g2qDsDXnAPiqdmtGan6qGke3pNcJ0jaHR%2BSObNqcfoMtcD3%2FFEBSaopLLc87nCZGTeBVT1ifg5MPO1Dsa4yXNJSL%2BIEsgWsS69ywtXf7P34A5hm1VmzQRzb3N2XXbIXwQgYujka7NS%2BWUHg%3D%3D'
    urlIbov = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/rGm9Zy17%2BNapl9t81EXK6TrtRuA0IkEAvcW7YVoajp7%2BjYODvTiszYO54mdy9mllCKf2IY%2Fje1vu7oQokV5%2F5Yc1U3%2FrYTfBZrSfzP2%2FRPp7%2BC5yVsFCidYaNp5n3BXM8aBX%2FCaMJ%2BaPg9LVDgndX0zxGgnuSHShapZAb4PTpLzYnte7cVru61DehhBpG2qEh%2F9moARwWa%2FjeiPSjBqbbZVzIo4CbS2uG7s5YEUeCq%2F9i4cCry0TaE3uTZKacX2ULRF5nyy11jWLSe28mZ58g%2BzXnrZ9dKWLcO2RWgQMHuDSas1aJYul8hQXaxA%2FYGaZk5SI15szsLj6s2gvARp5wA%3D%3D'
    urlIMAB = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/dX3h0i5dYjVRhjpXiuGcU3zRacYT1fTzLoEJCm241swQhX3GustOxINqs5%2B4i5Yhw3A1LvRQZEYP%2B5pAYRC0IjHmAz%2BDWnI60N6LLuxg6EysNz5hFXxg2OZoN5dYNyXYGucCWWCodzL6ihrMvkKDR%2F7xYBtw0jZoYHlgo5w6EWx6%2B97theuoAt0wnxjSAuquM7dbpseGgQhNUcPA43F%2BXaMCsLN16TLgky%2FN8DrU%2BOhX4pTzmCjH0NrkCSXXmBh4ayDgFcTmn0yuxSRJ26QmB1X7NpVMy7RiNd%2BbU0xUSrL4fWXJMlKDIKF7DlyXVC0qQBNHRQG0R5B%2BdkIsZXIA5g%3D%3D'
    urldesfazado = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/k3U7mKyQEEgfo6ApFfAnLyoeOWi9rf%2FIk8Ni3QiotobOY%2BXUKwgofTn3IWnWWMukk%2BSLXD%2FbnjKR1AQ2coqQCzeGWesbIN0vryAisHXeNvd1R26%2BcjD%2FzQgLdAjzyptQVscFb1Fn%2BQFg7DLtPyTopH1%2FWqexIS3%2BQo7zIfvWVDEqGI0tJJpDOlIJ0%2B48wHPcnKxrjk6pKJP6DiK9nBcGTmzpRHUxkYkfrcSGomUed9CVdeRmig%2BLHnAKRPdkcwNYyReWTEIIOPmoprOteNH4%2BTi41MIxOdrhUkikED90knaI1C1PRxF02pl%2FkVVC4S1jKizddAGqjoq1oraUCum%2BdQ%3D%3D'
    urls = [urlCDI, urlIbov, urlIMAB, urldesfazado]

    urls.each do |url|
      download = open(url)
      csv = CSV.parse(download, encoding: 'utf-8', :headers => true)

      csv.each do |row|
        codigo = row['Ativo'][0, 6].to_i
        fund = Fund.find_by(codigo_economatica: codigo)
        puts fund

        date = get_date(row['Date'])
        puts date.day

        datas = DailyDatum.find_by(fund: fund, calendar: date)

        if datas.nil?
          puts "nil"
          DailyDatum.create(aum: row['PL'], share_price: row['Cota'], return_daily_value: row['Daily return'],
                            return_weekly_value: row['Weekly return'], return_monthly_value: row['Monthly return'],
                            return_quarterly_value: row['Quarterly return'], return_annual_value: row['Yearly return'],
                            return_over_benchmark_daily_value: row['Spread Bench daily return'], return_over_benchmark_weekly_value: row['Spread Bench weekly return'],
                            return_over_benchmark_monthly_value: row['Spread Bench monthly return'], return_over_benchmark_quarterly_value: row['Spread Bench quarterly return'],
                            return_over_benchmark_annual_value: row['Spread Bench annual return'], volatility: row['Vol EWMA 97%'],
                            sharpe_ratio: row["Sharpe ratio"], tracking_error: row['Tracking error'],
                            application_weekly_net_value: row['Weekly Net Captation'],
                            application_monthly_net_value: row['Monthly Net Captation'],
                            application_quarterly_net_value: row['Quarterly Net Captation'],
                            application_annual_net_value: row['Yearly Net Captation'],fund: fund, calendar: date)
        else
          puts datas.fund.name
          puts datas.calendar.day
          datas.update(aum: row['PL'], share_price: row['Cota'], return_daily_value: row['Daily return'],
                       return_weekly_value: row['Weekly return'], return_monthly_value: row['Monthly return'],
                       return_quarterly_value: row['Quarterly return'], return_annual_value: row['Yearly return'],
                            return_over_benchmark_daily_value: row['Spread Bench daily return'], return_over_benchmark_weekly_value: row['Spread Bench weekly return'],
                            return_over_benchmark_monthly_value: row['Spread Bench monthly return'], return_over_benchmark_quarterly_value: row['Spread Bench quarterly return'],
                            return_over_benchmark_annual_value: row['Spread Bench annual return'], volatility: row['Vol EWMA 97%'],
                            sharpe_ratio: row["Sharpe ratio"], tracking_error: row['Tracking error'],
                            application_weekly_net_value: row['Weekly Net Captation'],
                            application_monthly_net_value: row['Monthly Net Captation'],
                            application_quarterly_net_value: row['Quarterly Net Captation'],
                            application_annual_net_value: row['Yearly Net Captation'],fund: fund, calendar: date)
        end
      end
    end
  end

  def write_daily_data_bench
    # we list the url from economatica to get the benchmark
    url = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/HUVTbYqYz0Ncb18HDZP4lsWchqywXj3Rq5qGUc%2F6i2GGO16xePr9ZrHNc3PosAHGLFoIhPAzJL%2BIcC7RptMTd1BZAef%2B2OLzJqZ9%2FOtENuGB1LZS19z1fJ%2BI8gw8kgDqszyBBM%2FwlxCvVKh2WjhpNyB2Lwiyd%2BgG72EGhKZsLIY8xFOP5KvrmYfsdU0Ee3mGlRr9KnFSkaWzG%2BzYEs6tQwijifx6mUFDpQelTC%2F6mzxG3bq1QazG7CHDMe%2FTOc6xHuaP8Nhbu2vy59xRlH%2Fi%2FC5eLtRsKP%2Fsnlm2a%2BkuMhAmvi2LbtCjX5HQYrhe70agGxq1xHSxIVVzQqyERX4T%2BQ%3D%3D'
    download = open(url)

    csv = CSV.parse(download, encoding: 'utf-8', :headers =>true)

    csv.each do |row|
      codigo = row['Ativo'][0, 3]
      puts codigo

      benchmark = BenchMark.find_by(codigo_economatica: codigo)
      puts benchmark

      date = get_date(row['Date'])
      puts date.day

      data = DataBenchmark.find_by(bench_mark_id: benchmark.id, calendar_id: date)

      if data.nil?
        data = DataBenchmark.create(daily_value: row['Cota'], return_daily_value: row['Daily return'], return_weekly_value: row['Weekly return'], return_monthly_value: row['Monthly return'], return_quarterly_value: row['Quarterly return'], return_annual_value: row['Yearly return'], volatility: row['Vol EWMA 97%'], bench_mark_id: benchmark.id, calendar: date)
        puts data.daily_value
      else
        data.update(daily_value: row['Cota'], return_daily_value: row['Daily return'], return_weekly_value: row['Weekly return'], return_monthly_value: row['Monthly return'], return_quarterly_value: row['Quarterly return'], return_annual_value: row['Yearly return'], volatility: row['Vol EWMA 97%'])
      end
    end
  end

  def perform
    puts "I'm starting to download funds data"
    write_daily_data_fund
    puts "I'm starting to download benchmark data"
    write_daily_data_bench
  end
end
