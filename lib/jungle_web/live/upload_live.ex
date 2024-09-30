# lib/my_app_web/live/upload_live.ex
defmodule JungleWeb.UploadLive do
  use JungleWeb, :live_view
  alias JungleWeb.UserController

  @impl true

  def render(assigns) do
    ~H"""
    <%!-- use phx-drop-target with the upload ref to enable file drag and drop --%>
    <section phx-drop-target="{@uploads.avatar.ref}">
      <form id="upload-form" phx-submit="save" phx-change="validate">
        <.live_file_input upload={@uploads.avatar} id="fileInput" />

        <button type="submit">Upload</button>
      </form>
      <.link patch={~p"/users"}>
        <.button>Download the File</.button>
      </.link>

      <%!-- render each avatar entry --%>
      <%= for entry <- @uploads.avatar.entries
    do %>
        <article class="upload-entry">
          <figure>
            <.live_img_preview entry={entry} />
            <figcaption><%= entry.client_name %></figcaption>
          </figure>

          <%!-- entry.progress will update automatically for in-flight entries --%>
          <progress value="{entry.progress}" max="100">
            <%= entry.progress %>%
          </progress>

          <%!-- a regular click event whose handler will invoke
    Phoenix.LiveView.cancel_upload/3 --%>
          <button
            type="button"
            phx-click="cancel-upload"
            phx-value-ref="{entry.ref}"
            aria-label="cancel"
          >
            &times;
          </button>

          <%!-- Phoenix.Component.upload_errors/2 returns a list of error atoms --%>
          <%= for err <- upload_errors(@uploads.avatar, entry) do %>
            <p class="alert alert-danger"><%= error_to_string(err) %></p>
          <% end %>
        </article>
      <% end %>
      <%!-- Phoenix.Component.upload_errors/1 returns a list of error
    atoms --%>
      <%= for err <- upload_errors(@uploads.avatar) do %>
        <p class="alert alert-danger"><%= error_to_string(err) %></p>
      <% end %>
    </section>
    """
  end

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

  defp send_message(message) do
    pid = UserController.get_pid()

    Process.send_after(pid, message, 2000)
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
        send_message(output_file)
        # send(receiver_pid, {self(), output_file})
        # send(pid, {self(), output_file})
        output_file = "priv/static/downloads/" <> output_file

        path1 = Path.absname(output_file)

        dbg(path1)

        command = "ffmpeg -i #{path} " <> output_file
        System.shell(command)

        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    {:noreply, socket}
  end

  # update(socket, :uploaded_files, &(&1 ++ uploaded_files))

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
