require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
  enable :sessions
  set :sessions_secret, "secret"
end

before do
  session[:lists] ||= []
end

get "/" do
  redirect "/lists"
end

# View all the lists
get "/lists" do
  @lists = session[:lists]
  erb :lists, layout: :layout
end

# Render the new list form
get "/lists/new" do
  erb :new_list, layout: :layout
end

# Retun error message if list name is invalid. Return nil if list name is valid.
def error_message(name)
  if !(1..100).cover? name.size
    "List name must be between 1 and 100 characters."
  elsif session[:lists].any? {|list| list[:name] == name}
    "List name must be unique"
  end

end

# create a new lists
post "/lists" do
  list_name = params[:list_name].strip
  error = error_message(list_name)
  if error
    session[:error] = error
    erb :new_list
  else
    session[:lists] << {name: list_name, todos: []}
    session[:success] = "New list added sucessfully!"
    redirect "/lists"
  end
end
# set :session_secret, SecureRandom.hex(32)