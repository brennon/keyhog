Feature: New certificate pair creation

    Scenario: User can create a new RSA certificate pair
        Given I am logged in
        When I follow "Certificates"
        And I follow "Generate"
        And I select "RSA" from "Type"
        And I select "2048" from "Length"
        And I fill in "Passphrase" with "dirtynasty"
        And I fill in "Passphrase confirmation" with "dirtynasty"
        And I press "Generate Certificate Pair"
        Then I should see the text "Download Private Key"

    Scenario: User can create a new DSA certificate pair
        Given pending
    Scenario: User can download a new certificate pair
        Given pending
    Scenario: User can add a new public certificate to their certificates
        Given pending
    Scenario: User can only download their new private key once
        Given pending
