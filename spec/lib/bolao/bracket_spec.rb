require 'spec_helper'

describe Bolao::Bracket do
  it 'builds a preview from the current users group guesses' do
    user = create(:user)
    group = create(:group, name: 'A')
    team_a = create(:team, name: 'Team A')
    team_b = create(:team, name: 'Team B')
    team_c = create(:team, name: 'Team C')
    team_d = create(:team, name: 'Team D')

    create(:guess, user: user, match: create(:match, group: group, team_a: team_a, team_b: team_b), goals_a: 2, goals_b: 0)
    create(:guess, user: user, match: create(:match, group: group, team_a: team_c, team_b: team_d), goals_a: 1, goals_b: 1)

    preview = described_class.for(user)

    preview[:qualifiers].first[:team].should == team_a
    preview[:pairs].should_not be_empty
  end
end