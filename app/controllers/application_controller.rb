class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!, :side_menu
  before_filter :configure_devise_params, if: :devise_controller?

  protect_from_forgery with: :exception

  def side_menu
    @users = User.rank.decorate
    @today_matches = Match.today.decorate
    @upcoming_matches = Match.open_to_guesses.includes(:team_a, :team_b).order(:datetime).limit(5).decorate
  end

  # needed to accept the user name
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end

    # allow `login` parameter for sign in (username or email)
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:login, :password, :remember_me)
    end
  end

  # After sign in, force the user to change password if required by the account.
  def after_sign_in_path_for(resource)
    if resource.respond_to?(:must_change_password) && resource.must_change_password?
      flash[:alert] = 'Por favor, altere sua senha agora.'
      edit_user_registration_path
    else
      super
    end
  end
end
