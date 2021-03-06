require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params, :protect_from_forgery, :auth_token

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = req.params.merge(route_params)
    @@protect_from_forgery ||= false
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
    if protect_from_forgery? && req.request_method != 'GET'
      check_authenticity_token
    end

    self.send(name)
    render(name) unless already_built_response?
  end

  def self.protect_from_forgery
    @@protect_from_forgery = true
  end

  def protect_from_forgery?
    @@protect_from_forgery
  end

  def form_authenticity_token
    @auth_token ||= SecureRandom.urlsafe_base64(16)
    res.set_cookie('authenticity_token', value: auth_token, path: '/')
    auth_token
  end

  def check_authenticity_token
    auth_cookie = req.cookies['authenticity_token']
    unless auth_cookie && auth_cookie == form_authenticity_token
      raise "Invalid authenticity token"
    end
  end
end
