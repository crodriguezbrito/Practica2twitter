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

    name = (req["firstname"] && req["firstname"] != ''&& Twitter.user?(req["firstname"]) )? req["firstname"] :''
    if (name == req["firstname"])
		ultimotweet = Twitter.user_timeline(name).first
		tweet = ultimotweet.text
    end
    
    res.write <<-"EOS"
      <!DOCTYPE HTML>
      <html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		</head>
        <title>Rack::Response</title>
        <body>
          <h1>
             <form action="/" method="post">
               Nombre del usuario de twitter: <input type="text" name="firstname" autofocus><br>
               <input type="submit" value="Submit">
             </form>
          </h1>
          <h3>
			USUARIO: #{name}
		  </h3>
			<br>
		  <h3>	
			Tweet : <p>#{tweet}</p>
			    
		   </h3>    
                            
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
