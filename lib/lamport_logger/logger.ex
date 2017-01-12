defmodule LamportLogger.Logger do
  alias LamportLogger.Time

  def start(nodes) do
    spawn_link(fn -> init(nodes) end)
  end

  def stop(logger) do
    send(logger, :stop)
  end

  def init(nodes) do
    nodes_list = for node <- nodes, do: {node, Time.zero()}
    nodes_map = Enum.into(nodes_list, Map.new)
    loop(nodes_map, [])
  end

  def loop(nodes_map, message_queue) do
    receive do
      {:log, from, time, message} ->
        new_nodes_map = Map.put(nodes_map, from, time)
        new_message_queue = process_message_queue([{from, time, message}|message_queue], new_nodes_map)
        loop(new_nodes_map, new_message_queue)
      :stop ->
        :ok
    end
  end

  defp log(from, time, message) do
    IO.puts("log: #{inspect(time)}\t#{inspect(from)}\t#{inspect(message)}")
  end

  defp process_message_queue(message_queue, nodes_map) do
    common_max_time = nodes_map
                      |> Map.values
                      |> Time.min

    {to_print, to_keep} = message_queue
                          |> Enum.split_with(fn({_from, time, _message}) ->
                            Time.leq(time, common_max_time)
                          end)

    to_print
    |> Enum.sort(fn({_, first, _}, {_, second, _}) ->
      Time.leq(first, second)
    end)
    |> Enum.each(fn({from, time, message}) ->
      log(from, time, message)
    end)

    to_keep
  end
end
