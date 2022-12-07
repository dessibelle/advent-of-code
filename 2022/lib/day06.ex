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

  def take_first_valid_marker(stream, block_size) do
    {marker_candidate, idx} = Stream.take(stream, 1) |> Enum.to_list() |> List.first()
    if valid_marker?(marker_candidate, block_size) do
      {marker_candidate, idx + block_size}
    else
      take_first_valid_marker(Stream.drop(stream, 1), block_size)
    end
  end

  def find_first_marker(str, block_size \\ 4) do
    chars = str
    |> String.to_charlist()

    Range.new(0, length(chars) - block_size)
    |> Stream.map(fn idx ->
      Enum.slice(chars, idx, block_size)
    end)
    |> Stream.with_index()
    |> take_first_valid_marker(block_size)
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
