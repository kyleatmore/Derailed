require 'json'

class Session
  def initialize(req)
    cookie = req.cookies['_rails_lite_app']
    @cookie_val = cookie ? JSON.parse(cookie) : {}
  end

  def [](key)
    @cookie_val[key]
  end

  def []=(key, val)
    @cookie_val[key] = val
  end

  def store_session(res)
    res.set_cookie('_rails_lite_app', {
      value: @cookie_val.to_json,
      path: '/'
      })
  end
end
