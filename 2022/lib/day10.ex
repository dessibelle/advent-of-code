defmodule AOC.Day10 do

  def parse_instruction(raw_instruction) do
    case String.split(raw_instruction, " ") do
      [instruction, value] ->
        {String.to_atom(instruction), String.to_integer(value)}
      [instruction] ->
        {String.to_atom(instruction), nil}
    end
  end

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&AOC.Day10.parse_instruction/1)
  end

  def get_register_at_cycle_states(input) do
    input
    |> Enum.map(fn {instruction, _value} = op ->
      if instruction == :addx do
        [op, {:noop, false}]
      else
        [op]
      end
    end)
    |> List.flatten()
    |> Enum.reduce([1, 1], fn {instruction, value}, registers ->
      register = registers |> hd
      if instruction == :addx do
        next_register = register + value
        [next_register | registers]
      else
        [register | registers]
      end
    end)
    |> Enum.reverse()
    |> Enum.with_index(1)
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> get_register_at_cycle_states()
    |> Enum.filter(fn {_value, idx} ->
      idx in [20, 60, 100, 140, 180, 220]
    end)
    |> Enum.reduce(%{sum: 0, debug: []}, fn {value, cycle}, acc ->
      acc
      |> Map.update(:sum, nil, fn p -> p + cycle * value end)
      |> Map.update(:debug, [], fn p -> ["#{cycle} * #{value} = #{cycle * value}" | p] end)
    end)
    |> then(fn %{debug: _, sum: sum} ->
      # IO.puts(debug |> Enum.reverse() |> Enum.join(("\n")))
      sum
    end)
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
    |> get_register_at_cycle_states()
    |> Enum.map(fn {value, index} ->
      col = Integer.mod(index - 1, 40)
      if col - value in -1..1, do: "#", else: "."
    end)
    |> Enum.chunk_every(40)
    |> Enum.join("\n")
  end
end
