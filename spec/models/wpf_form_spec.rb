require 'rails_helper'

describe WpfForm do

  include StubApiRequest

  subject { described_class.new(wpf_params) }

  context 'initialize' do

    it 'assigns only known attributes' do
      wpf = described_class.new(address: 'Sofia', usage: 'New Panda', invalid_attr: 'Invalid')

      expect(wpf.respond_to?(:address)).to be_truthy
      expect(wpf.respond_to?(:usage)).to be_truthy

      expect(wpf.respond_to?(:invalid_attr)).to be_falsy
    end
  end

  context '#process!' do

    let(:post_data) { instance_double('post_data') }
    let(:logger)    { instance_double('logger') }
    let(:response)  { instance_double('response', body: response_params) }

    it 'posts JSON request' do
      expect(PostsData).to receive(:new).with(sale_request_params) { post_data }
      expect(post_data).to receive(:post)

      subject.process!
    end

    it 'returns updated wpf form' do
      expect(PostsData).to receive(:new).with(sale_request_params) { post_data }
      expect(post_data).to receive(:post) { response }

      subject.process!

      expect(subject.status).to eq 'approved'
      expect(subject.reference_id).to eq '123'
    end

    it 'raises error when request timeouts' do
      expect(PostsData).to receive(:new).with(sale_request_params).and_raise(Timeout::Error)

      expect {
        subject.process!
      }.to raise_error 'Request has timeouted, please try again later!'
    end

    it 'raises parsing error when returned response is not JSON' do
      stub_api_with(sale_request_params)

      allow(JSON).to receive(:parse).and_raise(JSON::ParserError)

      expect {
        subject.process!
      }.to raise_error 'Could not parse response!'
    end
  end

  private

  def wpf_params
    {
      transaction_type: 'sale',
      email:            'icotanchev@yahoo.com',
      address:          'Sofia',
      card_number:      '4200000000000000',
      cvv:              '123',
      card_holder:      'POR',
      expiration_date:  '11/2018',
      usage:            'buy new por',
      amount:           '10000'
    }
  end

  def sale_request_params
    { payment_transaction: subject.as_json }.to_json
  end

  def response_params
    {
      reference_id: '123',
      status:    'approved'
    }.to_json
  end
end
