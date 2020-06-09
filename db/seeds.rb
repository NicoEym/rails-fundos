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

# client = Algolia::Client.new(application_id: ENV['ALGOLIASEARCH_APPLICATION_ID'], api_key: ENV['ALGOLIASEARCH_ADMIN_API_KEY'])
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

# if Fund.all.empty?

#   Area.create(name: "FOFs", photo_url: "https://images.unsplash.com/photo-1478088702756-f16754aaf0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
#   Area.create(name: "Crédito Privado", photo_url: "https://images.unsplash.com/photo-1512089425728-b012186ab3cc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")


#   anbima_classes = ["Renda Fixa", "Multimercados", "Previdência", "FIP", "Ações"]

#   anbima_classes.each do |anbima_class|
#     AnbimaClass.create(name: anbima_class)
#     puts "Create #{anbima_class}"
#   end

#   ca_gestor = Gestor.create(name: "Ca Indosuez Wealth (Brazil) S.A. Dtvm")
#   fof_area = Area.find_by(name: "FOFs")
#   cp_area = Area.find_by(name: "Crédito Privado")
#   rf_anbima = AnbimaClass.find_by(name: "Renda Fixa")
#   multi_anbima = AnbimaClass.find_by(name: "Multimercados")
#   acao_anbima = AnbimaClass.find_by(name: "Ações")

#   vitesse = Fund.create(name: "Ca Indosuez Vitesse FI RF Cred Priv", short_name: "Vitesse", codigo_economatica: "284211", area_id: cp_area.id, gestor: ca_gestor, anbima_class: rf_anbima, photo_url: "https://images.unsplash.com/photo-1509099652299-30938b0aeb63?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
#   puts "created #{vitesse}"
#   agilite = Fund.create(name: "Ca Indosuez Agilite FI RF Cred Priv", short_name: "Agilite", codigo_economatica: "412171", area_id: cp_area.id, gestor: ca_gestor, anbima_class: rf_anbima, photo_url: "https://images.unsplash.com/photo-1520787054628-794a6d7a822d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
#   puts "created #{agilite}"
#   infrafic = Fund.create(name: "Ca Indosuez Debent Inc Cred Priv Fc Mult", short_name: "Infrafic", codigo_economatica: "405469", area_id: cp_area.id, gestor: ca_gestor, anbima_class: rf_anbima, photo_url: "https://images.unsplash.com/photo-1515674744565-0d7112cd179a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
#   puts "created #{infrafic}"
#   beton = Fund.create(name: "Ca Indosuez Beton FICFI Mult", short_name: "Beton", codigo_economatica: "125970", area_id: fof_area.id, gestor: ca_gestor, anbima_class: multi_anbima, photo_url: "https://images.unsplash.com/photo-1566937169390-7be4c63b8a0e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
#   puts "created #{beton}"
#   allocaction = Fund.create(name: "Ca Indosuez Alloc Action Fc FIA", short_name: "Allocaction", codigo_economatica: "372986", area_id: fof_area.id, gestor: ca_gestor, anbima_class: acao_anbima, photo_url: "https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
#   puts "created #{allocaction}"

#   csv_options = { col_sep:  ";", quote_char: '"', headers: :first_row }
#   path_fundos  = 'db/csv_repos/Indosuez data.csv'

#   CSV.foreach(path_fundos, csv_options) do |row|
#     gestor = Gestor.find_by(name: row['Gestor'])
#     gestor = Gestor.create(name: row['Gestor']) if gestor.nil?
#     puts gestor.name

#     anbima_class = AnbimaClass.find_by(name: row['Classe Anbima'])
#     anbima_class = AnbimaClass.create(name: row['Classe Anbima']) if anbima_class.nil?
#     puts anbima_class.name

#     codigo = row['Ativo'][0,6].to_i
#     fund = Fund.find_by(codigo_economatica: codigo)

#     puts codigo

#     fund = Fund.create(codigo_economatica: codigo, name: row['Nome'], anbima_class: anbima_class, gestor: gestor, competitor_group: row['Competitor group'], photo_url: "https://images.unsplash.com/photo-1532444458054-01a7dd3e9fca?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60") if fund.nil?
#     puts fund.name
#   end


#   path_vitesse  = 'db/csv_repos/data vitesse.csv'
#   path_agilite  = 'db/csv_repos/data agilite.csv'
#   path_beton  = 'db/csv_repos/data beton.csv'
#   path_infrafic  = 'db/csv_repos/data infrafic.csv'
#   path_action  = 'db/csv_repos/data allocaction.csv'

#   paths_array = [path_vitesse, path_agilite, path_beton, path_infrafic, path_action]

#   paths_array.each do |path_array|

#     CSV.foreach(path_array, csv_options) do |row|

#       codigo = row['Ativo'][0,6].to_i
#       puts codigo
#       fund = Fund.find_by(codigo_economatica: codigo)
#       #   Fund.create(codigo_economatica: codigo)

#       year = row["Data"][0,4].to_i
#       puts year
#       month = row["Data"][5,7].to_i
#       puts month
#       day = row["Data"][8,10].to_i
#       puts day
#       date_format_YMD = Date.new(year, month, day)
#       # end

#       date = Calendar.find_by(day: date_format_YMD)
#       date = Calendar.create(day: date_format_YMD) if date.nil?

#       puts date.day

#       data = DailyDatum.create(share_price: row['Cota'], aum: row['PL'], fund: fund, calendar: date)
#       puts data.share_price
#       puts data.aum
#       puts data.calendar.day
#       puts data.fund.name
#     end
#   end

# end


url = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/SSYsXqRVyg4eZ0RTZb4TMAcAy2pTDfCr74SDBWqQYZGtCESTa3bm5QPwlEmFd%2FO81EPj2TYYCFAZ4kSj7RybSv1Ekk85NE4ymAwKSPLUQyNsO81DKGmt9UTauUCWAQkpRsGo%2FthHCMP0gf78bpn41sFHvmaKvspZT2VpfumUf72fGgkwoNya9lkwzSAqMp7EXc4pcpyA5b07z0X0NMb2VmMbdmuauqMmihAAbInkw3NW5ONp9pOVlpjdVj%2F6TSu4BIyUhClY3xeL0qTzAHoETfRYLYgqFf215v%2BV03pJB86KhyKcjjL3pZyN2MObDMRHiOYm5zpKzqrd0gxzdMZQEA%3D%3D'
download = open(url)

puts download
path = 'db/csv_repos/Indosuez data.csv'
#IO.copy_stream(download, path)

#csv_options = { col_sep:  "/\",", quote_char: '"', headers: :first_row }
csv = CSV.parse(download, encoding:'utf-8',:headers=>true)

csv.each do |row|
  # gestor = Gestor.find_by(name: row['Gestor'])
  # gestor = Gestor.create(name: row['Gestor']) if gestor.nil?
  # puts gestor.name

  # anbima_class = AnbimaClass.find_by(name: row['Classe Anbima'])
  # anbima_class = AnbimaClass.create(name: row['Classe Anbima']) if anbima_class.nil?
  # puts anbima_class.name

  codigo = row['Ativo'][0,6].to_i
  fund = Fund.find_by(codigo_economatica: codigo)
  puts fund
  puts codigo

  # fund = Fund.create(codigo_economatica: codigo, name: row['Nome'], anbima_class: anbima_class, gestor: gestor, competitor_group: row['Competitor group']) if fund.nil?

  year = row["Date"][0,4].to_i
  puts year
  month = row["Date"][5,7].to_i
  puts month
  day = row["Date"][8,10].to_i
  puts day
  date_format_YMD = Date.new(year, month, day)

  date = Calendar.find_by(day: date_format_YMD)
  date = Calendar.create(day: date_format_YMD) if date.nil?

  puts date.day

  datas = DailyDatum.find_by(fund: fund, calendar: date)

  if datas.nil?
    puts "nil"
    DailyDatum.create(aum: row['PL'], share_price:row['Cota'], return_daily_value: row['Daily return'], return_weekly_value: row['Weekly return'], return_monthly_value: row['Monthly return'], return_quarterly_value: row['Quarterly return'], return_annual_value: row['Yearly return'], volatility: row['Vol EWMA 97%'], sharpe_ratio: row["Sharpe ratio"], tracking_error: row['Tracking error'], application_weekly_net_value: row['Weekly Net Captation'], application_monthly_net_value: row['Monthly Net Captation'], application_quarterly_net_value: row['Quarterly Net Captation'], application_annual_net_value: row['Yearly Net Captation'],fund: fund, calendar: date)
  else
    puts datas.fund.name
    puts datas.calendar.day
    datas.update(aum: row['PL'], share_price:row['Cota'], return_daily_value: row['Daily return'], return_weekly_value: row['Weekly return'], return_monthly_value: row['Monthly return'], return_quarterly_value: row['Quarterly return'], return_annual_value: row['Yearly return'], volatility: row['Vol EWMA 97%'], sharpe_ratio: row["Sharpe ratio"], tracking_error: row['Tracking error'], application_weekly_net_value: row['Weekly Net Captation'], application_monthly_net_value: row['Monthly Net Captation'], application_quarterly_net_value: row['Quarterly Net Captation'], application_annual_net_value: row['Yearly Net Captation'],fund: fund, calendar: date)
  end


end




# csv.each do |row|
#   puts row["Date"]
# end

# IO.copy_stream(
#   open(
#     url,
#     ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
#   ),
#   path
# )










