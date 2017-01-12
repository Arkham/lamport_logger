defmodule LamportLogger.Worker do
  defmodule State do
    defstruct name: nil, logger: nil, seed: 0, sleep: 1000, jitter: 0, peers: []
  end

  def start(name, logger, seed, sleep, jitter) do
    spawn_link(fn ->
      init(%State{name: name,
                  logger: logger,
                  seed: seed,
                  sleep: sleep,
                  jitter: jitter})
    end)
  end

  def stop(worker) do
    send(worker, :stop)
  end

  def peers(worker, peers) do
    send(worker, {:peers, peers})
  end

  def init(%State{seed: seed} = state) do
    :rand.seed(:exs1024, {seed, 10, 20})

    receive do
      {:peers, peers} ->
        loop(%State{state | peers: peers})
      :stop ->
        :ok
    end
  end

  def loop(%State{name: name, logger: logger, sleep: sleep, jitter: jitter, peers: peers} = state) do
    wait = :rand.uniform(sleep)

    receive do
      {:message, time, message} ->
        send(logger, {:log, name, time, {:received, message}})
        loop(state)
      :stop ->
        :ok
      error ->
        send(logger, {:log, name, :time, {:error, error}})
    after
      wait ->
        selected = select_peer(peers)
        time = :na
        message = {:hello, :rand.uniform(100)}

        send(selected, {:message, time, message})
        do_jitter(jitter)

        send(logger, {:log, name, time, {:sending, message}})
        loop(state)
    end
  end

  defp select_peer(peers) do
    Enum.random(peers)
  end

  defp do_jitter(0), do: :ok
  defp do_jitter(jitter) do
    :timer.sleep(:rand.uniform(jitter))
  end
end
