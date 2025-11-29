class CreateAuthors < ActiveRecord::Migration[7.2]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.date :birthdate, null: false
      t.string :photo_url, null: false
      t.text :public_key, null: false

      t.timestamps
    end
    add_index :authors, :name, unique: true
  end
end
