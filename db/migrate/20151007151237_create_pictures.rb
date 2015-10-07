class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :uid
      t.binary :data

      t.timestamps null: false
    end
  end
end
