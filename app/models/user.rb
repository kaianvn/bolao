class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable,
         :validatable

  validates :name, presence: true

  # allow login via username (`name`) or email
  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  has_many :guesses

  # guesses for matches finished or started
  has_many :public_guesses, -> { joins(:match).where("matches.datetime <= ?", Time.now).order("matches.datetime DESC") }, 
           class_name: 'Guess', primary_key: :id, foreign_key: :user_id

  # put the users with no points (null = new user) to the end of the list
  scope :rank, -> { order('position IS NULL, position ASC') }

end