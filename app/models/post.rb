class Post < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true
  scope :by_date_desc, -> { order(created_at: :desc) } #It seems using default scopes is...complicated to say at least, even for this case, which I thought it'd be fine,
  #eg. http://weblog.jamisbuck.org/2015/9/19/default-scopes-anti-pattern.html, http://stackoverflow.com/questions/25087336/why-is-using-the-rails-default-scope-often-recommend-against
  #
  
  
  
  
end
