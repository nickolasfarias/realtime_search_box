class AddIsFullQueryToSearchQueries < ActiveRecord::Migration[7.0]
  def change
    add_column :search_queries, :is_full_query, :boolean, default: false
  end
end
