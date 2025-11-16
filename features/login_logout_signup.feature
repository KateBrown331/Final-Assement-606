Feature: User Authentication
  As a visitor or registered user
  I want to be able to sign up, log in, and log out
  So that I can use the application securely

  Scenario: User signs up
    Given I am on the signup page
    When I fill in valid signup information
    And I submit the form
    Then I should see a welcome message

  Scenario: User logs in
    Given I have an account
    And I am on the login page
    When I fill in valid login credentials
    And I submit the form
    Then I should see my profile page

  Scenario: User logs out
    Given I am logged in
    When I click logout
    Then I should see the homepage
