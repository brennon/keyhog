def create_user
  visit signup_path
  fill_in "* Username", with: "sweetlovin"
  fill_in "* First name", with: "Sweet"
  fill_in "* Last name", with: "Lovin"
  fill_in "* Email", with: "dirtysweetlovin@example.com"
  fill_in "* Password", with: "as12AS!@"
  fill_in "* Password confirmation", with: "as12AS!@"
  click_button "Create User"
end

Given(/^I have just created a user$/) do
  create_user
end

Given(/^I am logged in$/) do
  create_user
  visit login_path
  fill_in "Email", with: "dirtysweetlovin@example.com"
  fill_in "Password", with: "as12AS!@"
  click_button "Log In"
end

Given(/^I am logged out$/) do
  visit logout_path
end

Then(/^I should not see a "(.*?)" link$/) do |link|
  assert page.has_no_link? link
end

Then(/^I should see a "(.*?)" link$/) do |link|
  assert page.has_link? link
end

When(/^I attempt to delete the account for "(.*?)"$/) do |username|
  user = User.find_by_username(username)
  page.driver.submit :delete, user_path(user), {}
end
