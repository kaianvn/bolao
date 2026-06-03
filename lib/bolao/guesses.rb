module Bolao
  module Guesses

    # Saves the user guesses
    def self.save(params, user)
      return false if invalid_knockout_draw_submission?(params)

      params[:guesses].each do |g|
        match = Match.find(g[:match_id]).decorate
        next unless match.is_open_to_guesses?
        
        # avoid creating empty guesses
        next if g[:goals_a].empty? || g[:goals_b].empty?

        goals_a = g[:goals_a].to_i
        goals_b = g[:goals_b].to_i

        # If user provided a non-draw result for a knockout match, auto-set advancing_team
        advancing = g[:advancing_team_id].presence
        if advancing.blank?
          m = Match.find(g[:match_id])
          if m.knockout? && (g[:goals_a].present? && g[:goals_b].present?)
            if goals_a > goals_b
              advancing = m.team_a_id.to_s
            elsif goals_b > goals_a
              advancing = m.team_b_id.to_s
            end
          end
        end

        attributes = {
          goals_a: g[:goals_a],
          goals_b: g[:goals_b],
          advancing_team_id: advancing
        }

        if g[:id].empty?
          # Create a new guess if it doesn't exist yet
          Guess.create(attributes.merge(match_id: g[:match_id], user: user))
        else
          # Update current guess
          guess = Guess.find_by_id_and_user_id(g[:id], user.id)
          guess.update_attributes(attributes)
        end
      end
    end

    def self.invalid_knockout_draw_submission?(params)
      guesses = params[:guesses] || []

      guesses.any? do |g|
        next false if g[:match_id].blank?

        match = Match.find(g[:match_id])
        next false unless match.knockout?
        next false if g[:goals_a].blank? || g[:goals_b].blank?

        goals_a = g[:goals_a].to_i
        goals_b = g[:goals_b].to_i

        goals_a == goals_b && g[:advancing_team_id].blank?
      end
    end

  end
end