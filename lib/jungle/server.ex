defmodule Jungle.Periodically do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: MyStack)
  end

  @impl true
  def init(state) do
    # Schedule work to be performed on start
    # schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(msg, state) do
    # Do the desired work here
    # ...

    # Reschedule once more

    state = [msg | state]
    # schedule_work()

    {:noreply, state}
  end

  @impl true
  def handle_call(request, from, state) do
    # state = "new state"
    # dbg(request)
    # dbg(from)
    {:reply, state, state}
  end

  # defp schedule_work do
  #   # We schedule the work to happen in 2 hours (written in milliseconds).
  #   # Alternatively, one might write :timer.hours(2)
  #   Process.send_after(self(), :work, 2 * 60 * 60 * 1000)
  # end
end
