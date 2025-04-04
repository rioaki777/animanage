class CreateAnimes < ActiveRecord::Migration[7.2]
  def change
    create_table :animes do |t|
      t.string :title
      t.string :comment
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
