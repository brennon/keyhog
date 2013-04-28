Feature: New certificate pair creation

    Scenario: User can create a new RSA certificate pair
        Given I am logged in
        When I follow "Certificates"
        And I follow "Generate"
        And I select "RSA" from "Type"
        And I select "2048" from "Length"
        And I fill in "Comment" with "dn@stank"
        And I fill in "* Passphrase" with "dirtynasty"
        And I fill in "* Passphrase confirmation" with "dirtynasty"
        And I press "Generate Certificate Pair"
        Then the downloaded certificate should include "BEGIN RSA PRIVATE KEY"

    Scenario: User can create a new DSA certificate pair
        Given I am logged in
        When I follow "Certificates"
        And I follow "Generate"
        And I select "DSA" from "Type"
        And I select "1024" from "Length"
        And I fill in "Comment" with "dn@stank"
        And I fill in "* Passphrase" with "dirtynasty"
        And I fill in "* Passphrase confirmation" with "dirtynasty"
        And I press "Generate Certificate Pair"
        Then the downloaded certificate should include "BEGIN DSA PRIVATE KEY"

    Scenario: Generated certificates are added to user's certificates
        Given I am logged in
        When I follow "Certificates"
        And I follow "Generate"
        And I select "DSA" from "Type"
        And I select "1024" from "Length"
        And I fill in "Comment" with "dn@stank"
        And I fill in "* Passphrase" with "dirtynasty"
        And I fill in "* Passphrase confirmation" with "dirtynasty"
        And I press "Generate Certificate Pair"
        And I go to my certificates page
        Then I should see the text "dn@stank"
