require "date"
require "csv"
require "open-uri"
require 'stringio'


DailyDatum.delete_all
Fund.delete_all
DataBenchmark.delete_all
BenchMark.delete_all
Gestor.delete_all
Area.delete_all
AnbimaClass.delete_all
Calendar.delete_all


dates = ["2020-07-31", "2020-06-30", "2020-05-29", "2020-04-30", "2020-03-31", "2020-02-28", "2020-01-31", "2019-12-31", "2019-11-29" , "2019-10-31",
             "2019-09-30" , "2019-07-31", "2019-06-28", "2019-08-30"]
csv_options = { col_sep:  ";", quote_char: '"', headers: :first_row }

def get_date(date)
  year = date[0,4].to_i

   month = date[5,7].to_i

  day = date[8,10].to_i

  date_format_YMD = Date.new(year, month, day)

  date_calendar = Calendar.find_by(day: date_format_YMD)
  date_calendar = Calendar.create(day: date_format_YMD) if date_calendar.nil?

  date_calendar
end

# def write_benchmark_historical_data(files, csv_options)
#   files.each do |file|
#     CSV.foreach(file, csv_options) do |row|

#       code = row['Ativo'][0,3]
#       issuance_date = row["Data de emissão"]
#       puts codigo

#       benchmark = BenchMark.find_by(codigo_economatica: codigo)
#       puts benchmark

#       date = get_date(row['Data'])
#       puts date.day

#       data = DataBenchmark.find_by(bench_mark_id: benchmark.id, calendar_id: date)

#       if data.nil?
#         data = DataBenchmark.create(daily_value: row['Value'], return_daily_value: row['Daily Return'], return_monthly_value: row['Monthly Return'], volatility: row['Vol EWMA 97%'], bench_mark_id: benchmark.id, calendar: date)
#         puts data.daily_value
#       else
#         data.update(daily_value: row['Value'], return_daily_value: row['Daily Return'], return_monthly_value: row['Monthly Return'], volatility: row['Vol EWMA 97%'])
#       end

#     end
#   end
# end


# def write_funds_historical_data(files, csv_options)
#   files.each do |file|
#     CSV.foreach(file, csv_options) do |row|

#       codigo = row['Ativo'][0,6].to_i
#       puts codigo
#       fund = Fund.find_by(codigo_economatica: codigo)

#       date = get_date(row['Data'])

#       puts date.day
#       data = DailyDatum.find_by(fund: fund, calendar_id: date)


#       if data.nil?
#         data = DailyDatum.create(share_price: row['Cota'], aum: row['PL'], application_daily_net_value: row['Capt Liq'],
#                                  return_daily_value: row['Daily Return'],return_monthly_value: row['Monthly Return'],
#                                  volatility: row['Vol EWMA 97%'], fund: fund, calendar: date)
#         puts data.share_price
#       else
#         data.update(share_price: row['Cota'], aum: row['PL'], application_daily_net_value: row['Capt Liq'],
#                                  return_daily_value: row['Daily Return'],return_monthly_value: row['Monthly Return'],
#                                  volatility: row['Vol EWMA 97%'],fund: fund, calendar: date)
#       end

#     end
#   end
# end


def create_competitors (path, csv_options)

  CSV.foreach(path, csv_options) do |row|
    gestor = Gestor.find_by(name: row['Gestor'])
    gestor = Gestor.create(name: row['Gestor']) if gestor.nil?
    puts gestor.name

    comp_area = Area.find_by(name: "Competitors") if gestor.name != "Ca Indosuez Wealth (Brazil) S.A. Dtvm"

    anbima_class = AnbimaClass.find_by(name: row['Classe Anbima'])
    anbima_class = AnbimaClass.create(name: row['Classe Anbima']) if anbima_class.nil?
    puts anbima_class.name

    codigo = row['Ativo'][0,6].to_i
    fund = Fund.find_by(codigo_economatica: codigo)

    puts codigo
    photo_array = [ "https://images.unsplash.com/photo-1435575653489-b0873ec954e2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
                    "https://images.unsplash.com/photo-1509018877337-3af7dd307ea9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
                      "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
                      "https://images.unsplash.com/photo-1485083269755-a7b559a4fe5e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
                      "https://images.unsplash.com/photo-1563257764-ec4bd2983cbe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"]

    benchmark = BenchMark.find_by(name: row['Benchmark'])
    if fund.nil?
      fund = Fund.create(codigo_economatica: codigo, name: row['Nome'],
                        area_name: comp_area.name, anbima_class: anbima_class,
                        bench_mark: benchmark, gestor: gestor, competitor_group: row['Competitor group'],
                        photo_url: photo_array.sample)
      puts fund.name
    end
  end

end



def write_historic_monthly_data(path, options, dates, data_type)

  CSV.foreach(path, options) do |row|
     fund_name = row['Nome']
    puts fund_name
    fund = Fund.find_by(name: fund_name)

    dates.each do |date|
      date_calendar = get_date(date)

      puts date_calendar.day

      datas = DailyDatum.find_by(fund: fund, calendar: date_calendar)

      case data_type
        when "NetApplication"
          datas.nil? ? DailyDatum.create(application_monthly_net_value: row[date].gsub!(/[[:space:]]/, '').to_i, fund: fund, calendar: date_calendar) : datas.update(application_monthly_net_value: row[date].gsub!(/[[:space:]]/, '').to_i)
        when "Returns"
          datas.nil? ? DailyDatum.create(return_monthly_value: row[date].gsub!(',','.').to_f, fund: fund, calendar: date_calendar) : datas.update(return_monthly_value: row[date].gsub!(',','.').to_f)
        when "AUM"
          datas.nil? ? DailyDatum.create(aum: row[date].gsub!(/[[:space:]]/, '').to_i, fund: fund, calendar: date_calendar) : datas.update(aum: row[date].gsub!(/[[:space:]]/, '').to_i)
        when "Vol"
          datas.nil? ? DailyDatum.create(volatility: row[date].gsub!(',','.').to_f, fund: fund, calendar: date_calendar) : datas.update(volatility: row[date].gsub!(',','.').to_f)
        when "SharePrice"
          datas.nil? ? DailyDatum.create(share_price: row[date].gsub!(',','.').to_f, fund: fund, calendar: date_calendar) : datas.update(share_price: row[date].gsub!(',','.').to_f)
      end
    end
  end
end


if BenchMark.all.empty?

  cdi_bench = BenchMark.create(name:"CDI", codigo_economatica: "CDI" )
  ibov_bench = BenchMark.create(name:"Ibovespa", codigo_economatica: "Ibovespa" )
  ima_bench = BenchMark.create(name:"IMA-B5", codigo_economatica: "Ima-B" )

  path_history_Bench  = 'db/csv_repos/Monthly ReturnBench.csv'

  CSV.foreach(path_history_Bench, csv_options) do |row|
    bench_name = row['Nome']
    puts bench_name
    bench_mark = BenchMark.find_by(codigo_economatica: bench_name)

    dates.each do |date|
      date_calendar = get_date(date)

      datas = DataBenchmark.find_by(bench_mark: bench_mark, calendar: date_calendar)

      datas.nil? ? DataBenchmark.create(return_monthly_value: row[date].gsub!(',','.').to_f, bench_mark: bench_mark, calendar: date_calendar) : datas.update(return_monthly_value: row[date].gsub!(',','.').to_f)

    end
  end
end


if Fund.all.empty?

  fof_area = Area.create(name: "FOFs", photo_url: "https://images.unsplash.com/photo-1478088702756-f16754aaf0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  cp_area = Area.create(name: "Crédito Privado", photo_url: "https://images.unsplash.com/photo-1512089425728-b012186ab3cc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  Area.create(name: "Competitors", photo_url: "https://images.unsplash.com/photo-1532444458054-01a7dd3e9fca?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")

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

  private_pi = Fund.create(name: "Ca Indosuez Private Pi Fc de FI Mult", short_name: "Pi", codigo_economatica: "496881", bench_mark: cdi_bench, area_name: fof_area.name, gestor: ca_gestor, anbima_class: multi_anbima, photo_url: "https://images.unsplash.com/photo-1453733190371-0a9bedd82893?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  puts "created #{private_pi}"

  gvitesse = Fund.create(name: "Ca Indosuez Grand Vitesse Firf Cred Priv", short_name: "GVitesse", codigo_economatica: "496881", bench_mark: cdi_bench, area_name: cp_area.name, gestor: ca_gestor, anbima_class: rf_anbima, photo_url: "https://images.unsplash.com/photo-1562548174-587e61fda0b0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  puts "created #{gvitesse}"

  # need to update code economatica
  di60 = Fund.create(name: "Ca Indosuez DI Master FI RF Ref DI LP", short_name: "DI60", codigo_economatica: "496881", bench_mark: cdi_bench, area_name: cp_area.name, gestor: ca_gestor, anbima_class: rf_anbima, photo_url: "https://images.unsplash.com/photo-1533928298208-27ff66555d8d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  puts "created #{di60}"

  # need to update code economatica
  # souverain = Fund.create(name: "Ca Indosuez Souverain", short_name: "Souverain", codigo_economatica: "496881", bench_mark: cdi_bench, area_name: cp_area.name, gestor: ca_gestor, anbima_class: rf_anbima, photo_url: "https://images.unsplash.com/photo-1505461296292-7d67beed10a2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  # puts "created #{souverain}"

  # need to update code economatica
  # souverain_irfm = Fund.create(name: "Ca Indosuez Souverain IRFM", short_name: "Souverain IRFM", codigo_economatica: "496881", bench_mark: cdi_bench, area_name: cp_area.name, gestor: ca_gestor, anbima_class: rf_anbima, photo_url: "https://images.unsplash.com/photo-1578925518470-4def7a0f08bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  # puts "created #{souverain_irfm}"
# need to update code economatica & photo
  # emerging_mast = Fund.create(name: "Ca Indosuez Emerging", short_name: "Emerging Mast", codigo_economatica: "496881", bench_mark: cdi_bench, area_name: cp_area.name, gestor: ca_gestor, anbima_class: rf_anbima, photo_url: "https://images.unsplash.com/photo-1578925518470-4def7a0f08bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  # puts "created #{emerging_mast}"

  avant_garde = Fund.create(name: "Ca In Avant Garde Feed1 Fc Mult Credpriv", short_name: "Avant Garde", codigo_economatica: "496881", bench_mark: cdi_bench, area_name: cp_area.name, gestor: ca_gestor, anbima_class: rf_anbima, photo_url: "https://images.unsplash.com/photo-1546188994-07c34f6e5e1b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
  puts "created #{avant_garde}"

  # path_vitesse  = 'db/csv_repos/data vitesse.csv'
  # path_agilite  = 'db/csv_repos/data agilite.csv'
  # path_beton  = 'db/csv_repos/data beton.csv'
  # path_infrafic  = 'db/csv_repos/data infrafic.csv'
  # path_action  = 'db/csv_repos/data allocaction.csv'
  # path_pi  = 'db/csv_repos/data privatepi.csv'
  # path_gvitesse  = 'db/csv_repos/data gvitesse.csv'

  # paths_array = [path_vitesse, path_agilite, path_beton, path_infrafic, path_action, path_pi]

  # write_funds_historical_data(paths_array, csv_options)

  path_fundos  = 'db/csv_repos/Indosuez data.csv'

  create_competitors(path_fundos, csv_options)
end





def write_monthly_data_fund(path_array, csv_options)
  CSV.foreach(path_array, csv_options) do |row|

    fund_name = row['Nome']
    fund = Fund.find_by(name: fund_name)
    puts fund

    date = get_date(row['Date'])
    puts date.day

    datas = DailyDatum.find_by(fund: fund, calendar: date)

    if datas.nil?
      puts "nil"
      DailyDatum.create(aum: row['PL'].gsub!(/[[:space:]]/, '').to_i, share_price:row['Cota'].gsub!(',','.').to_f, return_monthly_value: row['Monthly return'].gsub!(',','.').to_f,
                        return_quarterly_value: row['Quarterly return'].gsub!(',','.').to_f, return_annual_value: row['Yearly return'].gsub!(',','.').to_f,
                        return_over_benchmark_monthly_value: row['Spread Bench monthly return'].gsub!(',','.').to_f, return_over_benchmark_quarterly_value: row['Spread Bench quarterly return'].gsub!(',','.').to_f,
                        return_over_benchmark_annual_value: row['Spread Bench annual return'].gsub!(',','.').to_f, volatility: row['Vol EWMA 97%'].gsub!(',','.').to_f,
                        sharpe_ratio: row["Sharpe ratio"].gsub!(',','.').to_f, tracking_error: row['Tracking error'].gsub!(',','.').to_f,
                        application_monthly_net_value: row['Monthly Net Captation'].gsub!(/[[:space:]]/, '').to_i,
                        application_quarterly_net_value: row['Quarterly Net Captation'].gsub!(/[[:space:]]/, '').to_i,
                        application_annual_net_value: row['Yearly Net Captation'].gsub!(/[[:space:]]/, '').to_i,fund: fund, calendar: date)
    else
      puts datas.fund.name
      puts datas.calendar.day
      datas.update(aum: row['PL'].gsub!(/[[:space:]]/, '').to_i, share_price:row['Cota'].gsub!(',','.').to_f, return_monthly_value: row['Monthly return'].gsub!(',','.').to_f,
                        return_quarterly_value: row['Quarterly return'].gsub!(',','.').to_f, return_annual_value: row['Yearly return'].gsub!(',','.').to_f,
                        return_over_benchmark_monthly_value: row['Spread Bench monthly return'].gsub!(',','.').to_f, return_over_benchmark_quarterly_value: row['Spread Bench quarterly return'].gsub!(',','.').to_f,
                        return_over_benchmark_annual_value: row['Spread Bench annual return'].gsub!(',','.').to_f, volatility: row['Vol EWMA 97%'].gsub!(',','.').to_f,
                        sharpe_ratio: row["Sharpe ratio"].gsub!(',','.').to_f, tracking_error: row['Tracking error'].gsub!(',','.').to_f,
                        application_monthly_net_value: row['Monthly Net Captation'].gsub!(/[[:space:]]/, '').to_i,
                        application_quarterly_net_value: row['Quarterly Net Captation'].gsub!(/[[:space:]]/, '').to_i,
                        application_annual_net_value: row['Yearly Net Captation'].gsub!(/[[:space:]]/, '').to_i,fund: fund, calendar: date)
    end
  end
end



def write_monthly_data_bench(path_array, csv_options)
  CSV.foreach(path_array, csv_options) do |row|
      codigo = row['Nome']
      puts codigo

      benchmark = BenchMark.find_by(codigo_economatica: codigo)
      puts benchmark

      date = get_date(row['Date'])
      puts date.day

      data = DataBenchmark.find_by(bench_mark_id: benchmark.id, calendar_id: date)

      if data.nil?
        data = DataBenchmark.create(daily_value: row['Cota'].gsub!(',','.').to_f, return_monthly_value: row['Monthly return'].gsub!(',','.').to_f, return_quarterly_value: row['Quarterly return'].gsub!(',','.').to_f, return_annual_value: row['Yearly return'].gsub!(',','.').to_f, volatility: row['Vol EWMA 97%'].gsub!(',','.').to_f, bench_mark_id: benchmark.id, calendar: date)
        puts data.daily_value
      else
        data.update(daily_value: row['Cota'].gsub!(',','.').to_f, return_monthly_value: row['Monthly return'].gsub!(',','.').to_f, return_quarterly_value: row['Quarterly return'].gsub!(',','.').to_f, return_annual_value: row['Yearly return'].gsub!(',','.').to_f, volatility: row['Vol EWMA 97%'].gsub!(',','.').to_f)
      end
  end
end


# write_monthly_data_bench


path_array = 'db/csv_repos/Monthly Net Captation.csv'

write_historic_monthly_data(path_array, csv_options, dates,"NetApplication")

path_array = 'db/csv_repos/Monthly Return.csv'

write_historic_monthly_data(path_array, csv_options, dates,"Returns")

path_array = 'db/csv_repos/Monthly AUM.csv'

write_historic_monthly_data(path_array, csv_options, dates,"AUM")

path_array = 'db/csv_repos/Monthly Vol.csv'

write_historic_monthly_data(path_array, csv_options, dates,"Vol")

path_array = 'db/csv_repos/Monthly Price.csv'

write_historic_monthly_data(path_array, csv_options, dates,"SharePrice")

path_array = 'db/csv_repos/Indosuez data CDI Funds.csv'

write_monthly_data_fund(path_array, csv_options)

path_array = 'db/csv_repos/Indosuez data Ibov Funds.csv'

write_monthly_data_fund(path_array, csv_options)

path_array = 'db/csv_repos/Indosuez data IMAB Funds.csv'

write_monthly_data_fund(path_array, csv_options)

path_array = 'db/csv_repos/Indosuez data Bench.csv'

write_monthly_data_bench(path_array, csv_options)
