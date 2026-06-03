module ApplicationHelper
	def profile_image_for(user)
		return user.profile_image if user.respond_to?(:profile_image)

		user.image.presence || profile_image_fallback(user.email)
	end

	def team_flag_for(team)
		return if team.blank?

		if team.respond_to?(:flag)
			team.flag
		else
			team.logo_url.presence || "http://e.imguol.com/futebol/brasoes-redondos/100x100-borda-preta/#{team.slug}.png"
		end
	end

	def guess_stats_for(match)
		guesses = match.guesses.to_a
		total = guesses.size

		home_wins = guesses.count { |guess| guess.goals_a.to_i > guess.goals_b.to_i }
		away_wins = guesses.count { |guess| guess.goals_b.to_i > guess.goals_a.to_i }
		draws = guesses.count { |guess| guess.goals_a.to_i == guess.goals_b.to_i }

		if total.zero?
			return { total: 0, home_pct: 0, away_pct: 0, draw_pct: 0 }
		end

		home_pct = ((home_wins * 100.0) / total).round
		away_pct = ((away_wins * 100.0) / total).round
		draw_pct = [100 - home_pct - away_pct, 0].max

		{ total: total, home_pct: home_pct, away_pct: away_pct, draw_pct: draw_pct }
	end

	def team_country_code(team)
		return if team.blank?

		codes = {
			'México' => 'MEX',
			'África do Sul' => 'RSA',
			'Coreia do Sul' => 'KOR',
			'República Tcheca' => 'CZE',
			'Canadá' => 'CAN',
			'Bósnia e Herzegovina' => 'BIH',
			'Catar' => 'QAT',
			'Suíça' => 'SUI',
			'Brasil' => 'BRA',
			'Marrocos' => 'MAR',
			'Haiti' => 'HAI',
			'Escócia' => 'SCO',
			'Estados Unidos' => 'USA',
			'Paraguai' => 'PAR',
			'Austrália' => 'AUS',
			'Turquia' => 'TUR',
			'Alemanha' => 'GER',
			'Curaçao' => 'CUW',
			'Costa do Marfim' => 'CIV',
			'Equador' => 'ECU',
			'Holanda' => 'NED',
			'Japão' => 'JPN',
			'Suécia' => 'SWE',
			'Tunísia' => 'TUN',
			'Bélgica' => 'BEL',
			'Egito' => 'EGY',
			'Irã' => 'IRN',
			'Nova Zelândia' => 'NZL',
			'Espanha' => 'ESP',
			'Cabo Verde' => 'CPV',
			'Arábia Saudita' => 'KSA',
			'Uruguai' => 'URU',
			'França' => 'FRA',
			'Senegal' => 'SEN',
			'Iraque' => 'IRQ',
			'Noruega' => 'NOR',
			'Argentina' => 'ARG',
			'Argélia' => 'ALG',
			'Áustria' => 'AUT',
			'Jordânia' => 'JOR',
			'Portugal' => 'POR',
			'República Democrática do Congo' => 'COD',
			'Uzbequistão' => 'UZB',
			'Colômbia' => 'COL',
			'Inglaterra' => 'ENG',
			'Croácia' => 'CRO',
			'Gana' => 'GHA',
			'Panamá' => 'PAN'
		}

		codes[team.name] || team.name.split.map { |part| part[0] }.join.upcase
	end

	def team_legend_style(team)
		return "background-color: #ffffff; color: #000; border: 1px solid #c7d4ee;" if team.blank?

		palette = {
			'México' => '#006847',
			'África do Sul' => '#007749',
			'Coreia do Sul' => '#cd2e3a',
			'República Tcheca' => '#11457e',
			'Canadá' => '#d80621',
			'Bósnia e Herzegovina' => '#002395',
			'Catar' => '#8d1b3d',
			'Suíça' => '#d52b1e',
			'Brasil' => '#009c3b',
			'Marrocos' => '#c1272d',
			'Haiti' => '#00209f',
			'Escócia' => '#005eb8',
			'Estados Unidos' => '#b22234',
			'Paraguai' => '#0038a8',
			'Austrália' => '#012169',
			'Turquia' => '#e30a17',
			'Alemanha' => '#000000',
			'Curaçao' => '#002b7f',
			'Costa do Marfim' => '#f77f00',
			'Equador' => '#ffd100',
			'Holanda' => '#ae1c28',
			'Japão' => '#bc002d',
			'Suécia' => '#006aa7',
			'Tunísia' => '#e70013',
			'Bélgica' => '#000000',
			'Egito' => '#ce1126',
			'Irã' => '#239f40',
			'Nova Zelândia' => '#000000',
			'Espanha' => '#c60b1e',
			'Cabo Verde' => '#003893',
			'Arábia Saudita' => '#006c35',
			'Uruguai' => '#0038a8',
			'França' => '#0055a4',
			'Senegal' => '#00853f',
			'Iraque' => '#ce1126',
			'Noruega' => '#ba0c2f',
			'Argentina' => '#74acdf',
			'Argélia' => '#006233',
			'Áustria' => '#ed2939',
			'Jordânia' => '#ce1126',
			'Portugal' => '#006600',
			'República Democrática do Congo' => '#00a3e0',
			'Uzbequistão' => '#1eb53a',
			'Colômbia' => '#fcd116',
			'Inglaterra' => '#cf142b',
			'Croácia' => '#171796',
			'Gana' => '#ce1126',
			'Panamá' => '#d21034'
		}

		"background-color: #{palette[team.name] || '#4e5d6c'}; color: #fff;"
	end

	private

	def profile_image_fallback(email)
		if email.present?
			Gravatar.new(email).image_url + "?d=mm"
		else
			asset_path('4-profile.png')
		end
	end
end
