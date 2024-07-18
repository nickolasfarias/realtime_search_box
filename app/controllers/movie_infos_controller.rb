class MovieInfosController < ApplicationController
  def index
    sleep(0.3)
    remove_incomplete_queries

    if params[:query].present?
      SearchQuery.create(user_ip: request.remote_ip, query: params[:query], is_full_query: true)

      @movie_infos = MovieInfo.search_by_title(params[:query])
    else
      @movie_infos = MovieInfo.all
    end
  end
end
