module Bolao
  module Worldcup2026
    TEAM_ALIASES = {
      'Mexico' => 'México',
      'South Africa' => 'África do Sul',
      'South Korea' => 'Coreia do Sul',
      'Czech Republic' => 'República Tcheca',
      'Canada' => 'Canadá',
      'Bosnia & Herzegovina' => 'Bósnia e Herzegovina',
      'Qatar' => 'Catar',
      'Switzerland' => 'Suíça',
      'Brazil' => 'Brasil',
      'Morocco' => 'Marrocos',
      'Haiti' => 'Haiti',
      'Scotland' => 'Escócia',
      'USA' => 'Estados Unidos',
      'Paraguay' => 'Paraguai',
      'Australia' => 'Austrália',
      'Turkey' => 'Turquia',
      'Germany' => 'Alemanha',
      'Curaçao' => 'Curaçao',
      'Ivory Coast' => 'Costa do Marfim',
      'Ecuador' => 'Equador',
      'Netherlands' => 'Holanda',
      'Japan' => 'Japão',
      'Sweden' => 'Suécia',
      'Tunisia' => 'Tunísia',
      'Belgium' => 'Bélgica',
      'Egypt' => 'Egito',
      'Iran' => 'Irã',
      'New Zealand' => 'Nova Zelândia',
      'Spain' => 'Espanha',
      'Cape Verde' => 'Cabo Verde',
      'Saudi Arabia' => 'Arábia Saudita',
      'Uruguay' => 'Uruguai',
      'France' => 'França',
      'Senegal' => 'Senegal',
      'Iraq' => 'Iraque',
      'Norway' => 'Noruega',
      'Argentina' => 'Argentina',
      'Algeria' => 'Argélia',
      'Austria' => 'Áustria',
      'Jordan' => 'Jordânia',
      'Portugal' => 'Portugal',
      'DR Congo' => 'República Democrática do Congo',
      'Uzbekistan' => 'Uzbequistão',
      'Colombia' => 'Colômbia',
      'England' => 'Inglaterra',
      'Croatia' => 'Croácia',
      'Ghana' => 'Gana',
      'Panama' => 'Panamá'
    }.freeze

    KNOWN_ROUNDS = {
      'Round of 32' => 'round_of_32',
      'Round of 16' => 'round_of_16',
      'Quarter-final' => 'quarter_final',
      'Semi-final' => 'semi_final',
      'Final' => 'final',
      'Match for third place' => 'third_place'
    }.freeze

    def self.local_team_name(source_name)
      TEAM_ALIASES[source_name] || source_name
    end

    def self.local_round_name(source_round)
      KNOWN_ROUNDS[source_round] || source_round.to_s.parameterize('_')
    end
  end
end