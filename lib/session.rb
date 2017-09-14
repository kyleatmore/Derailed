require 'json'

class Session
  def initialize(req)
    cookie = req.cookies['_derailed']
    @cookie_val = cookie ? JSON.parse(cookie) : {}
  end

  def [](key)
    @cookie_val[key]
  end

  def []=(key, val)
    @cookie_val[key] = val
  end

  def store_session(res)
    res.set_cookie('_derailed', {
      value: @cookie_val.to_json,
      path: '/'
      })
  end
end
