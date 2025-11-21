class DashboardController < ApplicationController
  before_action :require_login

  # Shows referral requests for posts owned by current_user
  def index
    # Join referral_requests to referral_posts and filter posts owned by current_user
    @referral_requests = ReferralRequest.joins(:referral_post)
                                        .where(referral_posts: { user_id: current_user.id })
                                        .includes(:user, :referral_post)
                                        .order(created_at: :desc)
  end
end
