defmodule AOC.Day01 do

  def parse_integer(str_val, fallback \\ nil) do
    case Integer.parse(str_val) do
      {int_val, ""} -> int_val
      :error        -> fallback
    end
  end

  def parse_input(raw_input) do
    String.split(raw_input, "\n")
    |> Enum.map(&AOC.Day01.parse_integer/1)
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> Enum.chunk_by(fn item -> item == nil end)
    |> Enum.filter(fn item -> item != [nil] end)
    |> Enum.map(fn item -> Enum.sum(item) end)
    |> Enum.max()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
    |> Enum.chunk_by(fn item -> item == nil end)
    |> Enum.filter(fn item -> item != [nil] end)
    |> Enum.map(fn item -> Enum.sum(item) end)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end
end
