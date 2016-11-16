class PostsData

  attr_reader :request_body

  # change the url to fit your needs
  API_URL      = 'http://127.0.0.1:3001/payment_transactions'.freeze
  API_USERNAME = 'pandahapva'.freeze
  API_PASSWORD = 'kachamak'.freeze
  API_HEADERS  = { 'Content-Type' => 'application/json' }.freeze

  def initialize(request_body)
    @request_body = request_body
  end

  def post
    uri = URI.parse(API_URL)

    http = Net::HTTP.new(uri.host, uri.port)

    # request
    post_request      = Net::HTTP::Post.new(uri.path, API_HEADERS)
    post_request.body = request_body

    # basic auth
    post_request.basic_auth API_USERNAME, API_PASSWORD

    http.request(post_request)
  end
end
