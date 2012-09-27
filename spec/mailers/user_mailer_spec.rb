require "spec_helper"

describe UserMailer do
  describe "email_confirmation" do
    let(:user) { FactoryGirl.create(:user, confirmation_code:"someconfirmationcode") }
    let(:mail) { UserMailer.email_confirmation(user) }

    it "renders the headers" do
      mail.subject.should eq("Email confirmation")
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(confirm_url(user, user.confirmation_code))
    end
  end

end
