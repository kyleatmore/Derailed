require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = req.params.merge(route_params)
  end

  def already_built_response?
    !!@already_built_response
  end

  def redirect_to(url)
    raise "Double Render Error" if @already_built_response
    res['Location'] = url
    res.status = 302
    @already_built_response = true
    session.store_session(res)
    flash.store_flash(res)
  end

  def render_content(content, content_type)
    raise "Double Render Error" if @already_built_response
    res['Content-Type'] = content_type
    res.write(content)
    @already_built_response = true
    session.store_session(res)
    flash.store_flash(res)
  end

  def render(template_name)
    template_file_path = "views/#{self.class.name.underscore}/#{template_name}.html.erb"
    template_file = File.read(template_file_path)
    template = ERB.new(template_file).result(binding)
    render_content(template, "text/html")
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end
end
