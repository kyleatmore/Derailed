# Derailed

Derailed is an MVC framework inspired by Rails. The ControllerBase class provides controller functionality and the Router class creates routes which load HTML views.

## Features & Implementation

### ControllerBase

The ControllerBase acts as the parent class for all controllers and defines the following methods:

- redirect_to(url): Issues a redirect to the provided url
- render(template_name): Constructs path to template view based on controller name, evaluates ERB template, and passes the result to render_content
- render_content(content, content_type): Sets the response body and content type
- session: Creates a cookie and writes data to it
- flash: Creates a flash cookie. Values in flash persist for the current and next request. Values in flash.now persist only for the current request.

### Router

The Router class allows you create routes which map a url to a specific controller and controller method. Multiples routes can be created in a block using Router::draw method. The below code creates new, create, and index routes which map to the TrainsController.

```ruby
router = Router.new

router.draw do
  get Regexp.new("^/trains/new$"), TrainsController, :new
  post Regexp.new("^/trains$"), TrainsController, :create
  get Regexp.new("^/trains$"), TrainsController, :index
end
```

## How To Run Example

1. git clone https://github.com/kyleatmore/Derailed
2. bundle install
3. bundle exec ruby train.rb
4. Visit http://localhost:3000/trains
