defmodule LamportLogger.Worker do
  defmodule State do
    defstruct name: nil, logger: nil, seed: 0, sleep: 1000, jitter: 0,
      peers: [], worker_time: nil
  end

  alias LamportLogger.Time

  def start(name, logger, seed, sleep, jitter) do
    spawn_link(fn ->
      init(%State{name: name,
                  logger: logger,
                  seed: seed,
                  sleep: sleep,
                  jitter: jitter,
                  worker_time: Time.zero()})
    end)
  end

  def stop(worker) do
    send(worker, :stop)
  end

  def peers(worker, peers) do
    send(worker, {:peers, peers})
  end

  def init(%State{seed: seed} = state) do
    :rand.seed(:exs1024, {seed, 0, 0})

    receive do
      {:peers, peers} ->
        loop(%State{state | peers: peers})
      :stop ->
        :ok
    end
  end

  def loop(%State{name: name, logger: logger, sleep: sleep, jitter: jitter, peers: peers, worker_time: worker_time} = state) do
    wait = :rand.uniform(sleep)

    receive do
      {:message, time, message} ->
        worker_time = Time.merge_and_increase(time, worker_time)
        send(logger, {:log, name, worker_time, {:recv, message}})
        loop(%State{state | worker_time: worker_time})
      :stop ->
        :ok
      error ->
        send(logger, {:log, name, worker_time, {:error, error}})
    after
      wait ->
        selected = select_peer(peers)
        worker_time = Time.increase(worker_time)
        message = {:hello, :rand.uniform(100_000)}

        send(selected, {:message, worker_time, message})
        do_jitter(jitter)

        send(logger, {:log, name, worker_time, {:send, message}})
        loop(%State{state | worker_time: worker_time})
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
