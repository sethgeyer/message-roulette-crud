
describe Comments do

  let(:database_connection) { GschoolDatabaseConnection::DatabaseConnection.establish("test") }
  let(:messages) { Messages.new(database_connection) }

  describe "#show_all" do
    it "should return a hash of messages" do
      database_connection.sql("INSERT INTO messages (message) VALUES ('This is my message')")
      database_connection.sql("INSERT INTO messages (message) VALUES ('This is my message')")
      expect(messages.show_all.count.to_i).to eq(2)
    end
  end

  describe "#create_message" do
    it "should create a dbase record of the message" do
      messages.create_message("message")
      expect(database_connection.sql("SELECT COUNT(*) FROM messages").count).to eq(1)
    end
  end

  describe "#update_message" do
    it "should update the dbase record of the message" do
      database_connection.sql("INSERT INTO messages (message, id) VALUES ('This is my message', 22)")
      messages.update_message("This is my revised message", 22)
      expect(database_connection.sql("SELECT * FROM messages").first["message"]).to eq("This is my revised message")
    end
  end

  describe "#find_by_id" do
    it "should return the specified record" do
      database_connection.sql("INSERT INTO messages (message, id) VALUES ('This is my message', 22)")
      expect(messages.find_by_id(22)["message"]).to eq("This is my message")
    end
  end

  describe "#delete_by_id" do
    it "should delete the specified record" do
      database_connection.sql("INSERT INTO messages (message, id) VALUES ('This is my message', 22)")
      messages.delete_by_id(22)
      expect(messages.find_by_id(22)).to eq(nil)
    end
  end

  describe "#increment_like_count" do
    it "should update the dbase record of the message by 1 like" do
      database_connection.sql("INSERT INTO messages (like_count, id) VALUES (0, 22)")
      messages.increment_like_count(1, 5, 22)
      expect(database_connection.sql("SELECT * FROM messages").first["like_count"].to_i).to eq(6)
      messages.increment_like_count(-1, 5, 22)
      expect(database_connection.sql("SELECT * FROM messages").first["like_count"].to_i).to eq(4)
    end
  end






end