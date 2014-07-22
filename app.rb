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
    comments = @database_connection.sql("SELECT * FROM comments")

    erb :home, locals: {messages: messages, comments: comments}
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
    message_to_edit = params[:message]
    if message_to_edit.length <= 140
      @database_connection.sql("UPDATE messages SET message='#{message_to_edit}' WHERE id=#{params[:id].to_i}")
      redirect "/"
    else
      flash[:error] = "Message must be less than 140 characters."
      erb :edit, locals: {message_to_edit: message_to_edit}
    end
  end

  delete "/messages/:id" do
    id = params[:id].to_i
    @database_connection.sql("DELETE FROM messages WHERE id=#{id}").first
    redirect "/"
  end

  #SHOW
  get "/messages/:id" do
    id = params[:id].to_i
    message = @database_connection.sql("SELECT * FROM messages WHERE id=#{id}").first
    comments = @database_connection.sql("SELECT * FROM comments WHERE message_id=#{id}")
    erb :show, locals: {message: message, comments: comments}
  end



  #NEW COMMENT
  get "/comments/new/:id" do
    message_id = params[:id].to_i
    erb :new_comment, locals: {message_id: message_id}
  end

  post "/comments" do
    begin
      @database_connection.sql("INSERT INTO comments (message_id, comment) VALUES (#{params[:message_id].to_i}, '#{params[:comment]}')")
      redirect "/"
    rescue
      erb :new_comment, locals: {message_id: params[:message_id]}
    end
  end


end