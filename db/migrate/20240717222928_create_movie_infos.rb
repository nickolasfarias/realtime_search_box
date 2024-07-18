class CreateMovieInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :movie_infos do |t|
      t.string :title
      t.string :quote

      t.timestamps
    end
  end
end
