require 'rack'
require 'pry-debugger'
require 'twitter'
require './configure'
require 'thin'

class HelloWorld

  def call env
    req = Rack::Request.new(env)
    res = Rack::Response.new 
    binding.pry if ARGV[0]
    res['Content-Type'] = 'text/html'
    #Si no esta vacio , no es un espacio y el usuario existe en Twitter el nombre es el introducido, si no se introduce unline91
    name = (req["firstname"] && req["firstname"] != ''&& Twitter.user?(req["firstname"]) == true) ? req["firstname"] :'unline91'
    ultimotweet = Twitter.user_timeline(name).first
    puts"#{ultimotweet.text}"
    res.write <<-"EOS"
      <!DOCTYPE HTML>
      <html>
        <title>Rack::Response</title>
        <body>
          <h1>
             <form action="/" method="post">
               Nombre del usuario de twitter: <input type="text" name="firstname" autofocus><br>
               <input type="submit" value="Submit">
             </form>
          </h1>
        </body>
      </html>
    EOS
    res.finish
  end
end

Rack::Server.start(
  :app => HelloWorld.new,
  :Port => 9292,
  :server => 'thin'
)
