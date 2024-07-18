class ApplicationController < ActionController::Base
  def remove_incomplete_queries(last_query = nil)
    incomplete_queries = SearchQuery.where(user_ip: request.remote_ip, is_full_query: false)

    return unless incomplete_queries.present?

    incomplete_queries = incomplete_queries.reject { |query| query.id == last_query.id } if last_query.present?

    incomplete_queries.each(&:destroy) if incomplete_queries.present?
  end
end
