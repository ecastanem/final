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
doctors_table = DB.from(:doctors)

before do
    # SELECT * FROM users WHERE id = session[:user_id]
    @current_user = doctors_table.where(:id => session[:user_id]).to_a[0]
    puts @current_user.inspect
end

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
    email_entered = params["email"]
    user = doctors_table.where(:email => email_entered).to_a[0]
    #Validation of existing user.
    if user 
        view "new_doctor_fail"
    else
        doctors_table.insert(:name => params["name"],
                                :a_paterno => params["a_paterno"],
                                :a_materno => params["a_materno"],
                                :phone => params["phone"],
                                :email => params["email"],
                                :user_email => BCrypt::Password.create(params["email"]),
                                :password => BCrypt::Password.create(params["password"]),
                                :ced_lic => params["ced_lic"],
                                :ced_esp1 => params["ced_esp1"],
                                :ced_esp2 => params["ced_esp2"],
                                :direccion => params["direccion"],
                                :colonia => params["colonia"],
                                :estado => params["estado"],
                                :zipcode => params["zipcode"],
                                :check_terminos => params["check_terminos"])
        # before stuff runs
        view "new_doctor_created"
    end
end

# Form to login
get "/login" do
    view "user_login"
end

# Receiving end of login form
post "/login/create" do
    puts params
    email_entered = params["email"]
    password_entered = params["password"]
    # SELECT * FROM users WHERE email = email_entered
    user = doctors_table.where(:email => email_entered).to_a[0]
    if user
        puts user.inspect
        # test the password against the one in the users table
        if BCrypt::Password.new(user[:password]) == password_entered
            session[:user_id] = user[:id]
            view "login_create"
        else
            view "create_login_failed"
        end
    else 
        view "create_login_failed"
    end
end

# Logout
get "/logout" do
    session[:user_id] = nil
    view "logout"
end

#Show doctors Profil
get "/doctor_profile/:user_email" do
    puts params
    @direccion_completa = '"'+@current_user[:direccion]+", "+@current_user[:estado]+" "+@current_user[:zipcode]+'"'
    puts @direccion_completa
    results = Geocoder.search(@direccion_completa)
    @lat_long = results.first.coordinates.join(",")
    view "doctor_profile"
end  
