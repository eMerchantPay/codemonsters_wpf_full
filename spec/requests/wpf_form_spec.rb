require 'rails_helper'

describe 'WPF Form' do

  include StubApiRequest

  before { visit '/' }

  it 'has content on the page' do
    expect(page).to have_content('Payment on Rails')

    ['card_number', 'cvv', 'card_holder', 'expiration_date', 'email', 'address', 'amount', 'usage'].each do |field|
      expect(page).to have_field(field)
    end

    expect(page).to have_button 'Pay'
  end

  context 'create' do

    {
      approved: '4200 0000 0000 0000',
      declined: '4111 1111 1111 1111',
      error:    '4012 0010 3748 4447'
    }.each do |status, card_number|
      it status do
        stub_api_for_requests_with(send("#{status}_response_body"))

        fill_wpf_form(card_number: card_number)

        submit_form

        expect(page).to have_content(status)
      end
    end
  end

  context 'void' do

    it 'success', js: true do
      stub_api_for_requests_with(approved_response_body)
      fill_wpf_form(card_number: '4200 0000 0000 0000')
      submit_form

      sleep(1) # wait for jq slideDown animation

      stub_api_for_requests_with(approved_response_body(message: 'Your transaction has been voided successfully'))
      click_button 'Void'

      sleep(3) # wait for js setTimeout (fake loading time)

      expect(page).to have_content 'Your transaction has been voided successfully'
    end
  end

  private

  def fill_wpf_form(params = {})
    {
      'email':            'panda.hapva@gmail.com',
      'address':          'Sofia',
      'card_number':      '4200 0000 0000 0000',
      'cvv':              '123',
      'card_holder':      'POR',
      'expiration_date':  '11 / 2018',
      'usage':            'buy new por',
      'amount':           '10000'
    }.merge(params).each_pair do |field, value|
      fill_in field, with: value
    end
  end

  def submit_form
    click_button 'Pay'
    sleep(3)
  end

  def approved_response_body(params = {})
    {
      status:  'approved',
      message: 'Your transaction is approved!'
    }.merge(params).to_json
  end

  def declined_response_body
    {
      status:  'declined',
      message: 'Your transaction has been declined'
    }.to_json
  end

  def error_response_body
    {
      status:  'error',
      message: 'Your transaction is error'
    }.to_json
  end
end
