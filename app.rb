require "sinatra"
require_relative "lib/database"
require_relative "lib/utils"

enable :sessions

before do
  @database ||= Database.new("sinatra", "user")
  # @database.drop_table if @database.table_exists?
  @database.create_table unless @database.table_exists?
  @utils ||= Utils.new
end

helpers do
  def logged_in?
    !!session["username"]
  end

  def username
    session["username"]
  end

  def expire_session
    session["username"] = nil
    redirect "/"
  end
end

get "/" do
  erb :home
end

get "/error" do
  erb :error
end

get "/register" do
  erb :register
end

get "/users" do
  @users = @database.get_result_set
  erb :users
end

get "/logout" do
  expire_session
end

post "/register" do
  if @utils.details_valid?(params) && !@database.details_exist?(params)
    user_details = params.reject { |param| param =~ /_/ }.values
    @database.populate(user_details)
    redirect "/"
  end

  erb :error
end

post "/login" do
  if @database.valid_user?(params["username"], params["password"])
    session["username"] = params["username"]
    redirect "/"
  end

  erb :error
end

post "/users" do
  @database.clear_table
  expire_session
end
