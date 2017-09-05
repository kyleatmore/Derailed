class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    req.request_method.downcase.to_sym == self.http_method &&
      req.path =~ self.pattern
  end

  def run(req, res)
    match_data = self.pattern.match(req.path)
    route_params = match_data.names.zip(match_data.captures).to_h

    controller = self.controller_class.new(req, res, route_params)
    controller.invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    self.routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    self.routes.each do |route|
      return route if route.matches?(req)
    end

    nil
  end

  def run(req, res)
    matching_route = match(req)

    if matching_route
      matching_route.run(req, res)
    else
      res.status = 404
      res.write("No matching route found")
    end
  end
end
