require "date"
require "csv"
require "open-uri"
require 'stringio'


url = 'https://api.data.economatica.com/1/oficial/datafeed/download/1/SSYsXqRVyg4eZ0RTZb4TMAcAy2pTDfCr74SDBWqQYZGtCESTa3bm5QPwlEmFd%2FO81EPj2TYYCFAZ4kSj7RybSv1Ekk85NE4ymAwKSPLUQyNsO81DKGmt9UTauUCWAQkpRsGo%2FthHCMP0gf78bpn41sFHvmaKvspZT2VpfumUf72fGgkwoNya9lkwzSAqMp7EXc4pcpyA5b07z0X0NMb2VmMbdmuauqMmihAAbInkw3NW5ONp9pOVlpjdVj%2F6TSu4BIyUhClY3xeL0qTzAHoETfRYLYgqFf215v%2BV03pJB86KhyKcjjL3pZyN2MObDMRHiOYm5zpKzqrd0gxzdMZQEA%3D%3D'
download = open(url)

puts download
path = 'db/csv_repos/Indosuez data.csv'
#IO.copy_stream(download, path)

#csv_options = { col_sep:  "/\",", quote_char: '"', headers: :first_row }
csv = CSV.parse(download, encoding:'utf-8',:headers=>true)



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

# Application.delete_all
# Return.delete_all
# Share.delete_all
# Aum.delete_all
# Fund.delete_all
# Gestor.delete_all
# Area.delete_all
# AnbimaClass.delete_all
# Calendar.delete_all

# areas = ["FOFs", "Crédito Privado"]

# gestors =["Ca Indosuez Wealth (Brazil) S.A. Dtvm", "Af Invest Administracao de Recursos", "ARX Investimentos Ltda", "Az Quest Investimentos", "Sparta", "Iridium Gestao de Recursos Ltda", "Quasar Asset Management"]

# anbima_classes = ["Renda Fixa", "Multimercados", "Previdência", "FIP", "Ações"]


# gestors.each do |gestor|
#   Gestor.create(name: gestor)
#   puts "Create #{gestor}"
# end

# areas.each do |area|
#   Area.create(name: area)
#   puts "Create #{area}"
# end


# anbima_classes.each do |anbima_class|
#   AnbimaClass.create(name: anbima_class)
#   puts "Create #{anbima_class}"
# end

# ca_gestor = Gestor.find_by(name: "Ca Indosuez Wealth (Brazil) S.A. Dtvm")

# fof_area = Area.find_by(name: "FOFs")
# cp_area = Area.find_by(name: "Crédito Privado")

# rf_anbima = AnbimaClass.find_by(name: "Renda Fixa")
# multi_anbima = AnbimaClass.find_by(name: "Multimercados")
# acao_anbima = AnbimaClass.find_by(name: "Ações")

# vitesse = Fund.create(name: "Ca Indosuez Vitesse FI RF Cred Priv", short_name: "Vitesse", codigo_economatica: "284211", area_id: cp_area.id, gestor: ca_gestor, anbima_class: rf_anbima)
# puts "created #{vitesse}"

# agilite = Fund.create(name: "Ca Indosuez Agilite FI RF Cred Priv", short_name: "Agilite", codigo_economatica: "412171", area_id: cp_area.id, gestor: ca_gestor, anbima_class: rf_anbima)
# puts "created #{agilite}"
# infrafic = Fund.create(name: "Ca Indosuez Debent Inc Cred Priv Fc Mult", short_name: "Infrafic", codigo_economatica: "405469", area_id: cp_area.id, gestor: ca_gestor, anbima_class: rf_anbima)
# puts "created #{infrafic}"
# beton = Fund.create(name: "Ca Indosuez Beton FICFI Mult", short_name: "Beton", codigo_economatica: "125970", area_id: fof_area.id, gestor: ca_gestor, anbima_class: multi_anbima)
# puts "created #{beton}"
# allocaction = Fund.create(name: "Ca Indosuez Alloc Action Fc FIA", short_name: "Allocaction", codigo_economatica: "372986", area_id: fof_area.id, gestor: ca_gestor, anbima_class: acao_anbima)
# puts "created #{allocaction}"


csv_options = { col_sep:  ";", quote_char: '"', headers: :first_row }

# path_vitesse  = 'db/csv_repos/data_Vitesse.csv'
# path_agilite  = 'db/csv_repos/data agilite.csv'
# path_beton  = 'db/csv_repos/data beton.csv'
# path_infrafic  = 'db/csv_repos/data infrafic.csv'
# path_action  = 'db/csv_repos/data allocaction.csv'

# paths_array = [path_vitesse, path_agilite, path_beton, path_infrafic, path_action]

# paths_array.each do |path_array|

#   CSV.foreach(path_array, csv_options) do |row|

#     codigo = row['Codigo'][0,6].to_i
#     puts codigo
#     fund = Fund.find_by(codigo_economatica: codigo)
#     puts fund.short_name
#     #   Fund.create(codigo_economatica: codigo)

#     year = row["Date"][0,4].to_i
#     puts year
#     month = row["Date"][5,7].to_i
#     puts month
#     day = row["Date"][8,10].to_i
#     puts day
#     date_format_YMD = Date.new(year, month, day)
#     # end

#        date = Calendar.find_by(day: date_format_YMD)
#    date = Calendar.create(day: date_format_YMD) if date.nil?

#     puts date.day

#     Share.create(value: row['Cota'], fund: fund, calendar: date)
#     Aum.create(value: row['PL'], fund: fund, calendar: date)

#   end

# end

# path_daily_data  = 'db/csv_repos/Indosuez data.csv'


# CSV.foreach(path_daily_data, csv_options) do |row|
csv.each do |row|
#     gestor = Gestor.find_by(name: row['Gestor'])
#     gestor = Gestor.create(name: row['Gestor']) if gestor.nil?
#     puts gestor.name

#     # anbima_class = AnbimaClass.find_by(name: row['Classe Anbima'])
#     # anbima_class = AnbimaClass.create(name: row['Classe Anbima']) if anbima_class.nil?
#     # puts anbima_class.name

    codigo = row['Ativo'][0,6].to_i
    fund = Fund.find_by(codigo_economatica: codigo)
    puts fund
    puts codigo

    fund = Fund.create(codigo_economatica: codigo, name: row['Nome'], anbima_class: anbima_class, gestor: gestor, competitor_group: row['Competitor group']) if fund.nil?


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

    Application.create(weekly_net_value: row['Weekly Net Captation'], monthly_net_value: row['Monthly Net Captation'], quarterly_net_value: row['Quarterly Net Captation'], yearly_net_value: row['Yearly Net Captation'], fund: fund, calendar: date) if Application.find_by(fund: fund, calendar: date).nil?
    Return.create(daily_value: row['Daily return'],weekly_value: row['Weekly return'], monthly_value: row['Monthly return'], quarterly_value: row['Quarterly return'], yearly_value: row['Yearly return'], fund: fund, calendar: date) if Return.find_by(fund: fund, calendar: date).nil?
    Share.create(value: row['Cota'], fund: fund, calendar: date) if Share.find_by(fund: fund, calendar: date).nil?
    Aum.create(value: row['PL'], fund: fund, calendar: date) if Aum.find_by(fund: fund, calendar: date).nil?
end
#   end
