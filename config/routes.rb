Rails.application.routes.draw do
  root to: 'wpf_form#new'

  post 'wpf_form/sale'

  post 'wpf_form/void'
end
