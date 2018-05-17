class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :text
      t.integer :number_of_comment
      t.references :user
      t.timestamps null: false
    end
  end
end
