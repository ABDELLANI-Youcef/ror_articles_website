class CreateArticleCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :article_categories do |t|
      t.references :article, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.index [:article_id, :category_id], unique: true
      t.timestamps
    end
  end
end
