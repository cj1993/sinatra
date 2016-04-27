require "sqlite3"

class Database
  def initialize(database_name, table_name)
    @database = SQLite3::Database.new("#{database_name}")
    @table_name = table_name
  end

  def create_table
    @database.execute("create table #{@table_name} (
                      username varchar(30),
                      password varchar(30),
                      email varchar(50));")
  end

  def drop_table
    @database.execute("drop table #{@table_name};")
  end

  def table_exists?
    !@database.execute("select name from sqlite_master where
                      type='table' and
                      name='#{@table_name}';").empty?
  end

  def populate(user)
    user.tap { |data| @database.execute("insert into #{@table_name} values (?,?,?);", data) }
  end

  def get_result_set
    @database.execute("select * from #{@table_name};")
  end

  def clear_table
    @database.execute("delete from #{@table_name};")
  end

  def valid_user?(username, password)
    get_result_set.each { |entry|
      return true if username == entry[0] && password == entry[1]
    }
    false
  end

  def details_exist?(params)
    has_username?(params["username"]) || has_email?(params["email"])
  end

  private

  def has_username?(username)
    get_result_set.each { |entry| return true if entry.first == username }
    false
  end

  def has_email?(email)
    get_result_set.each { |entry| return true if entry.last == email }
    false
  end
end
