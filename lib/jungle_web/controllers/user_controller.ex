defmodule JungleWeb.UserController do
  use JungleWeb, :controller

  def get_pid do
    self()
  end

  def index(conn, _params) do
    receiver = fn ->
      receive do
        message ->
          IO.puts(message)
          final_file_name = "priv/static/downloads/" <> message
          dbg(final_file_name)
          # path = Application.app_dir(:jungle, final_file_name)
          # send_download(conn, {:file, path})
      after
        0 ->
          IO.puts(:stderr, "No message in the mailbox")
      end
    end

    receiver.()
    render(conn, :index)
  end
end
