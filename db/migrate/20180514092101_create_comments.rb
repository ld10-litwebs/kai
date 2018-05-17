class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :text
      t.integer :like
      t.boolean :encouraged
      t.references :user
      t.references :post
      t.timestamps null: false
    end
  end
end
