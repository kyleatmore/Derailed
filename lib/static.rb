require 'rack'

class Static
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new

    if req.path =~ Regexp.new("^/public/*")
      res.write(File.read(req.path[1..-1]))
      res['Content-Type'] = 'MIME-Version: 1.0'
      res.finish
    else
      app.call(env)
    end
  end
end
