class SearchQueriesController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    return if user_deleted_query?(params)

    user_ip = request.remote_ip
    search_query = SearchQuery.new(query: params[:query])
    search_query.user_ip = user_ip

    if search_query.save
      remove_incomplete_queries(search_query)

      render json: { status: 'success' }, status: :ok
    else
      render json: { status: 'error', errors: search_query.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @user_ip = params[:user_ip] || request.remote_ip
    @is_my_ip = @user_ip == request.remote_ip
    @all_ips = SearchQuery.pluck(:user_ip).uniq

    if SearchQuery.where(user_ip: request.remote_ip, is_full_query: false).present?
      SearchQuery.where(user_ip: request.remote_ip, is_full_query: false).last.update(is_full_query: true)
    end

    @my_queries = SearchQuery.where(user_ip: @user_ip)
    @my_ordered_queries = @my_queries.order(created_at: :desc)
    @my_top_queries = @my_queries.group(:query).order('COUNT(query) DESC').limit(10).count
  end

  def user_deleted_query?(params)
    return true if params[:query] == ''

    remove_incomplete_queries

    false
  end
end
