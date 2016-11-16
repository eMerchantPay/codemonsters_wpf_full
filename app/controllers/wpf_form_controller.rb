class WpfFormController < ApplicationController

  def new
  end

  %w(sale void).each do |method|
    define_method method do
      wpf_form = WpfForm.new(normalized_params)
      wpf_form.process!

      render json: wpf_form.to_json
    end
  end

  private

  def normalized_params
    params.merge(transaction_type: params[:action])
  end
end
