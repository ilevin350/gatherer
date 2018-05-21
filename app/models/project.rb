# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  due_date   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  def self.velocity_length_in_days
    21
  end

  def incomplete_tasks
    tasks.reject { |t| t.complete? }
  end

  # noinspection RubyArgCount
  def done?
    incomplete_tasks.empty?
  end

  def total_size
    tasks.sum { |t| t.size }
  end

  def remaining_size
    incomplete_tasks.sum { |t| t.size }
  end

  def completed_velocity
    tasks.sum { |t| t.points_toward_velocity }
  end

  def current_rate
    completed_velocity * 1.0 / Project.velocity_length_in_days
  end

  def projected_days_remaining
    remaining_size / current_rate
  end

  def on_schedule?
    !projected_days_remaining.infinite?  && (Time.zone.today + projected_days_remaining) <= due_date
  end
end
