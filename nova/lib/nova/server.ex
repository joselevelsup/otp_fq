defmodule Nova.Server do
  use GenServer
  alias Nova.Counter

  # Client

  def child_spec(%{name: name} = arg) do
    %{
      id: name,
      start: {__MODULE__, :start_link, [arg]}
    }
  end

  def start_link(arg) do
    IO.puts("starting server")
    GenServer.start_link(__MODULE__, arg.initial_value, name: arg.name)
  end

  def increment(pid) do
    GenServer.cast(pid, :inc)
  end

  def decrement(pid) do
    GenServer.cast(pid, :dec)
  end

  def read_state(pid) do
    GenServer.call(pid, :read)
  end

  # Server (callbacks)

  @impl true
  def init(initial_value) do
    IO.puts("received init callback")
    {:ok, Counter.new(initial_value)}
  end

  @impl true
  def handle_call(:read, _from, state) do
    {:reply, Counter.message(state), state}
  end

  @impl true
  def handle_cast(:inc, state) do
    {:noreply, Counter.inc(state)}
  end

  @impl true
  def handle_cast(:dec, state) do
    {:noreply, Counter.dec(state)}
  end
end
