module StubApiRequest

  USERNAME = 'pandahapva'
  PASSWORD = 'kachamak'
  POST_URL = "http://#{USERNAME}:#{PASSWORD}@127.0.0.1:3001/payment_transactions"

  def stub_api_with(body = '', response_body = '', status = 200)
    stub_request(:post, POST_URL).
      with(body: body, headers: PostsData::API_HEADERS).
      to_return(status: status, body: response_body, headers: {})
  end

  def stub_api_for_requests_with(response_body = '', success = true)
    request  = double(:request)
    response = double(:response, body: response_body)

    allow(PostsData).to receive(:new)   { request }
    allow(request).to   receive(:post)  { response }
    allow(response).to  receive(:is_a?) { success }
  end
end
