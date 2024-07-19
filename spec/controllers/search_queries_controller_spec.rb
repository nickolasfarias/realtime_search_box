require 'rails_helper'

RSpec.describe SearchQueriesController, type: :controller do
  let(:user_ip) { request.remote_ip }

  describe 'POST #create' do
    context 'when the query is empty' do
      it 'does not create a new query and returns no content' do
        post :create, params: { query: '' }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the query is not empty' do
      it 'creates a new query and removes incomplete queries' do
        post :create, params: { query: 'R' }
        post :create, params: { query: 'RO' }
        post :create, params: { query: 'ROL' }

        expect(SearchQuery.where(user_ip:, is_full_query: false).count).to eq(1)
        expect(response).to have_http_status(:ok)
      end

      it 'returns error when the query cannot be saved' do
        allow_any_instance_of(SearchQuery).to receive(:save).and_return(false)
        post :create, params: { query: 'ROL' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']).to eq('error')
      end
    end
  end

  describe 'GET #index' do
    before do
      allow(request).to receive(:remote_ip).and_return(user_ip)
    end

    context 'when there are queries for the user IP' do
      before do
        create(:search_query, query: 'ROLA', user_ip:, is_full_query: false)
      end

      it 'sets the last incomplete query to full' do
        get :index

        expect(SearchQuery.where(user_ip:, is_full_query: false).count).to eq(0)
        expect(SearchQuery.where(user_ip:, is_full_query: true).count).to eq(1)
      end

      it 'retrieves queries related to the user IP' do
        get :index
        expect(assigns(:my_queries)).to_not be_empty
      end

      it 'orders queries by created_at desc' do
        create(:search_query, query: 'R', user_ip:, created_at: 1.day.ago)
        get :index
        expect(assigns(:my_ordered_queries).first.query).to eq('ROLA')
      end

      it 'retrieves top 10 queries for the user IP' do
        10.times { create(:search_query, query: 'ROL', user_ip:) }
        get :index
        expect(assigns(:my_top_queries).keys).to include('ROL')
      end
    end

    context 'when there are no queries for the user IP' do
      it 'returns an empty list' do
        get :index
        expect(assigns(:my_queries)).to be_empty
      end
    end
  end

  describe 'private methods' do
    describe '#user_deleted_query?' do
      it 'returns true if the query is empty' do
        controller.params = { query: '' }
        expect(controller.send(:user_deleted_query?, controller.params)).to be true
      end

      it 'returns false if the query is not empty' do
        controller.params = { query: 'ROL' }
        expect(controller.send(:user_deleted_query?, controller.params)).to be false
      end
    end

    describe '#remove_incomplete_queries' do
      before do
        allow(request).to receive(:remote_ip).and_return(user_ip)
      end

      it 'removes incomplete queries except the last one' do
        query1 = create(:search_query, query: 'R', user_ip:, is_full_query: false)
        query2 = create(:search_query, query: 'RO', user_ip:, is_full_query: false)
        controller.send(:remove_incomplete_queries, query2)
        expect(SearchQuery.where(user_ip:, is_full_query: false).count).to eq(1)
        expect(SearchQuery.find_by(id: query2.id)).to eq(query2)
      end

      it 'removes all incomplete queries if last_query is not provided' do
        create(:search_query, query: 'R', user_ip:, is_full_query: false)
        create(:search_query, query: 'RO', user_ip:, is_full_query: false)
        controller.send(:remove_incomplete_queries)
        expect(SearchQuery.where(user_ip:, is_full_query: false).count).to eq(0)
      end
    end
  end
end
