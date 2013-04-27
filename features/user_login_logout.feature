Feature: User login/logout

    Scenario: User can login
        Given I have just created a user
        And I go to the login page
        When I fill in "Email" with "dirtysweetlovin@example.com"
        And I fill in "Password" with "as12AS!@"
        And I press "Log In"
        Then I should see the text "Logged in!"
        And I should be on the home page

    Scenario: User can logout
        Given I am logged in
        When I go to the logout page
        Then I should see the text "Logged out!"

    Scenario: User does not see the full menu before logging in
        Given I am logged out
        When I go to the home page
        Then I should not see a "Certificates" link
        And I should not see a "Profile" link

    Scenario: User does not see the full menu before logging in
        Given I am logged in
        When I go to the home page
        Then I should see a "Certificates" link
        And I should see a "Profile" link
