class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :author
      t.string :cook_time
      t.string :description
      t.string :ingredients
      t.string :instructions
      t.string :name
      t.string :prep_time
      t.date :published_date
      t.string :total_time
      t.string :yield

      t.timestamps
    end
  end
end
