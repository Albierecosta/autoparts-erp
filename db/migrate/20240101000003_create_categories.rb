class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug
      t.text :description
      t.string :icon
      t.integer :position, default: 0
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :categories, [:company_id, :slug], unique: true
  end
end
