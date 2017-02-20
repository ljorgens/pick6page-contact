require 'dotenv'
Dotenv.load

require './mailer'
run Sinatra::Application