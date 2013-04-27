Feature: Editing a user profile

    Scenario: User must login to edit their profile
        Given I have just created a user
        And I am logged out
        When I go to the user page for "sweetlovin"
        Then I should see the text "You are not authorized to access this page."

    Scenario: User can edit their profile after logging in
        Given I have just created a user
        When I follow "Profile"
        And I follow "Edit"
        And I fill in "* Email" with "dirtiersweetlovin@example.com"
        And I fill in "* Password" with "as12AS!@"
        And I fill in "* Password confirmation" with "as12AS!@"
        And I press "Update User"
        Then I should see the text "User was successfully updated."
        And I should see the text "dirtiersweetlovin@example.com"
