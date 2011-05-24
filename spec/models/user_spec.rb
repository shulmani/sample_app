require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"

  before(:each) do
    @attr = {:name=>"abc",:email=>"abc@test.com",:password=>"foobar", :password_confirmation=>"foobar"}
  end

  it "should create an instance of User given the right parameters"  do
   User.create!(@attr)
  end

  it "should require a name"do
    no_name_user= User.new(@attr.merge(:name=>""))
    no_name_user.should_not be_valid
  end

  it "should not exceed the maximum string length" do
     long_name = "a"* 51
     long_named_user = User.new(@attr.merge(:name=>long_name))
     long_named_user.should_not be_valid
  end

  it "should require a non blank email" do
       no_email_user=User.new(:name=>"sdsfg",:email=>"")
       no_email_user.should_not be_valid
  end

  it "should accept valid email address" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_user_email = User.new(@attr.merge(:email=>address))
        valid_user_email.should be_valid
      end
  end

  it "should reject invalid email address" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_user_email = User.new(@attr.merge(:email=>address))
        invalid_user_email.should_not be_valid
      end

  end

  it "should have unique email id" do
      User.create!(@attr)
      duplicate_test_user = User.new(@attr)
      duplicate_test_user.should_not be_valid
  end

  it "should check for uppercase email id's too" do
      User.create!(@attr)
      upCased_email = @attr[:email].upcase
      user_with_upcase_email = User.new(@attr.merge(:email=>upCased_email))
      user_with_upcase_email.should_not be_valid

  end

  it "should have a password"do
      user_without_password = User.new(@attr.merge(:password=>"",:password_confirmation=>""))
      user_without_password.should_not be_valid
  end

  it "should have the matching password confirmation"do
      user_with_wrong_pwd_conf = User.new(@attr.merge(:password_confirmation=>"eret"))
      user_with_wrong_pwd_conf.should_not be_valid
  end

  it "should not have a password of < 6 characters"do
    short="a"*5
    user_short_pwd = User.new(@attr.merge(:password=>short, :password_confirmation=>short))
    user_short_pwd.should_not be_valid
  end

  it "should not have a long password > 40 chars"do
    long="a"*5
    user_long_pwd = User.new(@attr.merge(:password=>long, :password_confirmation=>long))
    user_long_pwd.should_not be_valid
  end

  describe "ensure password encryption" do

    before(:each) do
      @user= User.create!(@attr)
    end

    it "should have an encrypted password field" do
      @user.should respond_to(:encrypted_password)
    end

    it "should not have a blank ecryption password"do
      @user.encrypted_password should_not_be_blank
    end

    it "should pass for same paswords"do
      @user.has_right_password?(@attr[:password]).should be_true
    end

    it "should fail for unlike passwords"do
      @user.has_right_password?("insjhgfd").should be_false
    end

    describe "authentication method"do

    it "should return nil for non existent user"do
      non_existent_user = User.authenticate_user("test@test.com","foobar")
      non_existent_user.should be_nil
    end

    it "should return the user for the given email"do
      existent_user = User.authenticate_user(@attr[:email],@attr[:password])
      existent_user.should == @user
    end

    it "should return nil for a existent user with wrong password"do
      wrong_pwd_user = User.authenticate_user(@attr[:email],"teetretw")
      wrong_pwd_user.should be_nil
    end
  end
 end
end