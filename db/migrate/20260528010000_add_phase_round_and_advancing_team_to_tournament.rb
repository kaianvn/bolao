class AddPhaseRoundAndAdvancingTeamToTournament < ActiveRecord::Migration
  def change
    add_column :matches, :phase, :string, default: 'group', null: false
    add_column :matches, :round, :string

    add_column :guesses, :advancing_team_id, :integer
    add_index :guesses, :advancing_team_id
  end
end