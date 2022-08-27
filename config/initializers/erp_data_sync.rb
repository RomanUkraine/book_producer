# frozen_string_literal: true

ERP::DataSync.configure do |config|
  config.transport_adapter(:redis, { redis_bus_db: 15, app_name: 'book_producer', app_prefix: "15" })
end
