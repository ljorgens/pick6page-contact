require 'sinatra'
require 'pony'
require 'dotenv'
Dotenv.load

before do
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Origin']  = '*'
    headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
end

# whitelist should be a space separated list of URLs
whitelist = ENV['whitelist'].split

set :protection, :origin_whitelist => whitelist

Pony.options = {
  :via => :smtp,
  :via_options => {
    :address => 'smtp.mailgun.org',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['MAILGUN_USERNAME'],
    :password => ENV['MAILGUN_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
}

get '/' do
  'you have reached the test!'
end

post '/' do
  email = ""
  params.each do |value|
    puts value
    email += "#{value[0]}: #{value[1]}\n"
  end
  puts email
  Pony.mail(
    :to => ENV['email_recipients'],
    :from => 'www.sqwadapp.co',
    :subject => 'Inbound From Website',
    :body => email
  )
end
