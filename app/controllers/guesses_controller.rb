class GuessesController < ApplicationController
  ROUND_ORDER_SQL = "CASE round WHEN 'round_of_32' THEN 1 WHEN 'round_of_16' THEN 2 WHEN 'quarter_final' THEN 3 WHEN 'semi_final' THEN 4 WHEN 'third_place' THEN 5 WHEN 'final' THEN 6 ELSE 99 END".freeze
  ROUND_SEQUENCE = %w[round_of_32 round_of_16 quarter_final semi_final third_place final].freeze

  def my_guesses
    @step = params[:step] == 'knockout' ? 'knockout' : 'groups'

    @group_stage_saved = group_stage_saved?
    if @step == 'knockout' && !@group_stage_saved
      flash[:alert] = 'Salve a fase de grupos antes de acessar o mata-mata.'
      redirect_to my_guesses_path(step: 'groups') and return
    end

    # get all open matches including and associates the current user guesses to it
    @bracket_preview = Bolao::Bracket.for(current_user)

    @grouped_matches = Match.
                          open_to_guesses.
                          group_stage.
                          includes(:team_a, :team_b, :group).
                          includes(:guesses => :user).
                          group_ordered.
                          order("datetime ASC").
                          decorate(context: {user: current_user}).
                          group_by(&:group)

    @knockout_matches = Match.
                includes(:team_a, :team_b, :group).
                includes(:guesses => :user).
                knockout.
                order("#{ROUND_ORDER_SQL} ASC, datetime ASC").
                decorate(context: {user: current_user})

    @knockout_rounds = Bolao::Bracket::KNOCKOUT_ROUNDS.select { |round_name| @knockout_matches.any? { |match| match.round == round_name } }
    current_open_knockout = @knockout_matches.find { |match| match.is_open_to_guesses? }
    @selected_round = params[:knockout_round].presence || (current_open_knockout ? current_open_knockout.round : nil) || @knockout_rounds.first
    @knockout_preview = @selected_round.present? ? Bolao::Bracket.new(current_user).knockout_preview(@selected_round, @knockout_matches) : []
  end

  def update
    saved = Bolao::Guesses.save(params, current_user)

    unless saved == false
      flash[:success] = t("guesses_page.guesses_saved")

      if params[:advance_to_knockout].present?
        redirect_to my_guesses_path(step: 'knockout', knockout_round: next_knockout_round(params[:knockout_round])) and return
      else
        redirect_to my_guesses_path(step: params[:step], knockout_round: params[:knockout_round]) and return
      end
    end

    flash[:alert] = 'Ainda falta preencher quem avança em pelo menos um empate do mata-mata.'
    redirect_to my_guesses_path(step: 'knockout', knockout_round: params[:knockout_round])
  end

  def destroy_all
    current_user.guesses.delete_all
    flash[:success] = 'Seus palpites foram apagados. Você pode recomeçar do zero.'
    redirect_to my_guesses_path(step: 'groups')
  end

  private

  def next_knockout_round(current_round)
    return ROUND_SEQUENCE.first if current_round.blank?

    current_index = ROUND_SEQUENCE.index(current_round.to_s)
    return ROUND_SEQUENCE.first if current_index.nil?

    next_round = ROUND_SEQUENCE[current_index + 1]
    return current_round if next_round.blank?

    next_round
  end

  def group_stage_saved?
    guessed_group_matches = current_user.guesses.joins(:match).where(matches: { phase: Match::PHASE_GROUP }).distinct.count(:match_id)
    guessed_group_matches >= Match.group_stage.count
  end
end