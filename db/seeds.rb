require "date"
require "csv"
require "open-uri"
require 'stringio'
require 'algoliasearch'

# DailyDatum.delete_all
# Fund.delete_all
# Gestor.delete_all
# Area.delete_all
# AnbimaClass.delete_all
# Calendar.delete_all
# BenchMark.delete_all

csv_options = { col_sep:  ";", quote_char: '"', headers: :first_row }

  def get_date(date)
      year = date[0,4].to_i
      puts year
       month = date[5,7].to_i
      puts month
      day = date[8,10].to_i
      puts day
      Date.new(year, month, day)
  end

def write_benchmark_historical_data(files, csv_options)
  files.each do |file|
    CSV.foreach(file, csv_options) do |row|

      codigo = row['Ativo'][0,3]
      puts codigo
      benchmark = BenchMark.find_by(codigo_economatica: codigo)

      puts benchmark

      date_format_YMD = get_date(date)


      date = Calendar.find_by(day: date_format_YMD)
      date = Calendar.create(day: date_format_YMD) if date.nil?

      puts date.day

      data = DataBenchmark.find_by(bench_mark_id: benchmark.id, calendar_id: date)

      if data.nil?
        data = DataBenchmark.create(daily_value: row['Value'], return_daily_value: row['Daily Return'], return_monthly_value: row['Monthly Return'], volatility: row['Vol EWMA 97%'], bench_mark_id: benchmark.id, calendar: date)
        puts data.daily_value
      else
        data.update(daily_value: row['Value'], return_daily_value: row['Daily Return'], return_monthly_value: row['Monthly Return'], volatility: row['Vol EWMA 97%'])
      end

    end
  end
end


def write_funds_historical_data(files, csv_options)
  files.each do |file|
    CSV.foreach(file, csv_options) do |row|

      codigo = row['Ativo'][0,6].to_i
      puts codigo
      fund = Fund.find_by(codigo_economatica: codigo)

      date_format_YMD = get_date(date)

      date = Calendar.find_by(day: date_format_YMD)
      date = Calendar.create(day: date_format_YMD) if date.nil?

      puts date.day
      data = DailyDatum.find_by(fund: fund, calendar_id: date)


      if data.nil?
        data = DailyDatum.create(share_price: row['Cota'], aum: row['PL'], application_daily_net_value: row['Capt Liq'],
                                 return_daily_value: row['Daily Return'],return_monthly_value: row['Monthly Return'],
                                 volatility: row['Vol EWMA 97%'], fund: fund, calendar: date)
        puts data.share_price
      else
        data.update(share_price: row['Cota'], aum: row['PL'], application_daily_net_value: row['Capt Liq'],
                                 return_daily_value: row['Daily Return'],return_monthly_value: row['Monthly Return'],
                                 volatility: row['Vol EWMA 97%'],fund: fund, calendar: date)
      end

    end
  end
end


def create_competitors (path, csv_options)

  CSV.foreach(path, csv_options) do |row|
    gestor = Gestor.find_by(name: row['Gestor'])
    gestor = Gestor.create(name: row['Gestor']) if gestor.nil?
    puts gestor.name

    comp_area = Area.find_by(name: "Competitors") if gestor.name != ca_gestor.name

    anbima_class = AnbimaClass.find_by(name: row['Classe Anbima'])
    anbima_class = AnbimaClass.create(name: row['Classe Anbima']) if anbima_class.nil?
    puts anbima_class.name

    codigo = row['Ativo'][0,6].to_i
    fund = Fund.find_by(codigo_economatica: codigo)

    puts codigo

    benchmark = BenchMark.find_by(name: row['Benchmark'])
    if fund.nil?
      fund = Fund.create(codigo_economatica: codigo, name: row['Nome'],
                        area_name: comp_area.name, anbima_class: anbima_class,
                        bench_mark: benchmark, gestor: gestor, competitor_group: row['Competitor group'],
                        photo_url: "https://images.unsplash.com/photo-1532444458054-01a7dd3e9fca?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
      puts fund.name
    end
  end

end



def write_monthly_application(path, options, dates)

  CSV.foreach(path, options) do |row|
    codigo = row['Ativo'][0,6].to_i
    puts codigo
    fund = Fund.find_by(codigo_economatica: codigo)

    dates.each do |date|

      date_format_YMD = get_date(date)

      date_calendar = Calendar.find_by(day: date_format_YMD)
      date_calendar = Calendar.create(day: date_format_YMD) if date_calendar.nil?

      puts date_calendar.day

      datas = DailyDatum.find_by(fund: fund, calendar: date_calendar)

      if datas.nil?
        DailyDatum.create(application_monthly_net_value: row[date], fund: fund, calendar: date_calendar)
      else
        datas.update(application_monthly_net_value: row[date])
      end
    end
  end
end



def write_monthly_return(path, options, dates)

  CSV.foreach(path, options) do |row|
    codigo = row['Ativo'][0,6].to_i
    puts codigo
    fund = Fund.find_by(codigo_economatica: codigo)

    dates.each do |date|

      date_format_YMD = get_date(date)

      date_calendar = Calendar.find_by(day: date_format_YMD)
      date_calendar = Calendar.create(day: date_format_YMD) if date_calendar.nil?

      puts date_calendar.day

      datas = DailyDatum.find_by(fund: fund, calendar: date_calendar)

      if datas.nil?
        DailyDatum.create(return_monthly_value: row[date], fund: fund, calendar: date_calendar)
      else
        datas.update(return_monthly_value: row[date])
      end
    end
  end
end



 if BenchMark.all.empty?


  cdi_bench = BenchMark.find_by(name:"CDI")
  ibov_bench= BenchMark.find_by(name:"Ibovespa")
  ima_bench = BenchMark.find_by(name:"IMA B5")


  cdi_bench.update(name:"CDI", codigo_economatica: "CDI" )
  ibov_bench.update(name:"Ibovespa", codigo_economatica: "IBO" )
  ima_bench.update(name:"IMA B5", codigo_economatica: "IMA" )

  path_ibovespa  = 'db/csv_repos/data ibovespa.csv'
  path_CDI  = 'db/csv_repos/data CDI.csv'
  path_IMAB5  = 'db/csv_repos/data IMA B5.csv'

  paths_bench_array = [path_ibovespa, path_CDI, path_IMAB5]

  write_benchmark_historical_data(paths_bench_array, csv_options)
end


if Fund.all.empty?

  fof_area = Area.create(name: "FOFs", photo_url: "https://images.unsplash.com/photo-1478088702756-f16754aaf0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  cp_area = Area.create(name: "Crédito Privado", photo_url: "https://images.unsplash.com/photo-1512089425728-b012186ab3cc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  Area.create(name: "Competitors", photo_url: "https://images.unsplash.com/photo-1512089425728-b012186ab3cc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")

  anbima_classes = ["Renda Fixa", "Multimercados", "Previdência", "FIP", "Ações"]
  anbima_classes.each do |anbima_class|
    AnbimaClass.create(name: anbima_class)
    puts "Create #{anbima_class}"
  end

  ca_gestor = Gestor.create(name: "Ca Indosuez Wealth (Brazil) S.A. Dtvm")

  rf_anbima = AnbimaClass.find_by(name: "Renda Fixa")
  multi_anbima = AnbimaClass.find_by(name: "Multimercados")
  acao_anbima = AnbimaClass.find_by(name: "Ações")


  vitesse = Fund.create(name: "Ca Indosuez Vitesse FI RF Cred Priv", short_name: "Vitesse", codigo_economatica: "284211", area_name: cp_area.name, gestor: ca_gestor, anbima_class: rf_anbima, bench_mark: cdi_bench, photo_url: "https://images.unsplash.com/photo-1509099652299-30938b0aeb63?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  puts "created #{vitesse}"
  agilite = Fund.create(name: "Ca Indosuez Agilite FI RF Cred Priv", short_name: "Agilite", codigo_economatica: "412171", bench_mark: cdi_bench, area_name: cp_area.name, gestor: ca_gestor, anbima_class: rf_anbima, photo_url: "https://images.unsplash.com/photo-1520787054628-794a6d7a822d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  puts "created #{agilite}"
  infrafic = Fund.create(name: "Ca Indosuez Debent Inc Cred Priv Fc Mult", short_name: "Infrafic", codigo_economatica: "405469", bench_mark: ima_bench,area_name: cp_area.name, gestor: ca_gestor, anbima_class: rf_anbima, photo_url: "https://images.unsplash.com/photo-1515674744565-0d7112cd179a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  puts "created #{infrafic}"
  beton = Fund.create(name: "Ca Indosuez Beton FICFI Mult", short_name: "Beton", codigo_economatica: "125970", area_name: fof_area.name, bench_mark: cdi_bench, gestor: ca_gestor, anbima_class: multi_anbima, photo_url: "https://images.unsplash.com/photo-1566937169390-7be4c63b8a0e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  puts "created #{beton}"
  allocaction = Fund.create(name: "Ca Indosuez Alloc Action Fc FIA", short_name: "Allocaction", codigo_economatica: "372986", bench_mark: ibov_bench, area_name: fof_area.name, gestor: ca_gestor, anbima_class: acao_anbima, photo_url: "https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  puts "created #{allocaction}"

  path_vitesse  = 'db/csv_repos/data vitesse.csv'
  path_agilite  = 'db/csv_repos/data agilite.csv'
  path_beton  = 'db/csv_repos/data beton.csv'
  path_infrafic  = 'db/csv_repos/data infrafic.csv'
  path_action  = 'db/csv_repos/data allocaction.csv'

  paths_array = [path_vitesse, path_agilite, path_beton, path_infrafic, path_action]

  write_funds_historical_data(paths_array, csv_options)

  path_fundos  = 'db/csv_repos/Indosuez data.csv'

  create_competitors(path_fundos, csv_options)
end


#client = Algolia::Client.new(application_id: ENV['ALGOLIASEARCH_APPLICATION_ID'], api_key: ENV['ALGOLIASEARCH_ADMIN_API_KEY'])
# index = client.init_index('dev_Fund')


# funds =Fund.all
# funds_array = []
# funds.each do |fund|
#   image = fund.photo_url
#   image = "https://images.unsplash.com/photo-1532444458054-01a7dd3e9fca?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60" if image.nil?
#   funds_hash = {name: fund.best_name, id: fund.id, photo_url: image, gestor: fund.gestor }
#   funds_array << funds_hash
# end
# index.add_objects(funds_array)







# url = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/SSYsXqRVyg4eZ0RTZb4TMAcAy2pTDfCr74SDBWqQYZGtCESTa3bm5QPwlEmFd%2FO81EPj2TYYCFAZ4kSj7RybSv1Ekk85NE4ymAwKSPLUQyNsO81DKGmt9UTauUCWAQkpRsGo%2FthHCMP0gf78bpn41sFHvmaKvspZT2VpfumUf72fGgkwoNya9lkwzSAqMp7EXc4pcpyA5b07z0X0NMb2VmMbdmuauqMmihAAbInkw3NW5ONp9pOVlpjdVj%2F6TSu4BIyUhClY3xeL0qTzAHoETfRYLYgqFf215v%2BV03pJB86KhyKcjjL3pZyN2MObDMRHiOYm5zpKzqrd0gxzdMZQEA%3D%3D'
# download = open(url)


# csv = CSV.parse(download, encoding:'utf-8',:headers=>true)

# csv.each do |row|
#   # gestor = Gestor.find_by(name: row['Gestor'])
#   # gestor = Gestor.create(name: row['Gestor']) if gestor.nil?
#   # puts gestor.name

#   # anbima_class = AnbimaClass.find_by(name: row['Classe Anbima'])
#   # anbima_class = AnbimaClass.create(name: row['Classe Anbima']) if anbima_class.nil?
#   # puts anbima_class.name

#   codigo = row['Ativo'][0,6].to_i
#   fund = Fund.find_by(codigo_economatica: codigo)
#   puts fund
#   puts codigo

#   # fund = Fund.create(codigo_economatica: codigo, name: row['Nome'], anbima_class: anbima_class, gestor: gestor, competitor_group: row['Competitor group']) if fund.nil?

#   year = row["Date"][0,4].to_i
#   puts year
#   month = row["Date"][5,7].to_i
#   puts month
#   day = row["Date"][8,10].to_i
#   puts day
#   date_format_YMD = Date.new(year, month, day)

#   date = Calendar.find_by(day: date_format_YMD)
#   date = Calendar.create(day: date_format_YMD) if date.nil?

#   puts date.day

#   datas = DailyDatum.find_by(fund: fund, calendar: date)

#   if datas.nil?
#     puts "nil"
#     DailyDatum.create(aum: row['PL'], share_price:row['Cota'], return_daily_value: row['Daily return'], return_weekly_value: row['Weekly return'], return_monthly_value: row['Monthly return'], return_quarterly_value: row['Quarterly return'], return_annual_value: row['Yearly return'], volatility: row['Vol EWMA 97%'], sharpe_ratio: row["Sharpe ratio"], tracking_error: row['Tracking error'], application_weekly_net_value: row['Weekly Net Captation'], application_monthly_net_value: row['Monthly Net Captation'], application_quarterly_net_value: row['Quarterly Net Captation'], application_annual_net_value: row['Yearly Net Captation'],fund: fund, calendar: date)
#   else
#     puts datas.fund.name
#     puts datas.calendar.day
#     datas.update(aum: row['PL'], share_price:row['Cota'], return_daily_value: row['Daily return'], return_weekly_value: row['Weekly return'], return_monthly_value: row['Monthly return'], return_quarterly_value: row['Quarterly return'], return_annual_value: row['Yearly return'], volatility: row['Vol EWMA 97%'], sharpe_ratio: row["Sharpe ratio"], tracking_error: row['Tracking error'], application_weekly_net_value: row['Weekly Net Captation'], application_monthly_net_value: row['Monthly Net Captation'], application_quarterly_net_value: row['Quarterly Net Captation'], application_annual_net_value: row['Yearly Net Captation'],fund: fund, calendar: date)
#   end


# end




def write_daily_data_fund

  urlCDI = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/j9ScUlOFDYYsEOihvscfgPe8qHolC%2FqwVKR5cDK3HBkiPMrVtIT7uj3uP7JKxcZ0Xc5BU%2FJ7gwMns0rbucgaWGYy2RMtS9xEQtSqvF5wM4C8mGbog2dZW4bydAuisQo%2BKTS0TJ%2Fyfg7C6JScf7qZK2SbS0IBJsB1hcbYce%2BHBtTsNag9Wy%2F3FBUUXPUqWIDTPq1bDk6g2qDsDXnAPiqdmtGan6qGke3pNcJ0jaHR%2BSObNqcfoMtcD3%2FFEBSaopLLc87nCZGTeBVT1ifg5MPO1Dsa4yXNJSL%2BIEsgWsS69ywtXf7P34A5hm1VmzQRzb3N2XXbIXwQgYujka7NS%2BWUHg%3D%3D'
  urlIbov = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/rGm9Zy17%2BNapl9t81EXK6TrtRuA0IkEAvcW7YVoajp7%2BjYODvTiszYO54mdy9mllCKf2IY%2Fje1vu7oQokV5%2F5Yc1U3%2FrYTfBZrSfzP2%2FRPp7%2BC5yVsFCidYaNp5n3BXM8aBX%2FCaMJ%2BaPg9LVDgndX0zxGgnuSHShapZAb4PTpLzYnte7cVru61DehhBpG2qEh%2F9moARwWa%2FjeiPSjBqbbZVzIo4CbS2uG7s5YEUeCq%2F9i4cCry0TaE3uTZKacX2ULRF5nyy11jWLSe28mZ58g%2BzXnrZ9dKWLcO2RWgQMHuDSas1aJYul8hQXaxA%2FYGaZk5SI15szsLj6s2gvARp5wA%3D%3D'
  urlIMAB = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/dX3h0i5dYjVRhjpXiuGcU3zRacYT1fTzLoEJCm241swQhX3GustOxINqs5%2B4i5Yhw3A1LvRQZEYP%2B5pAYRC0IjHmAz%2BDWnI60N6LLuxg6EysNz5hFXxg2OZoN5dYNyXYGucCWWCodzL6ihrMvkKDR%2F7xYBtw0jZoYHlgo5w6EWx6%2B97theuoAt0wnxjSAuquM7dbpseGgQhNUcPA43F%2BXaMCsLN16TLgky%2FN8DrU%2BOhX4pTzmCjH0NrkCSXXmBh4ayDgFcTmn0yuxSRJ26QmB1X7NpVMy7RiNd%2BbU0xUSrL4fWXJMlKDIKF7DlyXVC0qQBNHRQG0R5B%2BdkIsZXIA5g%3D%3D'
  urls = [urlCDI, urlIbov, urlIMAB]

  urls.each do |url|

    download = open(url)

    csv = CSV.parse(download, encoding:'utf-8',:headers=>true)

    csv.each do |row|

      codigo = row['Ativo'][0,6].to_i
      fund = Fund.find_by(codigo_economatica: codigo)
      puts fund
      puts codigo

       date_format_YMD = get_date(date)

      date = Calendar.find_by(day: date_format_YMD)
      date = Calendar.create(day: date_format_YMD) if date.nil?

      puts date.day

      datas = DailyDatum.find_by(fund: fund, calendar: date)

      puts row['Spread Bench daily return']
      puts row['Spread Bench weekly return']
      puts row['Spread Bench monthly return']
      puts row['Spread Bench quarterly return']
      puts row['Spread Bench annual return']

      if datas.nil?
        puts "nil"
        DailyDatum.create(aum: row['PL'], share_price:row['Cota'], return_daily_value: row['Daily return'],
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
        datas.update(aum: row['PL'], share_price:row['Cota'], return_daily_value: row['Daily return'],
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

# write_daily_data_fund


def write_daily_data_bench

  url = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/HUVTbYqYz0Ncb18HDZP4lsWchqywXj3Rq5qGUc%2F6i2GGO16xePr9ZrHNc3PosAHGLFoIhPAzJL%2BIcC7RptMTd1BZAef%2B2OLzJqZ9%2FOtENuGB1LZS19z1fJ%2BI8gw8kgDqszyBBM%2FwlxCvVKh2WjhpNyB2Lwiyd%2BgG72EGhKZsLIY8xFOP5KvrmYfsdU0Ee3mGlRr9KnFSkaWzG%2BzYEs6tQwijifx6mUFDpQelTC%2F6mzxG3bq1QazG7CHDMe%2FTOc6xHuaP8Nhbu2vy59xRlH%2Fi%2FC5eLtRsKP%2Fsnlm2a%2BkuMhAmvi2LbtCjX5HQYrhe70agGxq1xHSxIVVzQqyERX4T%2BQ%3D%3D'
  download = open(url)

    csv = CSV.parse(download, encoding:'utf-8',:headers=>true)

    csv.each do |row|

      codigo = row['Ativo'][0,3]
      puts codigo
      benchmark = BenchMark.find_by(codigo_economatica: codigo)

      puts benchmark

      date_format_YMD = get_date(date)

      date = Calendar.find_by(day: date_format_YMD)
      date = Calendar.create(day: date_format_YMD) if date.nil?

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


# write_daily_data_bench

dates = ["2020-05-29", "2020-04-30", "2020-03-31", "2020-02-28", "2020-01-31", "2019-12-31", "2019-11-29" , "2019-10-31",
              "2019-09-30" , "2019-07-31", "2019-06-28", "2019-08-30"]

# path_array = 'db/csv_repos/Monthly Net Captation.csv'

# write_monthly_application(path_array, csv_options, dates)

path_array = 'db/csv_repos/Monthly Return.csv'

write_monthly_return(path_array, csv_options, dates)



