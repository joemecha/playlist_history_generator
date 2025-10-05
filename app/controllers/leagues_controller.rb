class LeaguesController < ApplicationController

  def index
    @leagues = League.all.order(id: :desc)
  end
