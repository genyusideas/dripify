require 'spec_helper'

describe User do
  before do
    @user = User.new do |u|
      u.email = 'test@user.com'
      u.password = 'foobar12'
      u.password_confirmation = 'foobar12'
      u.first_name = 'test'
      u.last_name = 'user'
    end
  end

  subject { @user }

  it { should respond_to( :email ) }
  it { should respond_to( :first_name ) }
  it { should respond_to( :last_name ) }
  it { should respond_to( :social_media_accounts ) }

  it { should be_valid }

  describe "when email is not set" do
    before { @user.email = ' ' }
    it { should_not be_valid }
  end

  describe "when first_name is not set" do
    before { @user.first_name = ' ' }
    it { should_not be_valid }
  end

  describe "when last_name is not set" do
    before { @user.last_name = ' ' }
    it { should_not be_valid }
  end

  describe "when first_name is too long" do
    before { @user.first_name = 'a' * 257 }
    it { should_not be_valid }
  end

  describe "when last_name is too long" do
    before { @user.last_name = 'a' * 257 }
    it { should_not be_valid }
  end

  describe "when first_name is at max length" do
    before { @user.first_name = 'a' * 256 }
    it { should be_valid }
  end

  describe "when last_name is at max length" do
    before { @user.last_name = 'a' * 256 }
    it { should be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when adding a social media account" do
    before do
      @social = @user.social_media_accounts.build do |s|
        s.handle = 'testuser'
        s.handle_id = 'testhandleid'
      end
    end

    it "should have the account" do
      @user.social_media_accounts.should == [@social]
    end

    describe "when adding a second social media account" do
      before do
        @social_second = @user.social_media_accounts.build do |s|
          s.handle = '2ndtestuser'
          s.handle_id = '2ndtesthandleid'
        end
      end

      it "should have both accounts" do
        @user.social_media_accounts.should == [@social, @social_second]
      end
    end
  end
end
