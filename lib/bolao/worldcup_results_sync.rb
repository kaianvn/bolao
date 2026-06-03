require 'json'
require 'open-uri'

module Bolao
  class WorldcupResultsSync
    SOURCE_URL = 'https://raw.githubusercontent.com/openfootball/worldcup.json/master/2026/worldcup.json'.freeze

    def self.call
      new.call
    end

    def call
      synced = 0

      source_matches.each do |source_match|
        next unless scored?(source_match)

        match = find_local_match(source_match)
        next if match.nil?

        result = final_score(source_match)
        attributes = { goals_a: result[0], goals_b: result[1] }
        attributes[:advancing_team_id] = winning_team_id(source_match) if match.knockout?

        match.update_attributes(attributes)
        synced += 1
      end

      synced
    end

    private

    def source_matches
      JSON.parse(open(SOURCE_URL).read)['matches'] || []
    end

    def scored?(source_match)
      source_match['score'].present? && source_match['score']['ft'].is_a?(Array)
    end

    def final_score(source_match)
      source_match['score']['ft']
    end

    def winning_team_id(source_match)
      winner_name = winning_team_name(source_match)
      return nil if winner_name.blank?

      team_name = Bolao::Worldcup2026.local_team_name(winner_name)
      Team.find_by(name: team_name).try(:id)
    end

    def winning_team_name(source_match)
      score = source_match['score'] || {}
      result = score['p'] || score['et'] || score['ft']
      return nil unless result.is_a?(Array) && result.size == 2

      return source_match['team1'] if result[0].to_i > result[1].to_i
      return source_match['team2'] if result[1].to_i > result[0].to_i

      nil
    end

    def find_local_match(source_match)
      candidates = Match.all.select do |match|
        match.datetime.to_date.to_s == source_match['date'] &&
          match.datetime.strftime('%H:%M') == source_time(source_match)
      end

      if source_match['group'].present?
        local_group = source_match['group'].sub(/^Group\s+/, '')
        team_a = Bolao::Worldcup2026.local_team_name(source_match['team1'])
        team_b = Bolao::Worldcup2026.local_team_name(source_match['team2'])

        candidates.find do |match|
          match.group.present? &&
            match.group.name == local_group &&
            match.team_a.try(:name) == team_a &&
            match.team_b.try(:name) == team_b
        end
      else
        local_round = Bolao::Worldcup2026.local_round_name(source_match['round'])
        candidates.find do |match|
          match.knockout? && match.round == local_round
        end
      end
    end

    def source_time(source_match)
      source_match['time'].to_s.split(' ').first
    end
  end
end