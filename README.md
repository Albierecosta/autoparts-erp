# AutoPeças ERP

Sistema ERP moderno para autopeças construído com Ruby on Rails 8, TailwindCSS e Hotwire.

## Stack Tecnológica

| Tecnologia | Uso |
|---|---|
| Ruby on Rails 8.1 | Framework principal |
| PostgreSQL 16+ | Banco de dados relacional |
| Redis 7+ | Cache e filas |
| Sidekiq 8+ | Jobs assíncronos |
| Hotwire (Turbo + Stimulus) | Frontend reativo sem SPA |
| TailwindCSS 4+ | Estilização |
| Devise | Autenticação |
| Pundit | Autorização baseada em políticas |
| Pagy | Paginação performática |
| PgSearch | Busca full-text via PostgreSQL |

---

## Funcionalidades Implementadas (V1)

- **Dashboard** — KPIs em tempo real, vendas do dia, estoque baixo, fluxo de caixa
- **Produtos** — Cadastro completo com fotos (ActiveStorage), SKU, marca, categorias, cálculo de margem
- **Compatibilidade de Veículos** — Cadastro por marca/modelo/ano/motor com busca integrada
- **Controle de Estoque** — Entrada, saída, ajuste manual, histórico completo com rastreio
- **Clientes** — Cadastro, veículos vinculados, histórico de compras
- **PDV (Ponto de Venda)** — Venda rápida com busca de produtos via Stimulus
- **Orçamentos** — Fluxo separado com possibilidade de converter em venda
- **Financeiro** — Contas a receber/pagar, baixa de títulos, fluxo de caixa
- **Fornecedores** — Cadastro completo
- **Usuários** — Multi-perfil (Admin, Gerente, Operador) com Pundit
- **Busca Inteligente** — Full-text por nome, código, marca, veículo
- **Impressão** — Cupom de pedido com layout para impressora térmica
- **Dark Mode** — Toggle com persistência no localStorage
- **Multi-empresa** — `company_id` em todas as entidades (base para SaaS)
- **E-commerce preparado** — Flag + produtos publicados prontos para loja online

---

## Estrutura do Projeto

```
app/
├── controllers/
│   ├── application_controller.rb         # Base: Pundit + Pagy + company scope
│   ├── dashboard_controller.rb
│   ├── products_controller.rb
│   ├── sales_controller.rb
│   ├── customers_controller.rb
│   ├── stock_movements_controller.rb
│   ├── financial_transactions_controller.rb
│   ├── searches_controller.rb            # API JSON para Stimulus (busca)
│   └── settings/companies_controller.rb
├── models/
│   ├── company.rb
│   ├── user.rb                           # Devise + roles
│   ├── product.rb                        # PgSearch + ActiveStorage photos
│   ├── vehicle_make.rb / vehicle_model.rb
│   ├── vehicle_application.rb            # Compatibilidade peça ↔ veículo
│   ├── customer.rb / customer_vehicle.rb
│   ├── sale.rb / sale_item.rb
│   ├── stock_movement.rb
│   └── financial_transaction.rb
├── services/
│   ├── sale_service.rb                   # confirm!: deduz estoque + cria lançamento
│   ├── stock_service.rb                  # Processa movimentações
│   └── product_search_service.rb
├── policies/                             # Pundit
├── javascript/controllers/              # Stimulus
│   ├── app_controller.js                # Dark mode, sidebar toggle
│   ├── flash_controller.js              # Auto-dismiss de alertas
│   ├── dropdown_controller.js
│   ├── product_search_controller.js     # Busca global no topbar
│   ├── product_search_sale_controller.js # Busca no PDV
│   ├── sale_form_controller.js          # Carrinho reativo (sem page reload)
│   └── product_form_controller.js       # Cálculo de margem em tempo real
└── views/
    ├── layouts/application.html.erb     # Sidebar + topbar
    ├── layouts/print.html.erb           # Layout para impressão
    ├── shared/                          # _sidebar, _topbar, _flash, _nav_item
    ├── dashboard/ products/ sales/
    ├── customers/ stock_movements/
    └── financial_transactions/
```

---

## Banco de Dados

### Entidades e Relacionamentos

```
Company
  └── has_many → Users, Products, Categories, Suppliers,
                 Customers, Sales, StockMovements, FinancialTransactions

Product
  ├── belongs_to → Company, Category (opt), Supplier (opt)
  ├── has_many → VehicleApplications (make + model + year + engine)
  ├── has_many → SaleItems
  └── has_many → StockMovements

Sale
  ├── belongs_to → Company, User, Customer (opt)
  ├── has_many → SaleItems → Product
  └── has_many → FinancialTransactions

Customer
  ├── belongs_to → Company
  ├── has_many → CustomerVehicles (make + model + plate + year)
  └── has_many → Sales

StockMovement
  ├── belongs_to → Company, Product, User
  └── belongs_to → Sale (opt), Supplier (opt)
  # Tipos: entry, exit, adjustment, sale_out, purchase, return
```

---

## Instalação Local

### Pré-requisitos

- Ruby 4.0+
- PostgreSQL 16+
- Redis 7+

### Passo a passo

```bash
# 1. Clone
git clone <repo-url> && cd autoparts-erp

# 2. Instale dependências
bundle install

# 3. Configure o ambiente
cp .env.development .env.local
# Ajuste DB_USERNAME, DB_PASSWORD conforme necessário

# 4. Banco de dados
rails db:create db:migrate db:seed

# 5. Inicie
bin/dev
# Acesse: http://localhost:3000
```

### Com Docker Compose

```bash
docker compose up -d
docker compose exec app rails db:create db:migrate db:seed
# Acesse: http://localhost:3000
```

---

## Credenciais de Acesso (Seeds)

| Perfil | E-mail | Senha |
|---|---|---|
| **Administrador** | admin@autopecas.com.br | admin123456 |
| **Gerente** | gerente@autopecas.com.br | gerente123456 |
| **Vendedor** | vendedor@autopecas.com.br | vendedor123456 |

---

## Perfis e Permissões (Pundit)

| Ação | Admin | Gerente | Operador |
|---|:---:|:---:|:---:|
| Dashboard | ✅ | ✅ | ✅ |
| Ver/Criar Produtos | ✅ | ✅ | ✅ |
| Editar Produtos | ✅ | ✅ | ❌ |
| Excluir Produtos | ✅ | ❌ | ❌ |
| Criar Vendas | ✅ | ✅ | ✅ |
| Cancelar Vendas | ✅ | ✅ | ❌ |
| Baixa Financeira | ✅ | ✅ | ❌ |
| Gerenciar Usuários | ✅ | ❌ | ❌ |
| Configurações da Empresa | ✅ | ❌ | ❌ |
| Painel Sidekiq (/sidekiq) | ✅ | ❌ | ❌ |

---

## Busca Inteligente de Produtos

Utiliza **PgSearch** com PostgreSQL full-text search + trigram similarity.

**Campos pesquisados:** nome, código interno, SKU, marca, descrição, + marca/modelo do veículo via JOIN.

**Exemplos:**
```
"pastilha civic 2018"  → Pastilhas compatíveis com Honda Civic 2018
"bosch gol 1.0"        → Peças Bosch para Volkswagen Gol 1.0
"filtro oleo"          → Filtros de óleo (tolera erro de acento)
"FO-001"               → Busca por código exato
```

---

## Fluxo de Venda (PDV)

```
1. Abrir "Nova Venda"
2. Digitar produto no campo de busca (Stimulus + fetch /search/products)
3. Selecionar produto → item adicionado ao carrinho (reativo, sem reload)
4. Ajustar quantidade com +/- ou digitando
5. Selecionar cliente (opcional)
6. Selecionar forma de pagamento
7. Aplicar desconto (% ou R$)
8. Confirmar Venda:
   └── SaleService.confirm!
       ├── sale.confirm! (status = confirmed)
       ├── Desconta stock_quantity de cada produto
       ├── Cria StockMovement (sale_out) por produto
       └── Cria FinancialTransaction (income)
9. Imprimir cupom → receipt.html.erb (window.print())
```

---

## Ativação do E-commerce

O sistema está preparado para loja online futura:

1. **Painel de Configurações** → Ativar "Loja Online"
2. **Produto** → Marcar `published = true`
3. **Estoque compartilhado** — mesmo `stock_quantity`
4. **Pedidos online** → `sale_type = "online_order"` (a implementar)

---

## Variáveis de Ambiente

```env
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=password
DB_NAME=autoparts_development

REDIS_URL=redis://localhost:6379/0
SIDEKIQ_CONCURRENCY=5

APP_HOST=localhost:3000
DEFAULT_FROM_EMAIL=noreply@autoparts.com.br
```

---

## Roadmap

### V1 — MVP (Atual)
- [x] PDV com busca inteligente
- [x] Controle de estoque completo
- [x] Compatibilidade de veículos
- [x] Financeiro básico
- [x] Dashboard com KPIs
- [x] Multi-empresa
- [x] Dark mode
- [x] Impressão de pedido

### V2 — Produção
- [ ] Relatórios PDF/Excel (Prawn + caxlsx)
- [ ] Gráficos no dashboard (Chart.js)
- [ ] Busca por veículo no PDV
- [ ] Notificações por email (Sidekiq + Action Mailer)
- [ ] Importação de produtos via CSV
- [ ] Leitura de código de barras (câmera/scanner)
- [ ] Múltiplas filiais
- [ ] Parcelamento de vendas

### V3 — SaaS + E-commerce
- [ ] Tenant isolation completo (multi-schema)
- [ ] Planos e cobrança (Stripe)
- [ ] Storefront público (loja online)
- [ ] PWA para uso mobile no balcão
- [ ] API REST pública
- [ ] Orçamento por WhatsApp/Email

---

## Sugestões UX para Balcão

- **Busca global**: sempre acessível no topbar, foco automático com `/`
- **Teclado primeiro**: Tab entre campos do carrinho sem usar mouse
- **Botões grandes**: mínimo 44px para uso com toque ou luva
- **Fonte mínima 14px**: para leitura em ambiente com luz solar
- **Auto-print**: configurável para imprimir automaticamente ao confirmar
- **Alerta visual de estoque baixo**: badge vermelho no sino do topbar

---

## Contribuição

```bash
git checkout -b feature/minha-feature
git commit -m 'feat: descrição da funcionalidade'
git push origin feature/minha-feature
# Abra um Pull Request
```

---

## Licença

MIT License
