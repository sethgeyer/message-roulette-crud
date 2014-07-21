require "rspec"
require "capybara"

feature "Messages" do

  scenario "As a user, I can submit a message" do
    visit "/"
    expect(page).to have_content("Message Roullete")
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    expect(page).to have_content("Hello Everyone!")
    expect(page).to have_link("Edit")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"
    fill_in "Message", :with => "a" * 141
    click_button "Submit"
    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "As a user, I can update a message" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    click_on "Edit"
    expect(page).to have_content("Edit Message")
    expect(page.find("#message")).to have_content("Hello Everyone!")
    fill_in "Message", with: "Hello World"
    click_on "Submit"
    expect(page).to have_content("Hello World")
    expect(page).to have_link("Edit")
  end

  scenario "As a user, I see an error message for messages > 140 chars" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    click_on "Edit"
    expect(page).to have_content("Edit Message")
    expect(page.find("#message")).to have_content("Hello Everyone!")
    fill_in "Message", with: "a" * 141
    click_on "Submit"
    expect(page).to have_content("Message must be less than 140 characters.")
    expect(page).to have_content("Edit Message")
  end


  scenario "As a user, I can delete a message" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    click_on "Delete"
    expect(page).not_to have_content("Hello Everyone")
  end

  scenario "As a user, I can add a comment" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    click_on "Comment"
    expect(page).to have_content("Add a Comment")
    fill_in "Comment", with: "Good idea!"
    click_on "Add Comment"
    expect(page).to have_content("Good idea")
  end


  # As a user
  # When I click "Comment" next to a message
  # And I fill in "Comment" with "Good idea!"
  # And I click Add Comment
  # Then I should see my comment below the message I commented on


end
