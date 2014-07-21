require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    messages = @database_connection.sql("SELECT * FROM messages")

    erb :home, locals: {messages: messages}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get "/messages/:id/edit" do
    id = params[:id].to_i
    message_to_edit = @database_connection.sql("SELECT * from messages WHERE id=#{id}").first
    erb :edit, locals: {message_to_edit: message_to_edit}
  end

  patch "/messages/:id" do
    @database_connection.sql("UPDATE messages SET message='#{params[:message]}' WHERE id=#{params[:id].to_i}")
    redirect "/"
  end

end