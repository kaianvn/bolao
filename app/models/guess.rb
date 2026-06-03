class Guess < ActiveRecord::Base
  include Winnerable

  validates :user,    presence: true
  validates :match,   presence: true
  validates :goals_a, presence: true
  validates :goals_b, presence: true
  validates :advancing_team, presence: true, if: :requires_advancing_team?

  validates :match, uniqueness: { scope: :user }

  belongs_to :user
  belongs_to :match
  belongs_to :advancing_team, class_name: 'Team', primary_key: :id, foreign_key: :advancing_team_id

  scope :finished, -> { joins(:match).where("matches.datetime < ?", Time.now) }

  def score
    return 0 if !match.finished?
    return 3 if match.goals_a == goals_a && match.goals_b == goals_b
    return 1 if match.winner == winner
    0
  end

  def to_s
    base = "#{goals_a} x #{goals_b}"
    advancing_team.present? ? "#{base} - #{advancing_team.name}" : base
  end

  private

  def requires_advancing_team?
    match.present? && match.knockout? && goals_a.present? && goals_b.present? && goals_a.to_i == goals_b.to_i
  end
end
