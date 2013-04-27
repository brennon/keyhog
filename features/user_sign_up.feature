Feature: User sign up

    Scenario: User can browse to the sign up page
        Given I go to the home page
        When I follow "Sign Up"
        Then I should see the text "Username"
        And I should see the text "First name"
        And I should see the text "Last name"
        And I should see the text "Email"
        And I should see the text "Password"
        And I should see the text "Password confirmation"

    Scenario: User can complete the sign up form with good parameters
        Given I go to the sign up page
        When I fill in "* Username" with "sweetlovin"
        And I fill in "* First name" with "Sweet"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Email" with "sweetnastylovin@example.com"
        And I fill in "* Password" with "as12AS!@"
        And I fill in "* Password confirmation" with "as12AS!@"
        And I press "Create User"
        Then I should see the text "User was successfully created."

    Scenario: User needs a username to complete the sign up form
        Given I go to the sign up page
        When I fill in "* First name" with "Sweet"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Email" with "sweetnastylovin@example.com"
        And I fill in "* Password" with "as12AS!@"
        And I fill in "* Password confirmation" with "as12AS!@"
        And I press "Create User"
        Then I should see the text "can't be blank"

    Scenario: User needs a first name to complete the sign up form
        Given I go to the sign up page
        When I fill in "* Username" with "sweetlovin"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Email" with "sweetnastylovin@example.com"
        And I fill in "* Password" with "as12AS!@"
        And I fill in "* Password confirmation" with "as12AS!@"
        And I press "Create User"
        Then I should see the text "can't be blank"

    Scenario: User needs a last name to complete the sign up form
        Given I go to the sign up page
        When I fill in "* Username" with "sweetlovin"
        And I fill in "* First name" with "Sweet"
        And I fill in "* Email" with "sweetnastylovin@example.com"
        And I fill in "* Password" with "as12AS!@"
        And I fill in "* Password confirmation" with "as12AS!@"
        And I press "Create User"
        Then I should see the text "can't be blank"

    Scenario: User needs an email to complete the sign up form
        Given I go to the sign up page
        When I fill in "* Username" with "sweetlovin"
        And I fill in "* First name" with "Sweet"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Password" with "as12AS!@"
        And I fill in "* Password confirmation" with "as12AS!@"
        And I press "Create User"
        Then I should see the text "can't be blank"

    Scenario: User needs a password to complete the sign up form
        Given I go to the sign up page
        When I fill in "* Username" with "sweetlovin"
        And I fill in "* First name" with "Sweet"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Password confirmation" with "as12AS!@"
        And I press "Create User"
        Then I should see the text "can't be blank"

    Scenario: User needs a password confirmation to complete the sign up form
        Given I go to the sign up page
        When I fill in "* Username" with "sweetlovin"
        And I fill in "* First name" with "Sweet"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Password" with "as12AS!@"
        And I press "Create User"
        Then I should see the text "can't be blank"

    Scenario: User needs a password with two uppercase letters
        Given I go to the sign up page
        When I fill in "* Username" with "sweetlovin"
        And I fill in "* First name" with "Sweet"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Email" with "sweetnastylovin@example.com"
        And I fill in "* Password" with "As12as!@"
        And I fill in "* Password confirmation" with "As12as!@"
        And I press "Create User"
        Then I should see the text "two uppercase letters"

    Scenario: User needs a password with two lowercase letters
        Given I go to the sign up page
        When I fill in "* Username" with "sweetlovin"
        And I fill in "* First name" with "Sweet"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Email" with "sweetnastylovin@example.com"
        And I fill in "* Password" with "aS12AS!@"
        And I fill in "* Password confirmation" with "aS12AS!@"
        And I press "Create User"
        Then I should see the text "two lowercase letters"

    Scenario: User needs a password with two special characters
        Given I go to the sign up page
        When I fill in "* Username" with "sweetlovin"
        And I fill in "* First name" with "Sweet"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Email" with "sweetnastylovin@example.com"
        And I fill in "* Password" with "as12AS1@"
        And I fill in "* Password confirmation" with "as12AS1@"
        And I press "Create User"
        Then I should see the text "two special characters"

    Scenario: User needs a password with two numbers
        Given I go to the sign up page
        When I fill in "* Username" with "sweetlovin"
        And I fill in "* First name" with "Sweet"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Email" with "sweetnastylovin@example.com"
        And I fill in "* Password" with "as1@AS!@"
        And I fill in "* Password confirmation" with "as1@AS!@"
        And I press "Create User"
        Then I should see the text "two numbers"

    Scenario: User needs a password with a matching password confirmation
        Given I go to the sign up page
        When I fill in "* Username" with "sweetlovin"
        And I fill in "* First name" with "Sweet"
        And I fill in "* Last name" with "Lovin"
        And I fill in "* Email" with "sweetnastylovin@example.com"
        And I fill in "* Password" with "as12AS!@"
        And I fill in "* Password confirmation" with "as12AS!2"
        And I press "Create User"
        Then I should see the text "doesn't match confirmation"

    Scenario: User can't see a back button after signing up
        Given I have just created a user
        Then I should not see a "Back" link
