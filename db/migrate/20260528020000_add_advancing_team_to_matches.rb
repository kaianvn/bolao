class AddAdvancingTeamToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :advancing_team_id, :integer
    add_index :matches, :advancing_team_id
  end
end