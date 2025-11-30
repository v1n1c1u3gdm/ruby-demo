class RemoveUrlFromArticles < ActiveRecord::Migration[7.2]
  def change
    if index_exists?(:articles, :url)
      remove_index :articles, :url
    end

    remove_column :articles, :url, :string
  end
end

