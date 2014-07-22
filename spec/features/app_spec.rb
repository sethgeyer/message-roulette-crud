require "rspec"
require "capybara"

feature "Messages" do
  before(:each) do
    visit "/"
  end

  scenario "As a user, I can submit a message" do
    expect(page).to have_content("Message Roullete")
    create_a_valid_message("Hello Everyone!")
    expect(page).to have_content("Hello Everyone!")
    expect(page).to have_link("Edit")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    create_an_invalid_message
    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "As a user, I can update a message" do
    create_a_valid_message("Hello Everyone!")
    click_on "Edit"
    expect(page).to have_content("Edit Message")
    expect(page.find("#message")).to have_content("Hello Everyone!")
    create_a_valid_message("Hello World")
    expect(page).to have_content("Hello World")
    expect(page).to have_link("Edit")
  end

  scenario "As a user, I see an error message for messages > 140 chars" do
    create_a_valid_message("Hello Everyone!")
    click_on "Edit"
    expect(page).to have_content("Edit Message")
    expect(page.find("#message")).to have_content("Hello Everyone!")
    create_an_invalid_message
    expect(page).to have_content("Message must be less than 140 characters.")
    expect(page).to have_content("Edit Message")
  end


  scenario "As a user, I can delete a message" do
    create_a_valid_message("Hello Everyone!")
    click_on "Delete"
    expect(page).not_to have_content("Hello Everyone")
  end

  scenario "As a user, I can add a comment" do
    create_a_valid_message("Hello Everyone!")
    create_a_comment("Good idea!")
    expect(page).to have_content("Good idea")
  end

  scenario "As a user, I can see/goto the individual message page" do
    create_a_valid_message("Hello Everyone!")
    create_a_comment("Good idea!")
    click_on "Hello Everyone!"
    expect(page).to have_content("Show Page")
    expect(page).to have_content("Good idea!")
    expect(page).not_to have_content("Edit Message")
  end

  scenario "As a user, I can like a message" do
    create_a_valid_message("Hello Everyone!")
    expect(page).to have_content("0 Likes")
    expect(page).to have_button("Like")
    click_on "Like"
    expect(page).to have_content("1 Like")
    click_on "Like"
    expect(page).to have_content("2 Likes")
  end

  scenario "As a user, I can dilike a message" do
    create_a_valid_message("Hello Everyone!")
    expect(page).to have_content("0 Likes")
    expect(page).to have_button("Like")
    click_on "Like"
    expect(page).to have_content("1 Like")
    click_on "Like"
    expect(page).to have_content("2 Likes")
  end


end
