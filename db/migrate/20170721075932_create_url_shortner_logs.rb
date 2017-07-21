class CreateUrlShortnerLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :url_shortner_logs do |t|
      t.integer :url_shortner_id
      t.integer :user_id
      t.string :browser
      t.string :version
      t.string :platform
      t.timestamps
    end
  end
end
