puts "🌱 Setup inicial de produção..."

# ===========================================================================
# Empresa
# ===========================================================================
company = Company.find_or_create_by!(name: ENV.fetch("COMPANY_NAME", "Minha AutoPeças")) do |c|
  c.active = true
  c.settings = {
    "receipt_footer" => "Obrigado pela preferência!",
    "currency_symbol" => "R$"
  }
end
puts "  ✓ Empresa: #{company.name}"

# ===========================================================================
# Usuário Admin
# ===========================================================================
admin_email = ENV.fetch("ADMIN_EMAIL", "admin@autopecas.com.br")
admin_pass  = ENV.fetch("ADMIN_PASSWORD", SecureRandom.hex(8))

admin = User.find_or_create_by!(email: admin_email) do |u|
  u.company  = company
  u.name     = "Administrador"
  u.password = admin_pass
  u.password_confirmation = admin_pass
  u.role     = "admin"
  u.active   = true
end

if admin.previously_new_record?
  puts "  ✓ Admin criado:"
  puts "    E-mail: #{admin_email}"
  puts "    Senha:  #{admin_pass}  ← SALVE ESTA SENHA AGORA"
else
  puts "  ✓ Admin já existe: #{admin_email}"
end

# ===========================================================================
# Marcas e modelos de veículos (dados de referência)
# ===========================================================================
makes_data = {
  "Volkswagen" => ["Gol", "Polo", "Voyage", "Saveiro", "Fox", "Golf", "T-Cross", "Virtus", "Nivus"],
  "Fiat"       => ["Uno", "Palio", "Siena", "Strada", "Argo", "Cronos", "Mobi", "Toro", "Pulse", "Fastback"],
  "Chevrolet"  => ["Onix", "Prisma", "Celta", "Corsa", "Montana", "S10", "Tracker", "Spin", "Equinox"],
  "Ford"       => ["Ka", "Fiesta", "Focus", "Ranger", "EcoSport", "Territory", "Bronco Sport"],
  "Toyota"     => ["Corolla", "Etios", "Hilux", "Yaris", "RAV4", "Camry", "SW4"],
  "Honda"      => ["Civic", "Fit", "City", "HR-V", "CR-V", "WR-V"],
  "Hyundai"    => ["HB20", "HB20S", "Creta", "i30", "Tucson", "Santa Fe"],
  "Renault"    => ["Kwid", "Sandero", "Logan", "Duster", "Captur", "Stepway"],
  "Peugeot"    => ["208", "2008", "308", "3008", "Partner"],
  "Jeep"       => ["Renegade", "Compass", "Commander", "Gladiator"],
  "Nissan"     => ["Kicks", "Versa", "Frontier", "Sentra"],
  "Mitsubishi" => ["L200", "Outlander", "Eclipse Cross", "ASX"],
  "Citroën"    => ["C3", "C4", "Aircross", "Berlingo"],
  "Kia"        => ["Sportage", "Stonic", "Carnival"],
  "BMW"        => ["320i", "X1", "X3", "X5"],
  "Mercedes"   => ["Classe A", "Classe C", "GLA", "GLC"]
}

makes_data.each do |make_name, model_names|
  make = VehicleMake.find_or_create_by!(name: make_name)
  model_names.each { |m| VehicleModel.find_or_create_by!(name: m, vehicle_make: make) }
end

total_makes  = VehicleMake.count
total_models = VehicleModel.count
puts "  ✓ #{total_makes} marcas e #{total_models} modelos de veículos"

# ===========================================================================
# Categorias padrão
# ===========================================================================
categories = [
  "Freios", "Suspensão", "Motor", "Filtros", "Elétrica",
  "Transmissão", "Escapamento", "Lataria", "Acessórios", "Óleo e Fluidos"
]
categories.each_with_index do |name, i|
  Category.find_or_create_by!(name: name, company: company) { |c| c.position = i + 1 }
end
puts "  ✓ #{categories.count} categorias padrão"

puts "\n✅ Setup concluído! Acesse o sistema e faça login com:"
puts "   #{admin_email}"
