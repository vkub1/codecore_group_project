class Tagging < ApplicationRecord
  belongs_to :course, optional: true
  belongs_to :facility, optional: true
  belongs_to :tag
end
