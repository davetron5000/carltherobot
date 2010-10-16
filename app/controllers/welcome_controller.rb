class WelcomeController < ApplicationController
  before_filter :authenticate_player!, :except => ['show']
  def show
  end

  def secret
  end

end
