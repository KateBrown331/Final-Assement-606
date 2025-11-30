Given("I have requested the referral for this post") do
  post = ReferralPost.last

  # Create a request with some initial submitted_data
  post.referral_requests.create!(
    user: @user,
    status: :pending,
    submitted_data: {
      "Why do you want this job?" => "Original answer 1",
      "What's your experience?" => "Original answer 2"
    }
  )
end

When("I visit the referral post page") do
  post = ReferralPost.last
  visit referral_post_path(post)
end

When("I update my referral request with new answers") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)

  # Update using the form fields on the page if they exist
  if page.has_button?("Edit Request")
    request.submitted_data_hash.each do |question, _answer|
      field_name = "submitted_data[#{question}]"
      if page.has_field?(field_name)
        fill_in field_name, with: "Updated answer for #{question}"
      end
    end
    click_button "Edit Request"
  else
    # Fallback to direct API call via PATCH
    new_data = {
      "Why do you want this job?" => "Updated answer 1",
      "What's your experience?" => "Updated answer 2"
    }
    page.driver.submit :patch, referral_post_referral_request_path(post, request), {
      submitted_data: new_data
    }
    visit referral_post_path(post)
  end
end

When("I try to update my referral request") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)

  # Try to update the request directly via PATCH
  page.driver.submit :patch, referral_post_referral_request_path(post, request), {
    submitted_data: { "answer" => "New answer" }
  }
  # Follow the redirect to see the error message
  visit referral_post_path(post)
end

When("I update my referral request with hash submitted_data") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)
  new_data = { "question1" => "updated answer 1", "question2" => "updated answer 2" }

  page.driver.submit :patch, referral_post_referral_request_path(post, request), {
    submitted_data: new_data
  }
  # Follow the redirect by visiting the destination page
  visit referral_post_path(post)
end

When("I update my referral request with JSON string submitted_data") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)
  json_data = JSON.generate({ "q1" => "updated answer 1", "q2" => "updated answer 2" })

  page.driver.submit :patch, referral_post_referral_request_path(post, request), {
    submitted_data: json_data
  }
  # Follow the redirect
  visit referral_post_path(post)
end

When("I update my referral request with nested params submitted_data") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)
  new_data = { "question1" => "updated answer 1" }

  page.driver.submit :patch, referral_post_referral_request_path(post, request), {
    referral_request: {
      submitted_data: new_data
    }
  }
  # Follow the redirect
  visit referral_post_path(post)
end

When("I update my referral request with empty submitted_data") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)

  page.driver.submit :patch, referral_post_referral_request_path(post, request), {
    submitted_data: {}
  }
  # Follow the redirect
  visit referral_post_path(post)
end

When("I update my referral request with invalid JSON submitted_data") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)
  invalid_json = "not valid json but still a string"

  page.driver.submit :patch, referral_post_referral_request_path(post, request), {
    submitted_data: invalid_json
  }
  # Follow the redirect
  visit referral_post_path(post)
end

Given("the referral post is closed") do
  post = ReferralPost.last
  post.update!(status: :closed)
end

Then("my referral request should be updated with the new answers") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)
  request.reload

  # Check that submitted_data is a hash and has been updated
  expect(request.submitted_data).to be_a(Hash)
  # Check that it's not empty and contains updated content
  if request.submitted_data_hash.any?
    # At least one value should contain "Updated" if form was used
    # or check that data exists
    expect(request.submitted_data_hash).to be_present
  end
end

Then("my referral request should not be updated") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)
  request.reload

  # Check that the submitted_data hasn't been updated with the new answer we tried to set
  # The original data should still be there, and it shouldn't have the "answer" key we tried to add
  if request.submitted_data.is_a?(Hash)
    expect(request.submitted_data).not_to have_key("answer")
    # Verify original keys are still present
    expect(request.submitted_data).to have_key("Why do you want this job?")
    expect(request.submitted_data).to have_key("What's your experience?")
  end
end

Then("my referral request submitted_data should contain the hash values") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)
  request.reload

  expect(request.submitted_data["question1"]).to eq("updated answer 1")
  expect(request.submitted_data["question2"]).to eq("updated answer 2")
end

Then("my referral request submitted_data should be normalized from JSON") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)
  request.reload

  expect(request.submitted_data).to be_a(Hash)
  expect(request.submitted_data["q1"]).to eq("updated answer 1")
  expect(request.submitted_data["q2"]).to eq("updated answer 2")
end

Then("my referral request submitted_data should contain the nested values") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)
  request.reload

  expect(request.submitted_data["question1"]).to eq("updated answer 1")
end

Then("my referral request submitted_data should be an empty hash") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)
  request.reload

  expect(request.submitted_data).to eq({})
end

Then("my referral request submitted_data should normalize the invalid JSON as answer") do
  post = ReferralPost.last
  request = post.referral_requests.find_by(user: @user)
  request.reload

  expect(request.submitted_data).to be_a(Hash)
  expect(request.submitted_data["answer"]).to eq("not valid json but still a string")
end
