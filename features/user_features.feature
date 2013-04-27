Feature: User signup

    Scenario: User can browse to the sign up page
        Given I go to the home page
        When I follow "Sign Up"
        Then I should see the text "Username"
        And I should see the text "First name"
        And I should see the text "Last name"
        And I should see the text "Password"
        And I should see the text "Password confirmation"
