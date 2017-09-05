require 'rack'

class Static
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)

    if req.path =~ Regexp.new("^/public/*")
      serve_file(req)
    else
      app.call(env)
    end
  end

  private
  def serve_file(req)
    res = Rack::Response.new
    res['Content-Type'] = 'MIME-Version: 1.0'

    file_path = req.path[1..-1]
    if File.exist?(file_path)
      res.write(File.read(req.path[1..-1]))
    else
      res.status = "404"
      res.write("File not found")
    end

    res.finish
  end
end
