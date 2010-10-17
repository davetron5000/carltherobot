class LevelsController < ApplicationController
  before_filter :authenticate_player!
  def index
    if params[:difficulty].nil?
      head :bad_request
    else
      @levels = Level.by_difficulty[params[:difficulty].to_sym]
    end
  end
end
