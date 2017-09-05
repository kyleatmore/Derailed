require 'rack'
require_relative '/lib/controller_base.rb'
require_relative '/lib/controller_base.rb'

class Train
  attr_reader :origin, :destination, :num_passengers

  def self.all
    @trains ||= []
  end

  def initialize(params = {})
    @origin = params[:origin]
    @destination = params[:destination]
    @num_passengers = params[:num_passengers]
  end

  def errors
    @errors ||= []
  end

  def valid?
    errors << "Origin can't be blank" if @origin.nil?
    errors << "Destination can't be blank" if @destination.nil?
    errors << "Number of passengers can't be blank" if @num_passengers.nil?

    errors.empty?
  end

  def save
    return false unless valid?
    Train.all << self
    true
  end

end

class TrainsController < ControllerBase
  def new
    render :new
  end

  def create
    @train = Train.new(params[:train])

    if @train.save
      flash[:notice] = "New Train Added!"
      redirect_to "/trains"
    else
      flash.now[:errors] = @train.errors
      render :new
    end
  end

  def index
    @trains = Train.all
    render :index
  end
end

router = Router.new
router.draw do
  get Regexp.new("^trains/new$"), TrainsController, :new
  post Regexp.new("^trains$"), TrainsController, :create
  get Regexp.new("^trains$"), TrainsController, :index
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(app: app, Port: 3000)
