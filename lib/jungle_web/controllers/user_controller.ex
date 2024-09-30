defmodule JungleWeb.UserController do
  use JungleWeb, :controller

  # say_hello = fn ->
  #   receive do
  #     message ->
  #       IO.puts(message)
  #       message
  #   after
  #     5000 ->
  #       IO.puts("Timeout - no messages received")
  #   end
  # end

  # spawn(say_hello)

  def index(conn, _params) do
    # file_name = say_hello.()
    # dbg(file_name)

    # final_file_name = "priv/static/downloads/" <> file_name

    # path = Application.app_dir(:jungle, final_file_name)
    # send_download(conn, {:file, path})
    render(conn, :index)
  end

  # redirect(to: ~p"/")
end

# spawn(fn -> IO.puts("nothing") end)

# def receiver do
#   receive do
#     message ->
#       # IO.puts(message)
#       # response = "The message from sender module has been received"
#       # send(caller_pid, {self(), response})
#       message
#   after
#     5000 -> IO.puts("message not received")
#   end
# end

# spawn(fn -> listen() end)
