defmodule JungleWeb.Locale do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    message = Keyword.get(opts, :message, "default message")

    conn = assign(conn, :message, message)

    conn
  end
end
