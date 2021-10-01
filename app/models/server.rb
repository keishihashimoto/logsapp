class Server < ApplicationRecord
  has_many :logs
  has_many :troubles
end
