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
end
