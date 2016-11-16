require 'rails_helper'

describe WpfFormController do

  include StubApiRequest

  context 'GET #new' do

    it 'returns http success' do
      get :new

      expect(response).to have_http_status :success
    end

    it 'renders new template' do
      get :new

      expect(response).to render_template :new
    end
  end

  context 'POST #sale' do

    it 'returns http success and assigns returned status from API' do
      stub_api_with(sale_request_params, { status: 'approved' }.to_json)

      post :sale, sale_post_params

      expect(response).to have_http_status :success
      expect(JSON.parse(response.body)['status']).to eq 'approved'
    end

    it 'returns errors from API' do
      stub_api_with({ payment_transaction: { amount: '', transaction_type: 'sale' } }.to_json,
                    { amount: "can't be blank" }.to_json)

      post :sale, { amount: nil }

      expect(JSON.parse(response.body)['amount']).to eq "can't be blank"
    end
  end

  context 'POST #void' do

    it 'returns http success and assigns returned status from API' do
      stub_api_for_requests_with({ status: 'approved' }.to_json)

      post :void, void_post_params

      expect(response).to have_http_status :success
      expect(JSON.parse(response.body)['status']).to eq 'approved'
    end

    it 'returns errors from API' do
      stub_api_for_requests_with({ reference_id: "can't be blank" }.to_json)

      post :void, { reference_id: nil }

      expect(JSON.parse(response.body)['reference_id']).to eq "can't be blank"
    end
  end

  private

  def sale_post_params
    {
      address:         'Sofia',
      amount:          '10000',
      card_holder:     'POR',
      card_number:     '4200 0000 0000 0000',
      cvv:             '123',
      email:           'test@test.com',
      expiration_date: '11/2018',
      usage:           'buy new por'
    }
  end

  def void_post_params
    { reference_id: '1234' }
  end

  def sale_request_params
    {
      payment_transaction: sale_post_params.merge(transaction_type: 'sale',
                                                  card_number:      '4200000000000000')
    }.to_json
  end

  def void_request_params
    {
      payment_transaction: { transaction_type: 'void', reference_id: '1234' }
    }.to_json
  end
end
