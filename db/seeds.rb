# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require "date"
require "csv"

Share.delete_all
Aum.delete_all
Fund.delete_all
Gestor.delete_all
Area.delete_all
AnbimaClass.delete_all
Calendar.delete_all

areas = ["FOFs", "Crédito Privado"]

gestors =["Ca Indosuez Wealth (Brazil) S.A. Dtvm", "Af Invest Administracao de Recursos", "ARX Investimentos Ltda", "Az Quest Investimentos", "Sparta", "Iridium Gestao de Recursos Ltda", "Quasar Asset Management"]

anbima_classes = ["Renda Fixa", "Multimercados", "Previdência", "FIP"]


gestors.each do |gestor|
  Gestor.create(name: gestor)
  puts "Create #{gestor}"
end

areas.each do |area|
  Area.create(name: area)
  puts "Create #{area}"
end


anbima_classes.each do |anbima_class|
  AnbimaClass.create(name: anbima_class)
  puts "Create #{anbima_class}"
end

vitesse_gestor = Gestor.find_by(name: "Ca Indosuez Wealth (Brazil) S.A. Dtvm")
vitesse_area = Area.find_by(name: "Crédito Privado")
vitesse_anbima = AnbimaClass.find_by(name: "Renda Fixa")


vitesse = Fund.create(name: "Ca Indosuez Vitesse FI RF Cred Priv", short_name: "Vitesse", codigo_economatica: "284211", area_id: vitesse_area.id, gestor_id: vitesse_gestor.id, anbima_class_id: vitesse_anbima.id)
puts vitesse

csv_options = { col_sep: ';', quote_char: '"', headers: :first_row }
filedata    = 'db/csv_repos/data_Vitesse.csv'


CSV.foreach(filedata, csv_options) do |row|

  codigo = row['Codigo'][0,6].to_i
  puts codigo
  fund = Fund.find_by(codigo_economatica: codigo)
  puts fund
  #   Fund.create(codigo_economatica: codigo)

  year = row["Date"][0,4].to_i
  puts year
  month = row["Date"][5,7].to_i
  puts month
  day = row["Date"][8,10].to_i
  puts day
  date = Date.new(year, month, day)
  # end
  date = Calendar.create(day: date)
  puts date.day

  Share.create(value: row['Cota'], fund_id: fund.id, calendar_id: date.id)
  Aum.create(value: row['PL'], fund_id: fund.id, calendar_id: date.id)


end



# vitesse = Fund.create(name: "Ca Indosuez Vitesse FI RF Cred Priv", short_name: "Vitesse", codigo_economatica: "284211")
agilite = Fund.create(name: "Ca Indosuez Agilite FI RF Cred Priv", short_name: "Agilite", codigo_economatica: "412171")
infrafic = Fund.create(name: "Ca Indosuez Debent Inc Cred Priv Fc Mult", short_name: "Infrafic", codigo_economatica: "405469")


