class StaticPagesController < ApplicationController
  include ApplicationHelper

  skip_before_action :require_login, only: [:home]

  def home
    store_token(params[:code]) if params[:code]
  end
end
