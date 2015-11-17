class CreateDummylibraries < ActiveRecord::Migration
  def change
    create_table :dummylibraries do |t|
      t.string :title
      t.string :duration 

      t.timestamps null: false
    end
  end
end
