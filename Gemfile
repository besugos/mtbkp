source 'https://rubygems.org'
ruby '2.7.0'

gem 'rails', '6.1.5'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'

# gem 'jbuilder', '~> 2.0'

# database
gem 'mysql2', '~> 0.5.2'

# Notification message
gem 'gritter', '~> 1.2'

# Form
gem 'simple_form'

# Datagrid / Pagination
gem 'datagrid'
gem "kaminari"
gem 'iconv'

# Password
gem 'bcrypt', '~> 3.1.12'

# Mail server
# gem 'mailgun_rails'

# Upload file
gem "image_processing"
# gem "paperclip", "~> 6.1.0"

# AWS
gem 'aws-sdk-s3', '~> 1.94', '>= 1.94.1'
# gem 'aws-sdk', '< 2.0'

# CEP Correios
gem 'correios-cep', "~> 0.8.0"

# Find N+1 Queries
gem 'n_1_finder'

# PDF export
# gem 'wicked_pdf'
# gem 'wkhtmltopdf-binary'

# Generate PDF
# gem 'prawn-rails'

# Scheduler
gem 'rufus-scheduler', "~> 3.8.1"

# Audited
gem "audited"

# validar email
gem 'validates_email_format_of'
gem "valid_email2"

# Authentication
gem "pundit"

# Documentos WORD
# gem 'docx'
# gem 'docx_replace'

# Auto-session-timeout
# gem 'auto-session-timeout'

# PDF (Conversor)
# gem 'ilovepdf'

# Mini Magic
gem 'mini_magick'

# Variáveis ENVs
gem "figaro"

# Criptografar dados no banco de dados
gem 'attr_encrypted'

# Validar CPF / CNPJ
gem "cpf_cnpj"

# Google Maps
gem "google_maps_service"

# SQL Server
# necessita instalar no mac > brew install freetds
# gem 'tiny_tds', '~> 1.3.0'
# gem 'activerecord-sqlserver-adapter'

# Postgree
# gem 'pg'

# Envio de SMS
# gem "zenvia-ruby"

# Cálculo de frete
# gem 'correios-frete'

# Validação de cartão de crédito
gem 'credit_card_validations'

# Push notification
gem 'fcm'

gem 'slim-rails', '3.1.1'

# Redis (cable - chat)
gem 'redis', '~> 3.0'
gem 'em-hiredis'

# # Clone (duplicar models/relações)
gem "amoeba"

# # Importação EXCEL
gem 'roo' # xlsx
gem 'spreadsheet' # xls

# AUTH SOCIAL MEDIA

# Use Omniauth Facebook plugin
gem 'omniauth-facebook', '~> 4.0'

# Use Omniauth Google plugin
gem 'omniauth-google-oauth2', '~> 0.8.1'

# Use Google plugin
# gem 'google_sign_in'

# Use ActiveRecord Sessions
gem 'omniauth-rails_csrf_protection', '~> 0.1'

# Auxiliar de lido/não lido
gem 'unread'

# ================= API =================

#Ajax Requests
gem 'rack-cors'

#Prevent butal force attack
gem 'rack-attack'

#API
gem 'grape'

#API documentation
# gem 'grape-swagger'
# gem 'grape-swagger-rails'
# gem 'grape-swagger-entity'
# gem 'grape-swagger-representable'

#serializer
gem 'grape-active_model_serializers'

# Paginação
gem 'api-pagination'
# =============== FIM API ===============

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :development do
  gem 'better_errors'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'hub', :require=>nil
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'spring-commands-rspec'
  gem 'puma'
  # gem 'passenger', '~> 5.0', '>= 5.0.30'
end

gem 'cpf_faker'
gem 'factory_bot_rails'
gem 'faker'

group :development, :test do
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails'
end

group :test do
  gem "chromedriver-helper"
  gem 'email_spec'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem "shoulda-matchers", "< 3.0.0", require: false
end
