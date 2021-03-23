class CreateHandles < ActiveRecord::Migration[6.1]
  def change
    create_table :handles do |t|
      t.string :prefix
      t.integer :suffix
      t.string :url
      t.string :repo
      t.string :repo_id
      t.string :description
      t.text :notes

      t.timestamps
    end
  end
end
