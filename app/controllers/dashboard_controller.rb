class DashboardController < ApplicationController

  def index
    @grouped_matches = Match.
                          active.
                          includes(:guesses, :team_a, :team_b).
                          group_ordered.
                          order("datetime ASC").                          
                          decorate(context: {user: current_user}).
                          group_by(&:group)

    @knockout_matches = Match.
                          knockout.
                          includes({:guesses => :user}, :team_a, :team_b, :group).
                          order("round ASC, datetime ASC").
                          decorate(context: {user: current_user})
  end

end