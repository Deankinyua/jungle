defmodule JungleWeb.UserController do
  use JungleWeb, :controller

  # alias Recursive.Periodically

  def index(conn, _params) do
    render(conn, :index)
  end

  def downloader(conn, _params) do
    message = GenServer.call(MyStack, conn)

    dbg(message)

    length = Enum.count(message)

    kill(conn, message, 0, length)

    render(conn, :download)
  end

  def kill(conn, enum, index, length) do
    if index >= length do
      IO.puts("The Process is complete")
    else
      file = Enum.at(enum, index)

      final_file_name = "priv/static/downloads/" <> file

      path = Application.app_dir(:jungle, final_file_name)

      send_download(conn, {:file, path})
      Process.sleep(4000)

      kill(conn, enum, index + 1, length)
    end
  end
end
