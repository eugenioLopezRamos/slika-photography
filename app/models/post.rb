class Post < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
  before_validation :create_slug
  validates :slug, presence: true


  scope :by_date_desc, -> { order(created_at: "desc") } #It seems using default scopes is...complicated to say at least, even for this case, which I thought it'd be fine,
  #eg. http://weblog.jamisbuck.org/2015/9/19/default-scopes-anti-pattern.html, http://stackoverflow.com/questions/25087336/why-is-using-the-rails-default-scope-often-recommend-against
  # another option, if this were a bigger database, would be to use find_by, which is ALWAYS ascending & faster since
  #it works with batches, and then just presenting the posts in the view with CSS flex-direction: column-reverse
  scope :by_date_asc, -> {order(created_at: "asc")}

  def to_param
  	slug
  end
  

  def create_slug
  	self.slug = ActionController::Base.helpers.strip_tags(self.title).downcase.parameterize
  end

  def preprocess_img_tags

  end
  




  
end
