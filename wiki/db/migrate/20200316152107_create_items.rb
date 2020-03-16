class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :user
      t.string :title, null: false
      t.text :content
      t.timestamps
    end
  end
end
