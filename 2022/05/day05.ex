defmodule Day05 do

  def read_input(path) do
    {status, data} = File.read(path)
    if status == :ok do
      data
    else
      raise "Input data not found"
    end
  end

  def parse_input(raw_input) do
    String.split(raw_input)
  end

  def load_input(path) do
    raw_input = read_input(path)
    parse_input(raw_input)
  end

  def solve(path, 1) do
    load_input(path)
  end

  def solve(path, 2) do
    load_input(path)
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
