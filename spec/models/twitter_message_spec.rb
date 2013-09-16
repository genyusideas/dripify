require 'spec_helper'

describe TwitterMessage do
  let( :message ) { FactoryGirl.create( :twitter_message ) }

  subject { message }

  it { should respond_to(:message) }
  it { should respond_to(:recipient_id) }
  it { should respond_to(:status) }
  it { should respond_to(:pending?) }
  it { should respond_to(:sent?) }
  it { should respond_to(:error?) }
  it { should respond_to(:pending!) }
  it { should respond_to(:sent!) }
  it { should respond_to(:error!) }
  it { should respond_to(:twitter_account_id) }
  it { should respond_to(:twitter_account) }
  it { should respond_to(:send_date) }
  it { should be_valid }

  describe "when message is not set" do
    before { message.message = ' ' }
    it { should_not be_valid }
  end

  describe "when status is not set" do
    before { message.status = ' ' }
    it { should_not be_valid }
  end

  describe "when recipient id is not set" do
    before { message.recipient_id = ' ' }
    it { should_not be_valid }
  end

  describe "when send date is not set" do
    before { message.send_date = ' ' }
    it { should_not be_valid }
  end

  describe "when message is too long" do
    before { message.message = 'a' * 10001 }
    it { should_not be_valid }
  end

  # TODO: Implement this test
  # describe "when send date is in the past" do
  #   before { message.send_date = Date.new(2000, 1, 1) }
  #   it { should_not be_valid }
  # end

  describe "when changing a message to error" do
    before { message.error! }
    it { should be_error }

    describe "when changing a message to sent" do
      before { message.sent! }
      it { should be_sent }
    end

    describe "when changing to pending" do
      before { message.pending! }
      it { should be_pending }
    end
  end
end
