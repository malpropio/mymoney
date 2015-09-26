class StaticPagesController < ApplicationController
  include ApplicationHelper

  skip_before_action :require_login, only: [:home]

  def home
    if params[:code]
      store_token(params[:code])
    end
  end
end
