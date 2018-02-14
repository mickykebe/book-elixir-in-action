defmodule WebServer do
  def index do
    :timer.sleep(1000)

    "<html><head></head><body>index</body></html>"
  end
end