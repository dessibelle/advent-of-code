defmodule AOC.Day06 do

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
  end

  def valid_marker?(marker_candidate, block_size) do
    MapSet.new(marker_candidate)
    |> MapSet.size() === block_size
  end

  def find_first_marker(str, block_size \\ 4) do
    chars = str
    |> String.to_charlist()

    Range.new(0, length(chars) - block_size)
    |> Stream.map(fn idx ->
      Enum.slice(chars, idx, block_size)
    end)
    |> Stream.with_index()
    |> Stream.drop_while(fn {marker, _idx} -> !valid_marker?(marker, block_size) end)
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.first()
    |> (fn {marker, idx} -> {marker, idx + block_size} end).()
  end

  def format_solution({marker, index}) do
    "Found marker '#{marker}' after #{index} chars"
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> Enum.map(&AOC.Day06.find_first_marker/1)
    |> Enum.map(&AOC.Day06.format_solution/1)
    |> Enum.join("\n")
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
    |> Enum.map(fn input -> AOC.Day06.find_first_marker(input, 14) end)
    |> Enum.map(&AOC.Day06.format_solution/1)
    |> Enum.join("\n")
  end
end
