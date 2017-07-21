class CreateUrlShortners < ActiveRecord::Migration[5.0]
  def change
    create_table :url_shortners do |t|
      t.string :short_url
      t.string :original_url, null: false
      t.string :sanitized_url, null: false

      t.timestamps
    end
  end
end
