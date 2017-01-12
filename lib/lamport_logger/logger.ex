defmodule LamportLogger.Logger do
  def start(nodes) do
    spawn_link(fn -> init(nodes) end)
  end

  def stop(logger) do
    send(logger, :stop)
  end

  def init(_nodes) do
    loop()
  end

  def loop do
    receive do
      {:log, from, time, message} ->
        log(from, time, message)
        loop()
      :stop ->
        :ok
    end
  end

  defp log(from, time, message) do
    IO.puts("log: #{inspect(time)}\t#{inspect(from)}\t#{inspect(message)}")
  end
end
