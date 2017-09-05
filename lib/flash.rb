require 'json'

class Flash
  attr_reader :now

  def initialize(req)
    flash_cookie = req.cookies['_rails_lite_app_flash']
    @now = flash_cookie ? JSON.parse(flash_cookie) : {}
    @flash = {}
  end

  def [](key)
    @flash[key.to_s] || @now[key.to_s]
  end

  def []=(key, val)
    @flash[key.to_s] = val
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', {
      value: @flash.to_json,
      path: '/'
      })
  end
end
