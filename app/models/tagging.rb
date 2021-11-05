class Tagging < ApplicationRecord
  belongs_to :course, optional: true
  belongs_to :facility, optional: true
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: [:facility_id, :course_id] }
end
