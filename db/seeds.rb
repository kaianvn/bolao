# frozen_string_literal: true

def logo_url_for(code)
  case code
  when 'gb-eng'
    'https://upload.wikimedia.org/wikipedia/en/b/be/Flag_of_England.svg'
  when 'gb-sct'
    'https://upload.wikimedia.org/wikipedia/commons/1/10/Flag_of_Scotland.svg'
  else
    "https://flagcdn.com/w320/#{code}.png"
  end
end

def create_team(name, code)
  Team.create!(name: name, logo_url: logo_url_for(code))
end

def create_match(datetime, team_a_name, team_b_name, group_name)
  Match.create!(
    datetime: datetime,
    team_a: Team.find_by!(name: team_a_name),
    team_b: Team.find_by!(name: team_b_name),
    group: Group.find_by!(name: group_name)
  )
end

def create_knockout_match(datetime, round_name)
  Match.create!(
    datetime: datetime,
    phase: 'knockout',
    round: round_name
  )
end

Guess.delete_all
Match.delete_all
Team.delete_all
Group.delete_all

%w[A B C D E F G H I J K L].each do |group_name|
  Group.create!(name: group_name)
end

{
  'México' => 'mx',
  'África do Sul' => 'za',
  'Coreia do Sul' => 'kr',
  'República Tcheca' => 'cz',
  'Canadá' => 'ca',
  'Bósnia e Herzegovina' => 'ba',
  'Catar' => 'qa',
  'Suíça' => 'ch',
  'Brasil' => 'br',
  'Marrocos' => 'ma',
  'Haiti' => 'ht',
  'Escócia' => 'gb-sct',
  'Estados Unidos' => 'us',
  'Paraguai' => 'py',
  'Austrália' => 'au',
  'Turquia' => 'tr',
  'Alemanha' => 'de',
  'Curaçao' => 'cw',
  'Costa do Marfim' => 'ci',
  'Equador' => 'ec',
  'Holanda' => 'nl',
  'Japão' => 'jp',
  'Suécia' => 'se',
  'Tunísia' => 'tn',
  'Bélgica' => 'be',
  'Egito' => 'eg',
  'Irã' => 'ir',
  'Nova Zelândia' => 'nz',
  'Espanha' => 'es',
  'Cabo Verde' => 'cv',
  'Arábia Saudita' => 'sa',
  'Uruguai' => 'uy',
  'França' => 'fr',
  'Senegal' => 'sn',
  'Iraque' => 'iq',
  'Noruega' => 'no',
  'Argentina' => 'ar',
  'Argélia' => 'dz',
  'Áustria' => 'at',
  'Jordânia' => 'jo',
  'Portugal' => 'pt',
  'República Democrática do Congo' => 'cd',
  'Uzbequistão' => 'uz',
  'Colômbia' => 'co',
  'Inglaterra' => 'gb-eng',
  'Croácia' => 'hr',
  'Gana' => 'gh',
  'Panamá' => 'pa'
}.each do |name, code|
  create_team(name, code)
end

[
  ['2026-06-11 13:00:00', 'México', 'África do Sul', 'A'],
  ['2026-06-12 16:00:00', 'Coreia do Sul', 'República Tcheca', 'A'],
  ['2026-06-18 12:00:00', 'República Tcheca', 'África do Sul', 'A'],
  ['2026-06-18 19:00:00', 'México', 'Coreia do Sul', 'A'],
  ['2026-06-24 19:00:00', 'República Tcheca', 'México', 'A'],
  ['2026-06-24 19:00:00', 'África do Sul', 'Coreia do Sul', 'A'],

  ['2026-06-12 15:00:00', 'Canadá', 'Bósnia e Herzegovina', 'B'],
  ['2026-06-13 12:00:00', 'Catar', 'Suíça', 'B'],
  ['2026-06-18 12:00:00', 'Suíça', 'Bósnia e Herzegovina', 'B'],
  ['2026-06-18 15:00:00', 'Canadá', 'Catar', 'B'],
  ['2026-06-24 12:00:00', 'Suíça', 'Canadá', 'B'],
  ['2026-06-24 12:00:00', 'Bósnia e Herzegovina', 'Catar', 'B'],

  ['2026-06-13 18:00:00', 'Brasil', 'Marrocos', 'C'],
  ['2026-06-13 21:00:00', 'Haiti', 'Escócia', 'C'],
  ['2026-06-19 18:00:00', 'Escócia', 'Marrocos', 'C'],
  ['2026-06-19 20:30:00', 'Brasil', 'Haiti', 'C'],
  ['2026-06-24 18:00:00', 'Escócia', 'Brasil', 'C'],
  ['2026-06-24 18:00:00', 'Marrocos', 'Haiti', 'C'],

  ['2026-06-12 18:00:00', 'Estados Unidos', 'Paraguai', 'D'],
  ['2026-06-13 21:00:00', 'Austrália', 'Turquia', 'D'],
  ['2026-06-19 12:00:00', 'Estados Unidos', 'Austrália', 'D'],
  ['2026-06-19 20:00:00', 'Turquia', 'Paraguai', 'D'],
  ['2026-06-25 19:00:00', 'Turquia', 'Estados Unidos', 'D'],
  ['2026-06-25 19:00:00', 'Paraguai', 'Austrália', 'D'],

  ['2026-06-14 12:00:00', 'Alemanha', 'Curaçao', 'E'],
  ['2026-06-14 19:00:00', 'Costa do Marfim', 'Equador', 'E'],
  ['2026-06-20 12:00:00', 'Alemanha', 'Costa do Marfim', 'E'],
  ['2026-06-20 19:00:00', 'Equador', 'Curaçao', 'E'],
  ['2026-06-25 16:00:00', 'Curaçao', 'Costa do Marfim', 'E'],
  ['2026-06-25 16:00:00', 'Equador', 'Alemanha', 'E'],

  ['2026-06-14 15:00:00', 'Holanda', 'Japão', 'F'],
  ['2026-06-14 20:00:00', 'Suécia', 'Tunísia', 'F'],
  ['2026-06-20 12:00:00', 'Holanda', 'Suécia', 'F'],
  ['2026-06-20 22:00:00', 'Tunísia', 'Japão', 'F'],
  ['2026-06-25 18:00:00', 'Japão', 'Suécia', 'F'],
  ['2026-06-25 18:00:00', 'Tunísia', 'Holanda', 'F'],

  ['2026-06-15 12:00:00', 'Bélgica', 'Egito', 'G'],
  ['2026-06-15 18:00:00', 'Irã', 'Nova Zelândia', 'G'],
  ['2026-06-21 12:00:00', 'Bélgica', 'Irã', 'G'],
  ['2026-06-21 18:00:00', 'Nova Zelândia', 'Egito', 'G'],
  ['2026-06-26 20:00:00', 'Egito', 'Irã', 'G'],
  ['2026-06-26 20:00:00', 'Nova Zelândia', 'Bélgica', 'G'],

  ['2026-06-15 12:00:00', 'Espanha', 'Cabo Verde', 'H'],
  ['2026-06-15 18:00:00', 'Arábia Saudita', 'Uruguai', 'H'],
  ['2026-06-21 12:00:00', 'Espanha', 'Arábia Saudita', 'H'],
  ['2026-06-21 18:00:00', 'Uruguai', 'Cabo Verde', 'H'],
  ['2026-06-26 19:00:00', 'Cabo Verde', 'Arábia Saudita', 'H'],
  ['2026-06-26 18:00:00', 'Uruguai', 'Espanha', 'H'],

  ['2026-06-16 15:00:00', 'França', 'Senegal', 'I'],
  ['2026-06-16 18:00:00', 'Iraque', 'Noruega', 'I'],
  ['2026-06-22 17:00:00', 'França', 'Iraque', 'I'],
  ['2026-06-22 20:00:00', 'Noruega', 'Senegal', 'I'],
  ['2026-06-26 15:00:00', 'Noruega', 'França', 'I'],
  ['2026-06-26 15:00:00', 'Senegal', 'Iraque', 'I'],

  ['2026-06-16 20:00:00', 'Argentina', 'Argélia', 'J'],
  ['2026-06-16 21:00:00', 'Áustria', 'Jordânia', 'J'],
  ['2026-06-22 12:00:00', 'Argentina', 'Áustria', 'J'],
  ['2026-06-22 20:00:00', 'Jordânia', 'Argélia', 'J'],
  ['2026-06-27 21:00:00', 'Argélia', 'Áustria', 'J'],
  ['2026-06-27 21:00:00', 'Jordânia', 'Argentina', 'J'],

  ['2026-06-17 12:00:00', 'Portugal', 'República Democrática do Congo', 'K'],
  ['2026-06-17 20:00:00', 'Uzbequistão', 'Colômbia', 'K'],
  ['2026-06-23 12:00:00', 'Portugal', 'Uzbequistão', 'K'],
  ['2026-06-23 20:00:00', 'Colômbia', 'República Democrática do Congo', 'K'],
  ['2026-06-27 19:30:00', 'Colômbia', 'Portugal', 'K'],
  ['2026-06-27 19:30:00', 'República Democrática do Congo', 'Uzbequistão', 'K'],

  ['2026-06-17 15:00:00', 'Inglaterra', 'Croácia', 'L'],
  ['2026-06-17 19:00:00', 'Gana', 'Panamá', 'L'],
  ['2026-06-23 16:00:00', 'Inglaterra', 'Gana', 'L'],
  ['2026-06-23 19:00:00', 'Panamá', 'Croácia', 'L'],
  ['2026-06-27 17:00:00', 'Panamá', 'Inglaterra', 'L'],
  ['2026-06-27 17:00:00', 'Croácia', 'Gana', 'L']
].each do |datetime, team_a_name, team_b_name, group_name|
  create_match(datetime, team_a_name, team_b_name, group_name)
end

[
  '2026-06-29 12:00:00',
  '2026-06-29 15:00:00',
  '2026-06-29 18:00:00',
  '2026-06-29 21:00:00',
  '2026-06-30 12:00:00',
  '2026-06-30 15:00:00',
  '2026-06-30 18:00:00',
  '2026-06-30 21:00:00',
  '2026-07-01 12:00:00',
  '2026-07-01 15:00:00',
  '2026-07-01 18:00:00',
  '2026-07-01 21:00:00',
  '2026-07-02 12:00:00',
  '2026-07-02 15:00:00',
  '2026-07-02 18:00:00',
  '2026-07-02 21:00:00'
].each do |datetime|
  create_knockout_match(datetime, 'round_of_32')
end

[
  '2026-07-04 12:00:00',
  '2026-07-04 17:00:00',
  '2026-07-05 16:00:00',
  '2026-07-05 18:00:00',
  '2026-07-06 14:00:00',
  '2026-07-06 17:00:00',
  '2026-07-07 12:00:00',
  '2026-07-07 13:00:00'
].each do |datetime|
  create_knockout_match(datetime, 'round_of_16')
end

[
  '2026-07-09 16:00:00',
  '2026-07-10 12:00:00',
  '2026-07-11 17:00:00',
  '2026-07-11 20:00:00'
].each do |datetime|
  create_knockout_match(datetime, 'quarter_final')
end

[
  '2026-07-14 14:00:00',
  '2026-07-15 15:00:00'
].each do |datetime|
  create_knockout_match(datetime, 'semi_final')
end

create_knockout_match('2026-07-18 17:00:00', 'third_place')
create_knockout_match('2026-07-19 15:00:00', 'final')

# Create an initial admin user from ENV variables or default credentials.
# Use APP_ADMIN_EMAIL and APP_ADMIN_PASSWORD in the .env file for customization.
admin_name = ENV['APP_ADMIN_NAME'] || ENV['APP_ADMIN_USERNAME'] || 'Admin'
admin_email = ENV['APP_ADMIN_EMAIL'] || 'admin@example.com'
admin_password = ENV['APP_ADMIN_PASSWORD'] || 'changeme123'

if User.where(email: admin_email).none?
  puts "Creating admin user: #{admin_email}"
  u = User.new(name: admin_name, email: admin_email, password: admin_password, password_confirmation: admin_password)
  u.admin = true if u.respond_to?(:admin=)
  u.must_change_password = true if u.respond_to?(:must_change_password=)
  if u.save
    puts "Admin user created: #{admin_email} (please change the password on first login)"
  else
    puts "Failed to create admin user: #{u.errors.full_messages.join(', ')}"
  end
else
  puts "Admin user already exists: #{admin_email}"
end