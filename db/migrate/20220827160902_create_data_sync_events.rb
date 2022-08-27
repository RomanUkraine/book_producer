# frozen_string_literal: true

class CreateDataSyncEvents < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'
    create_table :erp_data_sync_events, id: :uuid do |t|
      t.string :type
      t.string :application_name
      t.jsonb :payload
      t.bigint :original_entity_id, null: true, index: true
      t.uuid :original_event_id

      t.timestamps
    end
  end
end
