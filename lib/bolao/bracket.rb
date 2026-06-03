module Bolao
  class Bracket
    KNOCKOUT_ROUNDS = %w[round_of_32 round_of_16 quarter_final semi_final third_place final].freeze
    Qualifier = Struct.new(:team, :group_name, :points, :goal_difference, :goals_for)

    def self.for(user)
      new(user).preview
    end

    def initialize(user)
      @user = user
    end

    def preview
      standings = group_standings
      qualifiers = standings.flat_map { |group_name, teams| teams.take(2).map { |team| team.merge(group_name: group_name) } }
      third_places = standings.flat_map do |group_name, teams|
        third = teams[2]
        third ? third.merge(group_name: group_name) : nil
      end.compact

      best_thirds = third_places.sort_by { |team| sort_key(team) }.first(8)
      round_of_32 = (qualifiers + best_thirds).sort_by { |team| sort_key(team) }

      {
        standings: standings,
        qualifiers: round_of_32,
        pairs: round_of_32.each_slice(2).map { |pair| pair if pair.size == 2 }.compact
      }
    end

    def knockout_rounds(knockout_matches)
      KNOCKOUT_ROUNDS.select { |round_name| knockout_matches.any? { |match| match.round == round_name } }
    end

    def knockout_preview(round_name, knockout_matches)
      matches_in_round = knockout_matches.select { |match| match.round == round_name }
      teams = teams_for_round(round_name, knockout_matches)

      matches_in_round.each_with_index.map do |match, index|
        team_a = teams[index * 2] || match.team_a
        team_b = teams[index * 2 + 1] || match.team_b

        {
          match: match,
          team_a: team_a,
          team_b: team_b
        }
      end
    end

    private

    attr_reader :user

    def group_standings
      guesses = user.guesses.select { |guess| guess.match.present? && guess.match.group.present? }

      grouped = Hash.new { |hash, key| hash[key] = Hash.new { |stats, team_id| stats[team_id] = { team: nil, points: 0, goal_difference: 0, goals_for: 0 } } }

      guesses.each do |guess|
        match = guess.match
        group_name = match.group.name

        update_group_stats(grouped[group_name], match.team_a, guess.goals_a.to_i, guess.goals_b.to_i)
        update_group_stats(grouped[group_name], match.team_b, guess.goals_b.to_i, guess.goals_a.to_i)
        award_points(grouped[group_name], match.team_a, match.team_b, guess.goals_a.to_i, guess.goals_b.to_i)
      end

      grouped.keys.sort.each_with_object({}) do |group_name, result|
        result[group_name] = grouped[group_name].values.compact.sort_by { |team| sort_key(team) }
      end
    end

    def update_group_stats(stats, team, goals_for, goals_against)
      entry = stats[team.id]
      entry[:team] = team
      entry[:goals_for] += goals_for
      entry[:goal_difference] += (goals_for - goals_against)
    end

    def award_points(stats, team_a, team_b, goals_a, goals_b)
      if goals_a > goals_b
        stats[team_a.id][:points] += 3
      elsif goals_b > goals_a
        stats[team_b.id][:points] += 3
      else
        stats[team_a.id][:points] += 1
        stats[team_b.id][:points] += 1
      end
    end

    def sort_key(team)
      [-team[:points], -team[:goal_difference], -team[:goals_for], team[:team].name]
    end

    def teams_for_round(round_name, knockout_matches)
      case round_name
      when 'round_of_32'
        round_of_32_teams
      when 'round_of_16'
        advancing_teams_from_round('round_of_32', knockout_matches)
      when 'quarter_final'
        advancing_teams_from_round('round_of_16', knockout_matches)
      when 'semi_final'
        advancing_teams_from_round('quarter_final', knockout_matches)
      when 'third_place', 'final'
        advancing_teams_from_round('semi_final', knockout_matches, losers: round_name == 'third_place')
      else
        []
      end
    end

    def round_of_32_teams
      preview[:pairs].flatten.map { |pair| pair[:team] }
    end

    def advancing_teams_from_round(round_name, knockout_matches, losers: false)
      knockout_matches.
        select { |match| match.round == round_name }.
        sort_by { |match| match.datetime }.
        map { |match| team_from_guess(match.my_guess, losers: losers) }.
        compact
    end

    def team_from_guess(guess, losers: false)
      return nil if guess.blank?
      return losing_team_for_guess(guess) if losers

      guess.advancing_team
    end

    def losing_team_for_guess(guess)
      return nil if guess.blank? || guess.advancing_team.blank?

      match = guess.match
      return match.team_b if guess.advancing_team_id == match.team_a_id
      return match.team_a if guess.advancing_team_id == match.team_b_id

      nil
    end
  end
end