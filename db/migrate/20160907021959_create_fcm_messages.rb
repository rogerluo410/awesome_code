class CreateFcmMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :fcm_messages do |t|
      t.integer    :status, default: 0
      t.belongs_to :receiver
      t.string     :tokens, array: true
      t.json       :notification
      t.json       :data
      t.json       :raw_resp
      t.string     :ex
      t.string     :ex_message
      t.integer    :success_count, default: 0
      t.integer    :failure_count, default: 0
      t.belongs_to :web_notification
    end
  end
end
