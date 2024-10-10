defmodule JungleWeb.PageController do
  use JungleWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
