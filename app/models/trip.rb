class Trip < ApplicationRecord
  validates_presence_of :start_address, :destination_address
  validates :price, :distance, numericality: { greater_than: 0 }
end
