class Book < ApplicationRecord
  include ERP::DataSync::Producer

  contract('V1') do |record|
    record.as_json(only: %i[id title author])
  end
end
