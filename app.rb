require 'date'
require 'erubi'
require 'filesize'
require 'si'
require './command'

set :erb, :escape_html => true

if development?
  require 'sinatra/reloader'
  also_reload './command.rb'
end

helpers do
  def dashboard_title
    "Open OnDemand"
  end

  def dashboard_url
    "/pun/sys/dashboard/"
  end

  def title
    "File System Quotas"
  end

  def fsize(x, unit="B")
      Filesize.from("%d %s" % [x.abs, unit]).pretty
  end

  def sisize(x)
      x.si
  end
end

# Define a route at the root '/' of the app.
get '/' do
  @command = Command.new
  @quotas, @error = @command.exec
  @timestamp = DateTime.strptime(@quotas['timestamp'].to_s, '%s').strftime("%Y-%m-%d %H:%M")

  # Render the view
  erb :index
end
