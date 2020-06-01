# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require "date"
require "csv"

Gestor.delete_all
Area.delete_all
AnbimaClass.delete_all

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

vitesse = Fund.create(name: "Ca Indosuez Vitesse FI RF Cred Priv", short_name: "Vitesse", codigo_economatica: "284211")

csv_options = { col_sep: ';', quote_char: '"', headers: :first_row }
filedata    = 'db/csv_repos/data_Vitesse.csv'


CSV.foreach(filedata, csv_options) do |row|

  codigo = row['Codigo'].[0,5]
  fund = Fund.find_by(codigo_economatica: codigo)
  #   Fund.create(codigo_economatica: codigo)

  year = row["Date"].[0,3]
  month = row["Date"].[5,6]
  day = row["Date"].[8,9]
  date = Date.new(year, month, day)
  # end
  date = Calendar.create(date: date)

  Share.create(value: row['Cotas'], fund_id: fund.id, date_id: working_day.id)
  Aum.create(value: row['PL'], fund_id: fund.id, date_id: calendar.id)


end



# vitesse = Fund.create(name: "Ca Indosuez Vitesse FI RF Cred Priv", short_name: "Vitesse", codigo_economatica: "284211")
agilite = Fund.create(name: "Ca Indosuez Agilite FI RF Cred Priv", short_name: "Agilite", codigo_economatica: "412171")
infrafic = Fund.create(name: "Ca Indosuez Debent Inc Cred Priv Fc Mult", short_name: "Infrafic", codigo_economatica: "405469")


