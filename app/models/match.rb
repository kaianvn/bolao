class Match < ActiveRecord::Base
  include Winnerable

  PHASE_GROUP = 'group'.freeze
  PHASE_KNOCKOUT = 'knockout'.freeze

  before_validation :set_default_phase

  validates :datetime, presence: true
  validates :phase,    presence: true
  validates :group,    presence: true, if: :group_stage?
  validates :team_a,   presence: true, if: :group_stage?
  validates :team_b,   presence: true, if: :group_stage?
  validates :round,    presence: true, if: :knockout?

  belongs_to :team_a, class_name: 'Team', primary_key: :id, foreign_key: :team_a_id
  belongs_to :team_b, class_name: 'Team', primary_key: :id, foreign_key: :team_b_id
  belongs_to :advancing_team, class_name: 'Team', primary_key: :id, foreign_key: :advancing_team_id
  belongs_to :group

  has_many :guesses

  scope :active, -> { joins(:group).where("groups.active = ?", true) }
  scope :group_stage, -> { where(phase: PHASE_GROUP) }
  scope :knockout, -> { where(phase: PHASE_KNOCKOUT) }
  scope :open_to_guesses, -> { where("datetime > ?", Time.now) }
  scope :group_ordered, -> { joins(:group).order("groups.name") }
  scope :today, -> { where("DATE(datetime) = DATE(?)", Time.now).order(:datetime) }

  def finished?
    !goals_a.nil? && !goals_b.nil?
  end

  def is_open_to_guesses?
    self.datetime > Time.now
  end

  def group_stage?
    phase.blank? || phase == PHASE_GROUP
  end

  def knockout?
    phase == PHASE_KNOCKOUT
  end

  def section_label
    return group.name if group.present?
    return round.humanize if round.present?

    phase.to_s.humanize
  end

  private

  def set_default_phase
    self.phase = PHASE_GROUP if phase.blank?
  end
end