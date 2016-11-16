require 'rails_helper'

describe PostsData do

  let(:http)      { instance_double('Net::HTTP') }
  let(:http_post) { instance_double('Net::HTTP::Post') }
  let(:response)  { instance_double('Net::HTTPResponse') }
  let(:uri)       { URI.parse(described_class::API_URL) }
  let(:username)  { described_class::API_USERNAME }
  let(:password)  { described_class::API_PASSWORD }
  let(:headers)   { described_class::API_HEADERS }

  it 'expects json data as parameter' do
    expect { described_class.new }.to raise_error(ArgumentError)
    expect { described_class.new('some data') }.to_not raise_error
  end

  context '#post' do

    it 'builds and sends post request' do
      expect(Net::HTTP).to receive(:new).with(uri.host, uri.port) { http }
      expect(Net::HTTP::Post).to receive(:new).with(uri.path, headers) { http_post }
      expect(http_post).to receive(:body=).with('some data')
      expect(http_post).to receive(:basic_auth).with(username, password)
      expect(http).to receive(:request).with(http_post) { response }

      described_class.new('some data').post
    end
  end
end
