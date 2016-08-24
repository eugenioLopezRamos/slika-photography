require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  @user = User.new(name: "Example User", email: "user@example.com")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "name should not be too short" do
    @user.name = "a" * 3
    assert_not @user.valid?
  end
  

  
  test "email should not be too long" do
    @user.email = "a" * 250 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email should be valid" do
  valid_addresses = %w[aaa@hey.com user@example.com ilike@this.com pedro@perez.com]
  
  valid_addresses.each do |valid_address|
  @user.email = valid_address
  assert @user.valid?, "#{valid_address.inspect} should be valid"
  end
  end
  
  test "email shouldn't be invalid" do
  invalid_addresses = %w[aaa_el.com uuuu@.cl mymail@example,com my.nameAThome.com hello@my+your.com]
  
  invalid_addresses.each do |invalid_address|
  @user.email = invalid_address
  assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
  end
  end
  
  test "email should be unique" do
  duplicate_user = @user.dup
  @user.save
  assert_not duplicate_user.valid?
  end

  test "email should be saved as lowercase" do
  mixed_case_email = "MiXeDcaSe@eMaiL.com"
  @user.email = mixed_case_email
  @user.save
  assert_equal mixed_case_email.downcase, @user.reload.email #works without .reload too
  
  end
  
  
end
