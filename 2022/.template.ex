defmodule AOC.Day00 do

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
