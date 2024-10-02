defmodule JungleWeb.UserController do
  use JungleWeb, :controller

  def get_pid do
    say_hello = fn ->
      receive do
        message ->
          IO.puts("message")
          message
      after
        5000 ->
          IO.puts("Timeout - no messages received")
      end
    end

    say_hello
  end

  def introspect(conn, opts) do
    message = Keyword.get(opts, :message, "default message")

    conn = assign(conn, :message, message)

    conn
  end

  def index(conn, _params) do
    # file_name = say_hello.()

    # final_file_name = "priv/static/downloads/" <> file

    dbg(conn)
    # path = Application.app_dir(:jungle, final_file_name)
    # send_download(conn, {:file, path})
    render(conn, :index)
  end

  # redirect(to: ~p"/")
end
