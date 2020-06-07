# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "geocoder"                                                                    #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

# events_table = DB.from(:events)
# rsvps_table = DB.from(:rsvps)

# Home page
get "/" do
    # before stuff runs
    view "index"
end

#Sign up as a new user
get "/new_user" do
    # before stuff runs
    view "new_user"
end

#Sign up as a new customer form
get "/new_customer" do
    # before stuff runs
    view "new_customer"
end

#Sign up as a new doctor form
get "/new_doctor" do
    # before stuff runs
    view "new_doctor"
end

#Sign up as a new doctor form
post "/new_doctor/created" do
    puts params
    # before stuff runs
    view "new_doctor_created"
end
