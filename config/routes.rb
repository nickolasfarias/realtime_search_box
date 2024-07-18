Rails.application.routes.draw do
  root to: "movie_infos#index", as: :movie_infos

  post "movie_infos_found/suggestions", to: "movie_infos#suggestions", as: :movie_infos_suggestions

  get "search_queries", to: "search_queries#index", as: :search_queries

  post "search_queries", to: "search_queries#create", as: :create_search_query
end
