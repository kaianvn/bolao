class UserDecorator < Draper::Decorator
  decorates_association :guesses, with: GuessDecorator
  decorates_association :public_guesses, with: GuessDecorator
  
  delegate :id, :name, :score, :admin, :position, :image, :email

  def profile_image
    image.presence || profile_image_fallback
  end

  private

  def profile_image_fallback
    if email.present?
      Gravatar.new(email).image_url + "?d=mm"
    else
      ActionController::Base.helpers.asset_path('4-profile.png')
    end
  end

end