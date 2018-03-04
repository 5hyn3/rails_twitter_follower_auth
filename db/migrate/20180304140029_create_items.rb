class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.text :text
      t.boolean :only_followers
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
