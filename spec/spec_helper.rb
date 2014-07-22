require_relative "./../app"
require "capybara/rspec"
require "gschool_database_connection"
ENV["RACK_ENV"] = "test"

Capybara.app = App


RSpec.configure do |config|
  config.before do
    database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])

    database_connection.sql("BEGIN")
  end

  config.after do
    database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])

    database_connection.sql("ROLLBACK")
  end
end


def create_a_valid_message(message)
  fill_in "Message", with: message
  click_button "Submit"
end

def create_an_invalid_message
  fill_in "Message", :with => "a" * 141
  click_button "Submit"
end

def create_a_comment(comment)
  click_on "Comment"
  fill_in "Comment", with: comment
  click_on "Add Comment"
end