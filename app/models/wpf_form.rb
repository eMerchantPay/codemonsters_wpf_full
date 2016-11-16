class WpfForm

  TIMEOUT_SECONDS = 2

  attr_accessor :transaction_type, :email, :address, :usage, :transaction_time,
                :message, :card_number, :cvv, :card_holder, :expiration_date,
                :amount, :status, :reference_id, :unique_id, :http_code

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end

    remove_whitespace_from_card_number
  end

  def process!
    response = ''

    begin
      Timeout::timeout(TIMEOUT_SECONDS) do
        response = PostsData.new(send("#{self.transaction_type}_request_params")).post
      end
    rescue Timeout::Error => error
      raise 'Request has timeouted, please try again later!'
    end

    update_wpf_from(response) if response.present?
  end

  private

  def update_wpf_from(response)
    begin
      params = JSON.parse(response.body, symbolize_names: true)
    rescue JSON::ParserError
      raise 'Could not parse response!'
    end

    self.http_code = http_status(response)


    params.each do |attr, value|
      self.send("#{attr}=", value) if respond_to?("#{attr}=")
    end
  end

  def remove_whitespace_from_card_number
    self.card_number = card_number.gsub!(' ', '') if card_number
  end

  def http_status(response)
    return '200' if response.is_a?(Net::HTTPSuccess)
    '400'
  end

  def sale_request_params
    { payment_transaction: as_json }.to_json
  end

  def void_request_params
    {
      payment_transaction: {
        transaction_type: self.transaction_type,
        reference_id:     self.unique_id
      }
    }.to_json
  end
end
