require 'rails_helper'

RSpec.describe "ReferralRequests", type: :request do
  let!(:poster) do
    User.create!(
      email: "poster@tamu.edu",
      password: "password123",
      password_confirmation: "password123",
      first_name: "Poster",
      last_name: "User"
    )
  end

  let!(:requester) do
    User.create!(
      email: "requester@tamu.edu",
      password: "password123",
      password_confirmation: "password123",
      first_name: "Requester",
      last_name: "User"
    )
  end

  let!(:company_verification) do
    poster.company_verifications.create!(
      company_name: "Tech Corp",
      company_email: "poster@techcorp.com",
      is_verified: true
    )
  end

  let!(:referral_post) do
    poster.referral_posts.create!(
      title: "Software Engineer",
      job_title: "Engineer",
      company_name: "Tech Corp",
      company_verification: company_verification,
      status: :active,
      questions: [ "Why do you want this job?", "What's your experience?" ]
    )
  end

  before do
    # Login as requester
    post session_path, params: { user: { email: requester.email, password: "password123" } }
  end

  describe "POST /referral_posts/:referral_post_id/referral_requests" do
    it "creates a request successfully" do
      expect {
        post referral_post_referral_requests_path(referral_post), params: {
          submitted_data: { "answer1" => "I love coding", "answer2" => "5 years" }
        }
      }.to change(ReferralRequest, :count).by(1)

      expect(response).to redirect_to(referral_post_path(referral_post))
      follow_redirect!
      expect(flash[:notice]).to eq("Request sent!")
    end

    it "creates request with JSON string submitted_data" do
      json_data = JSON.generate({ "q1" => "answer1", "q2" => "answer2" })

      post referral_post_referral_requests_path(referral_post), params: {
        submitted_data: json_data
      }

      request = ReferralRequest.last
      expect(request.submitted_data).to be_a(Hash)
      expect(request.submitted_data["q1"]).to eq("answer1")
    end

    it "creates request with hash submitted_data" do
      post referral_post_referral_requests_path(referral_post), params: {
        submitted_data: { "question1" => "answer1" }
      }

      request = ReferralRequest.last
      expect(request.submitted_data["question1"]).to eq("answer1")
    end

    it "prevents applying to closed posts" do
      referral_post.update!(status: :closed)

      expect {
        post referral_post_referral_requests_path(referral_post)
      }.not_to change(ReferralRequest, :count)

      expect(response).to redirect_to(referral_post_path(referral_post))
      follow_redirect!
      expect(flash[:alert]).to eq("This post is closed and no longer accepting requests.")
    end

    it "handles request save failure" do
      # Create duplicate request first
      referral_post.referral_requests.create!(user: requester, status: :pending)

      expect {
        post referral_post_referral_requests_path(referral_post)
      }.not_to change(ReferralRequest, :count)

      expect(response).to redirect_to(referral_post_path(referral_post))
      follow_redirect!
      expect(flash[:alert]).to eq("Failed to send request.")
    end
  end

  describe "PATCH /referral_posts/:referral_post_id/referral_requests/:id" do
    let!(:referral_request) do
      referral_post.referral_requests.create!(
        user: requester,
        status: :pending,
        submitted_data: { "answer" => "original answer" }
      )
    end

    it "updates a request successfully with hash submitted_data" do
      new_data = { "answer1" => "Updated answer 1", "answer2" => "Updated answer 2" }

      patch referral_post_referral_request_path(referral_post, referral_request), params: {
        submitted_data: new_data
      }

      expect(response).to redirect_to(referral_post_path(referral_post))
      follow_redirect!
      expect(flash[:notice]).to eq("Edit saved!")

      referral_request.reload
      expect(referral_request.submitted_data["answer1"]).to eq("Updated answer 1")
      expect(referral_request.submitted_data["answer2"]).to eq("Updated answer 2")
    end

    it "updates a request successfully with JSON string submitted_data" do
      json_data = JSON.generate({ "q1" => "updated answer 1", "q2" => "updated answer 2" })

      patch referral_post_referral_request_path(referral_post, referral_request), params: {
        submitted_data: json_data
      }

      expect(response).to redirect_to(referral_post_path(referral_post))
      follow_redirect!
      expect(flash[:notice]).to eq("Edit saved!")

      referral_request.reload
      expect(referral_request.submitted_data).to be_a(Hash)
      expect(referral_request.submitted_data["q1"]).to eq("updated answer 1")
      expect(referral_request.submitted_data["q2"]).to eq("updated answer 2")
    end

    it "updates a request successfully with nested params format" do
      new_data = { "question1" => "updated answer 1" }

      patch referral_post_referral_request_path(referral_post, referral_request), params: {
        referral_request: {
          submitted_data: new_data
        }
      }

      expect(response).to redirect_to(referral_post_path(referral_post))
      follow_redirect!
      expect(flash[:notice]).to eq("Edit saved!")

      referral_request.reload
      expect(referral_request.submitted_data["question1"]).to eq("updated answer 1")
    end

    it "prevents updating requests on closed posts" do
      referral_post.update!(status: :closed)

      patch referral_post_referral_request_path(referral_post, referral_request), params: {
        submitted_data: { "answer" => "new answer" }
      }

      expect(response).to redirect_to(referral_post_path(referral_post))
      follow_redirect!
      expect(flash[:alert]).to eq("This post is closed and no longer accepting requests.")

      referral_request.reload
      expect(referral_request.submitted_data["answer"]).to eq("original answer")
    end

    it "normalizes array as answers when updating" do
      array_data = JSON.generate([ "answer1", "answer2" ])

      patch referral_post_referral_request_path(referral_post, referral_request), params: {
        submitted_data: array_data
      }

      referral_request.reload
      expect(referral_request.submitted_data["answers"]).to be_present
    end

    it "normalizes invalid JSON string as answer when updating" do
      invalid_json = "not valid json but still a string"

      patch referral_post_referral_request_path(referral_post, referral_request), params: {
        submitted_data: invalid_json
      }

      referral_request.reload
      expect(referral_request.submitted_data).to be_a(Hash)
      expect(referral_request.submitted_data["answer"]).to eq(invalid_json)
    end

    it "handles nil submitted_data by setting empty hash" do
      patch referral_post_referral_request_path(referral_post, referral_request), params: {}

      referral_request.reload
      expect(referral_request.submitted_data).to eq({})
    end

    it "normalizes ActionController::Parameters when updating" do
      params_data = { "key" => "value" }

      patch referral_post_referral_request_path(referral_post, referral_request), params: {
        submitted_data: params_data
      }

      referral_request.reload
      expect(referral_request.submitted_data["key"]).to eq("value")
    end

    it "handles numeric string values when updating" do
      patch referral_post_referral_request_path(referral_post, referral_request), params: {
        submitted_data: "12345"
      }

      referral_request.reload
      expect(referral_request.submitted_data).to be_a(Hash)
      # "12345" parses as JSON number, so it gets wrapped in answers key
      expect(referral_request.submitted_data["answers"]).to eq(12345)
    end

    it "allows requester to update their own request" do
      # Already logged in as requester from before block
      new_data = { "updated" => "data" }

      patch referral_post_referral_request_path(referral_post, referral_request), params: {
        submitted_data: new_data
      }

      expect(response).to redirect_to(referral_post_path(referral_post))
      referral_request.reload
      expect(referral_request.submitted_data["updated"]).to eq("data")
    end
  end

  describe "PATCH /referral_requests/:id/status" do
    let!(:referral_request) do
      referral_post.referral_requests.create!(
        user: requester,
        status: :pending,
        submitted_data: { "answer" => "test" }
      )
    end

    before do
      # Login as poster (post owner)
      delete session_path
      post session_path, params: { user: { email: poster.email, password: "password123" } }
    end

    it "updates status to approved" do
      patch update_referral_request_status_path(referral_request), params: {
        status: "approved"
      }

      referral_request.reload
      expect(referral_request.status).to eq("approved")
      expect(response).to redirect_to(dashboard_path)
      follow_redirect!
      expect(flash[:notice]).to eq("Request status updated.")
    end

    it "closes post when request is approved" do
      expect(referral_post.status).to eq("active")

      patch update_referral_request_status_path(referral_request), params: {
        status: "approved"
      }

      referral_post.reload
      expect(referral_post.status).to eq("closed")
    end

    it "creates conversation when request is approved" do
      expect {
        patch update_referral_request_status_path(referral_request), params: {
          status: "approved"
        }
      }.to change(Conversation, :count).by(1)
        .and change(Message, :count).by(1)

      conversation = Conversation.last
      expect(conversation.sender).to eq(poster)
      expect(conversation.recipient).to eq(requester)

      message = conversation.messages.last
      expect(message.body).to include("approved")
    end

    it "updates status to rejected" do
      patch update_referral_request_status_path(referral_request), params: {
        status: "rejected"
      }

      referral_request.reload
      expect(referral_request.status).to eq("rejected")
    end

    it "updates status to pending" do
      referral_request.update!(status: :approved)

      patch update_referral_request_status_path(referral_request), params: {
        status: "pending"
      }

      referral_request.reload
      expect(referral_request.status).to eq("pending")
    end

    it "updates status to withdrawn" do
      patch update_referral_request_status_path(referral_request), params: {
        status: "withdrawn"
      }

      referral_request.reload
      expect(referral_request.status).to eq("withdrawn")
    end

    it "prevents unauthorized status update" do
      # Login as requester (not post owner)
      delete session_path
      post session_path, params: { user: { email: requester.email, password: "password123" } }

      patch update_referral_request_status_path(referral_request), params: {
        status: "approved"
      }

      expect(response).to have_http_status(:forbidden)
    end

    it "rejects invalid status" do
      patch update_referral_request_status_path(referral_request), params: {
        status: "invalid_status"
      }

      expect(response).to redirect_to(dashboard_path)
      follow_redirect!
      expect(flash[:alert]).to eq("Invalid status")
    end

    it "handles update failure gracefully" do
      allow_any_instance_of(ReferralRequest).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(referral_request))

      patch update_referral_request_status_path(referral_request), params: {
        status: "approved"
      }

      expect(response).to redirect_to(dashboard_path)
      follow_redirect!
      expect(flash[:alert]).to include("Failed to update status")
    end
  end

describe "POST /referral_posts/:referral_post_id/referral_requests/from_message" do
    it "creates request from message system" do
      expect {
        post "/referral_posts/#{referral_post.id}/referral_requests/from_message", params: {
          submitted_data: { "message" => "Interested in this role" }
        }
      }.to change(ReferralRequest, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["success"]).to eq(true)
      expect(json["redirect_to"]).to eq(dashboard_path)
    end

    it "handles invalid JSON in submitted_data" do
      post "/referral_posts/#{referral_post.id}/referral_requests/from_message", params: {
        submitted_data: "not valid json but still a string"
      }

      request = ReferralRequest.last
      expect(request.submitted_data).to be_a(Hash)
    end

    it "returns error on save failure" do
      # Create duplicate to trigger uniqueness validation
      referral_post.referral_requests.create!(user: requester, status: :pending)

      post "/referral_posts/#{referral_post.id}/referral_requests/from_message", params: {
        submitted_data: { "data" => "test" }
      }

      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json["success"]).to eq(false)
      expect(json["errors"]).to be_present
    end

    it "normalizes ActionController::Parameters" do
      params_data = { "key" => "value" }

      post "/referral_posts/#{referral_post.id}/referral_requests/from_message", params: {
        submitted_data: params_data
      }

      request = ReferralRequest.last
      expect(request.submitted_data["key"]).to eq("value")
    end

    it "normalizes array as answers" do
      post "/referral_posts/#{referral_post.id}/referral_requests/from_message", params: {
        submitted_data: JSON.generate([ "answer1", "answer2" ])
      }

      request = ReferralRequest.last
      expect(request.submitted_data["answers"]).to be_present
    end

    it "handles nil submitted_data" do
      post "/referral_posts/#{referral_post.id}/referral_requests/from_message"

      request = ReferralRequest.last
      expect(request.submitted_data).to eq({})
    end

    it "handles non-string, non-hash values" do
      post "/referral_posts/#{referral_post.id}/referral_requests/from_message", params: {
        submitted_data: "12345"
      }

      request = ReferralRequest.last
      expect(request.submitted_data).to be_a(Hash)
    end
  end
end
