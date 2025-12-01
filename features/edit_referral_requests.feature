Feature: Edit Referral Request
  As a user who has requested a referral
  I want to edit my referral request
  So that I can update my submitted information

  Background:
    Given I am logged in
    And I have a verified company "Tech Corp"

  Scenario: User successfully updates their referral request
    Given there is a referral post for "Tech Corp"
    And I have requested the referral for this post
    When I visit the referral post page
    And I update my referral request with new answers
    Then my referral request should be updated with the new answers

  Scenario: User cannot update request on closed post
    Given there is a referral post for "Tech Corp"
    And I have requested the referral for this post
    And the referral post is closed
    When I try to update my referral request
    Then my referral request should not be updated

  Scenario: User updates referral request with hash submitted_data
    Given there is a referral post for "Tech Corp"
    And I have requested the referral for this post
    When I update my referral request with hash submitted_data
    Then my referral request submitted_data should contain the hash values

  Scenario: User updates referral request with JSON string submitted_data
    Given there is a referral post for "Tech Corp"
    And I have requested the referral for this post
    When I update my referral request with JSON string submitted_data
    Then my referral request submitted_data should be normalized from JSON

  Scenario: User updates referral request with nested params format
    Given there is a referral post for "Tech Corp"
    And I have requested the referral for this post
    When I update my referral request with nested params submitted_data
    Then my referral request submitted_data should contain the nested values

  Scenario: User updates referral request with empty submitted_data
    Given there is a referral post for "Tech Corp"
    And I have requested the referral for this post
    When I update my referral request with empty submitted_data
    Then my referral request submitted_data should be an empty hash

  Scenario: User updates referral request with invalid JSON string
    Given there is a referral post for "Tech Corp"
    And I have requested the referral for this post
    When I update my referral request with invalid JSON submitted_data
    Then my referral request submitted_data should normalize the invalid JSON as answer

