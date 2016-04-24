class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
    	t.string :title
    	t.integer :duration
    	t.string :genre

      t.timestamps null: false
    end
  end
end
