defmodule AOC.Day20 do

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def mix_reducer({_, _} = item, state) do
    # As the list is circular, moving the first item to the end of the list
    # doesn't change the order, so we need to suptract one here
    num_items = length(state) - 1
    index = Enum.find_index(state, fn x -> x == item end)
    {value, _} = Enum.at(state, index)
    next_index = Integer.mod(index + value + num_items, num_items)

    next_state = Enum.slide(state, index, next_index)
    # IO.puts("Moving #{value} from #{index} to #{next_index}")
    # IO.inspect(Enum.map(next_state, &(elem(&1, 0))))
    # IO.puts("")

    next_state
  end

  def mix(numbers) do
    numbers_with_indices = Enum.with_index(numbers)

    numbers_with_indices
    |> Enum.reduce(numbers_with_indices, &__MODULE__.mix_reducer/2)
    |> Enum.map(&(elem(&1, 0)))
  end

  def nth_item(stream, n) do
    stream
    |> Stream.drop(n)
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.first()
  end

  def score(list) do
    stream = list
    |> Stream.cycle()
    |> Stream.drop_while(&(&1 != 0))

    [
      nth_item(stream, 1000),
      nth_item(stream, 2000),
      nth_item(stream, 3000)
    ]
    |> Enum.sum()
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> mix()
    |> score()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
