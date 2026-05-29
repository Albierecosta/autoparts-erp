# Em produção usa seed mínimo. Em desenvolvimento usa dados completos de demo.
if Rails.env.production?
  load Rails.root.join("db/seeds/production.rb")
  return
end

puts "🌱 Iniciando seeds..."

# ===========================================================================
# Company
# ===========================================================================
company = Company.find_or_create_by!(name: "AutoPeças Central") do |c|
  c.trade_name = "AutoPeças Central Ltda"
  c.cnpj = "12.345.678/0001-90"
  c.phone = "(11) 3456-7890"
  c.email = "contato@autopecascentral.com.br"
  c.address = "Av. dos Automóveis, 1500"
  c.city = "São Paulo"
  c.state = "SP"
  c.zip_code = "01310-100"
  c.active = true
  c.settings = {
    "low_stock_alert_enabled" => true,
    "default_payment_method" => "cash",
    "receipt_footer" => "Obrigado pela preferência! Volte sempre.",
    "currency_symbol" => "R$"
  }
end
puts "  ✓ Empresa: #{company.name}"

# ===========================================================================
# Users
# ===========================================================================
admin = User.find_or_create_by!(email: "admin@autopecas.com.br") do |u|
  u.company = company
  u.name = "Administrador"
  u.password = "admin123456"
  u.password_confirmation = "admin123456"
  u.role = "admin"
  u.active = true
end

User.find_or_create_by!(email: "gerente@autopecas.com.br") do |u|
  u.company = company
  u.name = "Carlos Gerente"
  u.password = "gerente123456"
  u.password_confirmation = "gerente123456"
  u.role = "manager"
  u.active = true
end

operator = User.find_or_create_by!(email: "vendedor@autopecas.com.br") do |u|
  u.company = company
  u.name = "João Vendedor"
  u.password = "vendedor123456"
  u.password_confirmation = "vendedor123456"
  u.role = "operator"
  u.active = true
end
puts "  ✓ 3 usuários criados"

# ===========================================================================
# Vehicle Makes + Models
# ===========================================================================
makes_data = {
  "Volkswagen" => ["Gol", "Polo", "Voyage", "Saveiro", "Fox", "Golf", "T-Cross", "Virtus"],
  "Fiat" => ["Uno", "Palio", "Siena", "Strada", "Argo", "Cronos", "Mobi", "Toro", "Pulse"],
  "Chevrolet" => ["Onix", "Prisma", "Celta", "Corsa", "Montana", "S10", "Tracker", "Spin"],
  "Ford" => ["Ka", "Fiesta", "Focus", "Ranger", "EcoSport"],
  "Toyota" => ["Corolla", "Etios", "Hilux", "Yaris", "RAV4"],
  "Honda" => ["Civic", "Fit", "City", "HR-V", "CR-V"],
  "Hyundai" => ["HB20", "HB20S", "Creta", "i30", "Tucson"],
  "Renault" => ["Kwid", "Sandero", "Logan", "Duster", "Captur"],
  "Jeep" => ["Renegade", "Compass", "Commander"]
}

makes = {}
vehicle_models = {}

makes_data.each do |make_name, model_names|
  make = VehicleMake.find_or_create_by!(name: make_name)
  makes[make_name] = make
  model_names.each do |model_name|
    model = VehicleModel.find_or_create_by!(name: model_name, vehicle_make: make)
    vehicle_models["#{make_name} #{model_name}"] = model
  end
end
puts "  ✓ #{makes.count} marcas e #{vehicle_models.count} modelos criados"

# ===========================================================================
# Categories
# ===========================================================================
categories_names = ["Freios", "Suspensão", "Motor", "Filtros", "Elétrica",
                    "Transmissão", "Escapamento", "Lataria", "Acessórios", "Óleo e Fluidos"]
categories = {}
categories_names.each_with_index do |name, i|
  cat = Category.find_or_create_by!(name: name, company: company) { |c| c.position = i + 1 }
  categories[name] = cat
end
puts "  ✓ #{categories.count} categorias criadas"

# ===========================================================================
# Suppliers
# ===========================================================================
suppliers_data = [
  { name: "Bosch Autopeças", trade_name: "Bosch", cnpj: "60.736.236/0001-35" },
  { name: "Cofap Distribuidora", trade_name: "Cofap", cnpj: "58.466.541/0001-81" },
  { name: "Monroe Distribuidora", trade_name: "Monroe", cnpj: "61.584.140/0001-49" },
  { name: "Mahle Metal Leve", trade_name: "Mahle", cnpj: "61.065.298/0001-02" },
  { name: "NGK do Brasil", trade_name: "NGK", cnpj: "61.043.871/0001-21" }
]

suppliers = {}
suppliers_data.each do |data|
  sup = Supplier.find_or_create_by!(name: data[:name], company: company) do |s|
    s.trade_name = data[:trade_name]
    s.cnpj = data[:cnpj]
    s.city = "São Paulo"
    s.state = "SP"
  end
  suppliers[data[:trade_name]] = sup
end
puts "  ✓ #{suppliers.count} fornecedores criados"

# ===========================================================================
# Products
# ===========================================================================
products_data = [
  { name: "Pastilha de Freio Dianteira", code: "PFD-001", sku: "0986BB0520", brand: "Bosch", cat: "Freios", cost: 45.0, price: 89.90, stock: 24, min: 5 },
  { name: "Pastilha de Freio Traseira", code: "PFT-001", sku: "0986BB0521", brand: "Bosch", cat: "Freios", cost: 38.0, price: 74.90, stock: 18, min: 5 },
  { name: "Disco de Freio Dianteiro", code: "DFD-001", sku: "0986478822", brand: "Bosch", cat: "Freios", cost: 95.0, price: 185.00, stock: 3, min: 4 },
  { name: "Amortecedor Dianteiro Direito", code: "ADD-001", sku: "ST366R", brand: "Monroe", cat: "Suspensão", cost: 185.0, price: 349.90, stock: 8, min: 2 },
  { name: "Amortecedor Dianteiro Esquerdo", code: "ADE-001", sku: "ST366L", brand: "Monroe", cat: "Suspensão", cost: 185.0, price: 349.90, stock: 8, min: 2 },
  { name: "Mola Suspensão Dianteira", code: "MSD-001", sku: "MS-5642", brand: "Cofap", cat: "Suspensão", cost: 120.0, price: 235.00, stock: 6, min: 2 },
  { name: "Filtro de Óleo", code: "FO-001", sku: "W712/75", brand: "Bosch", cat: "Filtros", cost: 12.0, price: 24.90, stock: 45, min: 10 },
  { name: "Filtro de Ar", code: "FA-001", sku: "S0026", brand: "Bosch", cat: "Filtros", cost: 18.0, price: 35.90, stock: 38, min: 10 },
  { name: "Filtro de Combustível", code: "FC-001", sku: "F0264", brand: "Bosch", cat: "Filtros", cost: 25.0, price: 49.90, stock: 28, min: 8 },
  { name: "Vela de Ignição (jogo 4)", code: "VI-001", sku: "BUJR5A", brand: "NGK", cat: "Elétrica", cost: 45.0, price: 89.90, stock: 22, min: 6 },
  { name: "Cabo de Vela (jogo)", code: "CV-001", sku: "CB-2000", brand: "Bosch", cat: "Elétrica", cost: 55.0, price: 109.90, stock: 15, min: 5 },
  { name: "Correia Dentada", code: "CD-001", sku: "0339X0070", brand: "Bosch", cat: "Motor", cost: 65.0, price: 129.90, stock: 2, min: 3 },
  { name: "Correia Alternador", code: "CA-001", sku: "6K730", brand: "Mahle", cat: "Motor", cost: 35.0, price: 69.90, stock: 20, min: 5 },
  { name: "Junta do Cabeçote", code: "JC-001", sku: "JGJ7010", brand: "Mahle", cat: "Motor", cost: 95.0, price: 189.90, stock: 6, min: 2 },
  { name: "Rolamento de Roda Dianteiro", code: "RRD-001", sku: "RW-4088", brand: "Cofap", cat: "Suspensão", cost: 75.0, price: 145.00, stock: 14, min: 4 },
  { name: "Pivô de Suspensão Dianteiro", code: "PS-001", sku: "PS-1234", brand: "Monroe", cat: "Suspensão", cost: 55.0, price: 109.90, stock: 10, min: 3 },
  { name: "Óleo Motor 5W30 Sintético 1L", code: "OM-001", sku: "OIL5W30", brand: "Bosch", cat: "Óleo e Fluidos", cost: 22.0, price: 44.90, stock: 60, min: 20 },
  { name: "Fluido de Freio DOT4 500ml", code: "FF-001", sku: "DOT4-500", brand: "Bosch", cat: "Óleo e Fluidos", cost: 15.0, price: 29.90, stock: 35, min: 10 },
  { name: "Bucha de Bandeja Dianteira", code: "BBD-001", sku: "BB-2045", brand: "Monroe", cat: "Suspensão", cost: 28.0, price: 54.90, stock: 20, min: 6 },
  { name: "Tensor de Correia", code: "TC-001", sku: "TC-9900", brand: "Mahle", cat: "Motor", cost: 45.0, price: 89.90, stock: 0, min: 3 }
]

products = []
products_data.each do |data|
  product = Product.find_or_create_by!(internal_code: data[:code], company: company) do |p|
    p.name = data[:name]
    p.sku = data[:sku]
    p.brand = data[:brand]
    p.category = categories[data[:cat]]
    p.supplier = suppliers[data[:brand]] || suppliers.values.first
    p.cost_price = data[:cost]
    p.sale_price = data[:price]
    p.stock_quantity = data[:stock]
    p.min_stock = data[:min]
    p.stock_unit = "un"
    p.active = true
    p.published = true
  end
  products << product
end
puts "  ✓ #{products.count} produtos criados"

# ===========================================================================
# Vehicle Applications
# ===========================================================================
brake_pad = products.find { |p| p.internal_code == "PFD-001" }
if brake_pad
  [
    ["Volkswagen", "Gol", "2008", "2014", "1.0"],
    ["Volkswagen", "Polo", "2018", "2024", "1.6"],
    ["Fiat", "Palio", "2012", "2017", "1.4"],
    ["Chevrolet", "Onix", "2019", "2024", "1.0 Turbo"],
    ["Hyundai", "HB20", "2020", "2024", "1.0"]
  ].each do |make_name, model_name, from, to, engine|
    VehicleApplication.find_or_create_by!(
      product: brake_pad,
      vehicle_make: makes[make_name],
      vehicle_model: vehicle_models["#{make_name} #{model_name}"]
    ) do |va|
      va.year_from = from
      va.year_to = to
      va.engine = engine
    end
  end
end
puts "  ✓ Compatibilidades de veículos criadas"

# ===========================================================================
# Customers
# ===========================================================================
customers_data = [
  { name: "João Silva", phone: "(11) 99876-5432", doc: "123.456.789-00" },
  { name: "Maria Oliveira", phone: "(11) 98765-4321", doc: "987.654.321-00" },
  { name: "Carlos Pereira", phone: "(11) 97654-3210", doc: "456.789.123-00" },
  { name: "Ana Santos", phone: "(11) 96543-2109", doc: "789.123.456-00" },
  { name: "Pedro Costa", phone: "(11) 95432-1098", doc: "321.654.987-00" },
  { name: "Mecânica do Zé", phone: "(11) 3234-5678", doc: "12.345.678/0001-90" },
  { name: "Auto Center Silva", phone: "(11) 3876-5432", doc: "98.765.432/0001-09" },
  { name: "Lucas Ferreira", phone: "(11) 94321-0987", doc: "654.987.321-00" }
]

customers = []
customers_data.each do |data|
  c = Customer.find_or_create_by!(name: data[:name], company: company) do |cust|
    cust.phone = data[:phone]
    cust.document = data[:doc]
    cust.document_type = data[:doc].include?("/") ? "cnpj" : "cpf"
    cust.city = "São Paulo"
    cust.state = "SP"
    cust.active = true
  end
  customers << c
end
puts "  ✓ #{customers.count} clientes criados"

CustomerVehicle.find_or_create_by!(customer: customers[0], vehicle_make: makes["Volkswagen"]) do |cv|
  cv.vehicle_model = vehicle_models["Volkswagen Gol"]
  cv.year = "2012"
  cv.plate = "ABC-1234"
  cv.color = "Prata"
end

# ===========================================================================
# Sales
# ===========================================================================
payment_methods = %w[cash pix credit_card debit_card]
sale_count = 0

15.times do |i|
  next_number = company.sales.maximum(:number).to_i + 1
  number = format("%06d", next_number)

  sale = Sale.new(
    company: company,
    customer: i.even? ? customers.sample : nil,
    user: i.even? ? admin : operator,
    sale_type: "sale",
    payment_method: payment_methods.sample,
    number: number
  )

  rand(1..3).times do
    product = products.sample
    qty = rand(1..2)
    sale.sale_items.build(
      product: product,
      quantity: qty,
      unit_price: product.sale_price,
      cost_price: product.cost_price,
      product_name: product.name,
      product_code: product.internal_code
    )
  end

  if sale.save
    subtotal = sale.sale_items.sum { |si| si.quantity * si.unit_price }
    sale.update_columns(
      subtotal: subtotal,
      total: subtotal,
      status: "confirmed",
      confirmed_at: i.days.ago,
      created_at: i.days.ago,
      updated_at: i.days.ago
    )

    FinancialTransaction.create!(
      company: company,
      user: sale.user,
      sale: sale,
      customer: sale.customer,
      transaction_type: "income",
      category: "sale",
      description: "Venda ##{sale.number}",
      amount: subtotal,
      payment_method: sale.payment_method,
      status: "paid",
      paid_at: i.days.ago.to_date,
      due_date: i.days.ago.to_date
    )
    sale_count += 1
  end
end
puts "  ✓ #{sale_count} vendas criadas"

# ===========================================================================
# Financial Transactions
# ===========================================================================
[
  { desc: "Aluguel do galpão", type: "expense", cat: "rent", amount: 3500.00, due: 5.days.from_now },
  { desc: "Conta de energia", type: "expense", cat: "utilities", amount: 850.00, due: 10.days.from_now },
  { desc: "Compra Bosch - Lote 2024", type: "expense", cat: "purchase", amount: 4200.00, due: 3.days.ago, paid: true },
  { desc: "Internet e telefone", type: "expense", cat: "utilities", amount: 299.90, due: 15.days.from_now }
].each do |data|
  FinancialTransaction.find_or_create_by!(description: data[:desc], company: company) do |ft|
    ft.user = admin
    ft.transaction_type = data[:type]
    ft.category = data[:cat]
    ft.amount = data[:amount]
    ft.status = data[:paid] ? "paid" : "pending"
    ft.due_date = data[:due].to_date
    ft.paid_at = data[:paid] ? Date.current : nil
    ft.payment_method = "bank_transfer"
  end
end
puts "  ✓ Lançamentos financeiros criados"

puts "\n✅ Seeds concluídos!"
puts "\n📋 Credenciais:"
puts "   Admin:    admin@autopecas.com.br / admin123456"
puts "   Gerente:  gerente@autopecas.com.br / gerente123456"
puts "   Vendedor: vendedor@autopecas.com.br / vendedor123456"
