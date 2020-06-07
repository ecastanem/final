# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :doctors do
  primary_key :id
  String :name
  String :a_paterno
  String :a_materno
  String :phone
  String :email
  String :password
  String :ced_lic
  String :ced_esp1
  String :ced_esp2
  String :direccion
  String :interior
  String :colonia
  String :estado
  String :zipcode
  Boolean :check_terminos
end

# Insert initial (seed) data
doctors_table = DB.from(:doctors)
doctors_table.insert(name: "Jesús Esteban",
                        a_paterno: "Castañeda",
                        a_materno: "Martínez",
                        phone: "55-37-23-31-09",
                        email: "ecastanem88@gmail.com",
                        password: BCrypt::Password.create("1234"),
                        ced_lic: "7364466",
                        ced_esp1: "9731652",
                        ced_esp2: "",
                        direccion: "General Pedro Hinojosa 39",
                        colonia: "Col. Daniel Garza",
                        estado: "Ciudad de México",
                        zipcode: "11830",
                        check_terminos: "on")




