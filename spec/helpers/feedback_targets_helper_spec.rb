require 'rails_helper'

describe FeedbackTargetsHelper do
  describe '#format_member_for_list' do
    let(:user) { FactoryGirl.create(:registered_user) }
    it { expect(format_member_for_list(user)).to eq("#{user.username} (#{user.email})")}
  end
end
