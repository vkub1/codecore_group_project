class Booking < ApplicationRecord
  belongs_to :facility
  belongs_to :course

end
