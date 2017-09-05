require 'erb'
require 'rack'
require 'byebug'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      app.call(env)
    rescue => e
      render_exception(e)
    end
  end

  private

  def render_exception(e)
    @error = e
    template_file = File.read("lib/templates/rescue.html.erb")
    template = ERB.new(template_file).result(binding)

    res = Rack::Response.new
    res['Content-Type'] = 'text/html'
    res.write(template)
    res.finish
  end

end
