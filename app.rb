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
    !session["username"].nil?
  end

  def username
    session["username"]
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
  session["username"] = nil

  redirect "/"
end

post "/register" do
  critera = @utils.same_password?(params["password"], params["confirm_password"]) &&
            !@database.has_username?(params["username"]) &&
            !@database.has_email?(params["email"])

  if critera
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
  session["username"] = nil

  redirect "/"
end
