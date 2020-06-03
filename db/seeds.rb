# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require "date"
require "csv"

Application.delete_all
Return.delete_all
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

# vitesse = Fund.create(name: "Ca Indosuez Vitesse FI RF Cred Priv", short_name: "Vitesse", codigo_economatica: "284211", area_id: cp_area.id, gestor_id: ca_gestor.id, anbima_class_id: rf_anbima.id)
# puts "created #{vitesse}"

# agilite = Fund.create(name: "Ca Indosuez Agilite FI RF Cred Priv", short_name: "Agilite", codigo_economatica: "412171", area_id: cp_area.id, gestor_id: ca_gestor.id, anbima_class_id: rf_anbima.id)
# puts "created #{agilite}"
# infrafic = Fund.create(name: "Ca Indosuez Debent Inc Cred Priv Fc Mult", short_name: "Infrafic", codigo_economatica: "405469", area_id: cp_area.id, gestor_id: ca_gestor.id, anbima_class_id: rf_anbima.id)
# puts "created #{infrafic}"
# beton = Fund.create(name: "Ca Indosuez Beton FICFI Mult", short_name: "Beton", codigo_economatica: "125970", area_id: fof_area.id, gestor_id: ca_gestor.id, anbima_class_id: multi_anbima.id)
# puts "created #{beton}"
# allocaction = Fund.create(name: "Ca Indosuez Alloc Action Fc FIA", short_name: "Allocaction", codigo_economatica: "372986", area_id: fof_area.id, gestor_id: ca_gestor.id, anbima_class_id: acao_anbima.id)
# puts "created #{allocaction}"


csv_options = { col_sep: ';', quote_char: '"', headers: :first_row }

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
#     date = Date.new(year, month, day)
#     # end

#       if Calendar.find_by(day: date).nil?
#         date = Calendar.create(day: date)
#       else
#         date = Calendar.find_by(day: date)
#       end

#     puts date.day

#     Share.create(value: row['Cota'], fund_id: fund.id, calendar_id: date.id)
#     Aum.create(value: row['PL'], fund_id: fund.id, calendar_id: date.id)

#   end

# end

path_daily_data  = 'db/csv_repos/Indosuez data.csv'


CSV.foreach(path_daily_data, csv_options) do |row|

    codigo = row['Codigo'][0,6].to_i
    puts codigo
    fund = Fund.find_by(codigo_economatica: codigo)
    puts fund.short_name
    #   Fund.create(codigo_economatica: codigo)

    year = row["Date"][0,4].to_i
    puts year
    month = row["Date"][5,7].to_i
    puts month
    day = row["Date"][8,10].to_i
    puts day
    date = Date.new(year, month, day)
    # end


    if Calendar.find_by(day: date).nil?
      date = Calendar.create(day: date)
    else
      date = Calendar.find_by(day: date)
    end

    puts date.day

    Application.create(weekly_net_value: row['Weekly Net Captation'], monthly_net_value: row['Monthly Net Captation'], quarterly_net_value: row['Quarterly Net Captation'], yearly_net_value: row['Yearly Net Captation'], fund_id: fund.id, calendar_id: date.id)
    Return.create(daily_value: row['Daily return'],weekly_value: row['Weekly return'], monthly_value: row['Monthly return'], quarterly_value: row['Quarterly return'], yearly_value: row['Yearly return'], fund_id: fund.id, calendar_id: date.id)
    # Share.create(value: row['Cota'], fund_id: fund.id, calendar_id: date.id) if Share.find_by(fund_id: fund.id, calendar_id: date.id).nil?
    # Aum.create(value: row['PL'], fund_id: fund.id, calendar_id: date.id) if Aum.find_by(fund_id: fund.id, calendar_id: date.id).nil?

  end
