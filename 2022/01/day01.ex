defmodule Day01 do

  def read_input(path) do
    {status, data} = File.read(path)
    if status == :ok do
      data
    else
      raise "Input data not found"
    end
  end

  def parse_integer(str_val, fallback \\ nil) do
    case Integer.parse(str_val) do
      {int_val, ""} -> int_val
      :error        -> fallback
    end
  end

  def parse_input(raw_input) do
    String.split(raw_input, "\n")
    |> Enum.map(&Day01.parse_integer/1)
  end

  def load_input(path) do
    raw_input = read_input(path)
    parse_input(raw_input)
  end

  def solve(path, 1) do
    load_input(path)
    |> Enum.chunk_by(fn item -> item == nil end)
    |> Enum.filter(fn item -> item != [nil] end)
    |> Enum.map(fn item -> Enum.sum(item) end)
    |> Enum.max()
  end

  def solve(path, 2) do
    load_input(path)
    |> Enum.chunk_by(fn item -> item == nil end)
    |> Enum.filter(fn item -> item != [nil] end)
    |> Enum.map(fn item -> Enum.sum(item) end)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end

  def print() do
    solutions = %{
      test1: solve("./test", 1),
      test2: solve("./test", 2),
      part1: solve("./input", 1),
      part2: solve("./input", 2),
    }

    for {k, x} <- solutions do
      IO.puts("#{k}: #{x}")
    end
  end
end

Day01.print()
