class Trip < ApplicationRecord
  validates_presence_of :start_address, :destination_address
  validates :price, numericality: { greater_than: 0 }
end