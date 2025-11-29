class CreateSocials < ActiveRecord::Migration[7.2]
  def change
    create_table :socials do |t|
      t.string :profile_link, null: false
      t.string :slug, null: false
      t.text :description, null: false
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
    add_index :socials, :slug, unique: true
  end
end
