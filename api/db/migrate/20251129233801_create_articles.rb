class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.string :slug, null: false
      t.string :published_label, null: false
      t.text :post_entry, null: false
      t.json :tags, null: false
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
    add_index :articles, :slug, unique: true
    add_index :articles, :url, unique: true
  end
end
