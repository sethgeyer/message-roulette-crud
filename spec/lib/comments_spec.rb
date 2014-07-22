
describe Comments do

  let(:database_connection) { GschoolDatabaseConnection::DatabaseConnection.establish("test") }
  let(:comments) { Comments.new(database_connection) }

  describe "#show_all" do
    it "should return a hash of messages" do
      database_connection.sql("INSERT INTO comments (comment) VALUES ('This is my 1st comment')")
      database_connection.sql("INSERT INTO comments (comment) VALUES ('This is my 2nd comment')")
      expect(comments.show_all.count.to_i).to eq(2)
    end
  end

  describe "#find_by_message_id" do
    it "should return the specified record" do
      database_connection.sql("INSERT INTO comments (comment, message_id) VALUES ('This is my comment', 22)")
      expect(comments.find_by_message_id(22).first["comment"]).to eq("This is my comment")
    end
  end

  describe "#create_comment" do
    it "should create a dbase record of the comment" do
      comments.create_comment(5, "this is my comment")
      expect(database_connection.sql("SELECT COUNT(*) FROM comments").count).to eq(1)
    end
  end



end