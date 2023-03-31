require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "cpf_cnpj"
require 'fcm'
require 'correios-cep'
require 'uri'
require 'json'
require 'open-uri'

# require 'zenvia'
# require 'correios-frete'
# require "grape-swagger"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SistemaMercadoTopografico
  class Application < Rails::Application

    config.active_storage.track_variants = true

    config.middleware.use Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, 
        methods: [:get, :post, :put, :delete, :options]
      end
    end

    # n+1 queries
    config.middleware.use(N1Finder::Middleware)

    config.generators do |g|
      g.test_framework :rspec,
      fixtures: true,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      controller_specs: false,
      request_specs: false

      g.javascript_engine = :js
      g.template_engine :erb
      g.scaffold_stylesheet false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    Time.zone = 'Brasilia'
    config.time_zone = ActiveSupport::TimeZone.new('Brasilia')
    config.active_record.default_timezone = :local

    config.i18n.default_locale = :'pt-BR'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/reports)

    # Rails.logger (Exemplo: Rails.logger.error e.message)
    config.logger = Logger.new(STDOUT)

  end
end
