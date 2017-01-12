defmodule LamportLogger.Time do
  defstruct value: nil

  def zero, do: %__MODULE__{value: 0}

  def increase(%__MODULE__{value: value}) do
    %__MODULE__{value: value + 1}
  end

  def merge(%__MODULE__{value: first}, %__MODULE__{value: second}) do
    %__MODULE__{value: max(first, second)}
  end

  def merge_and_increase(first, second) do
    merge(first, second) |> increase
  end

  def leq(%__MODULE__{value: first}, %__MODULE__{value: second}) do
    first <= second
  end

  def min(list) do
    Enum.min_by(list, fn(elem) ->
      elem.value
    end)
  end
end
