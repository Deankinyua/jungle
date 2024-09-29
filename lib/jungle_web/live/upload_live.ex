# lib/my_app_web/live/upload_live.ex
defmodule JungleWeb.UploadLive do
  use JungleWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar, accept: ~w(.mp3 .jpeg .png), max_entries: 2)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        dest = Path.join(Application.app_dir(:jungle, "priv/static/uploads"), Path.basename(path))
        # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
        # name = System.shell("exiftool  -FileName  #{path}")
        # dbg(File.ls(path))
        # dbg(path)
        # File.cp!(path, dest)
        ent = Enum.at(socket.assigns.uploads.avatar.entries, 0)

        file_name = Path.rootname(ent.client_name)

        unwanted_characters = [" ", "(", ")", "-", "[", "]"]

        file_name = Enum.join(String.split(file_name, unwanted_characters), "_")
        output_file = file_name <> "." <> "m4a"
        dbg(output_file)

        command = "ffmpeg -i #{path} " <> output_file
        dbg(command)
        System.shell(command)

        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
