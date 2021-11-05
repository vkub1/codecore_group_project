class Booking < ApplicationRecord
  belongs_to :facility
  belongs_to :course

  validate :no_booking_overlap

 scope :overlapping, ->(start_time, end_time) do
    where "((start_time <= ?) and (end_time >= ?))", end_time, start_time
 end


  private

  def no_booking_overlap
    if (Booking.overlapping(start_time, end_time).any?)
      errors.add(:end_time, 'overlaps another booking')
    end
  end

end
