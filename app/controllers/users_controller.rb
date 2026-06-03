class UsersController < ApplicationController
  require 'csv'

  def profile
    @profile = User.find(params[:id]).decorate
  end

  def history
    @history = current_user.decorate
  end

  def export_guesses
    guesses = current_user.guesses.includes(:match, :advancing_team).joins(:match).order('matches.datetime ASC')

    csv = CSV.generate(headers: true) do |csv_builder|
      csv_builder << ['Data/Hora', 'Grupo/Fase', 'Jogo', 'Palpite', 'Quem avanca']

      guesses.each do |guess|
        csv_builder << [
          guess.match.datetime.to_time.strftime('%d/%m/%Y %Hh'),
          guess.match.section_label,
          "#{guess.match.team_a.try(:name) || t('guesses_page.to_be_defined')} x #{guess.match.team_b.try(:name) || t('guesses_page.to_be_defined')}",
          guess.to_s,
          guess.advancing_team.try(:name)
        ]
      end
    end

    send_data csv,
              filename: "meus-palpites-#{Time.now.strftime('%Y%m%d-%H%M')}.csv",
              type: 'text/csv; charset=utf-8'
  end

end