require 'json'

class Flash
  def initialize(req)
    @req = req
    flash_cookie = req.cookies['_rails_lite_app_flash']
    @flash_now = flash_cookie ? JSON.parse(flash_cookie) : {}
    @flash = {}
  end

  def [](key)
    @flash[key.to_sym].to_s || @flash_now[key.to_sym].to_s
  end

  def now(key, val)
    @flash_now[key.to_sym] = val.to_sym
  end

  def []=(key, val)
    @flash[key.to_sym] = val.to_sym
  end

  def store_flash(res)
    res.set_cookie('flash', {
      value: @flash.to_json,
      path: '/'
      })
  end
end
