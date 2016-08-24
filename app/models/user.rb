class User < ApplicationRecord
validates :name, presence: true, length: {minimum: 5, maximum: 50}
validates :email, presence: true, length: {maximum: 255}


end
