defmodule Day03 do
  @moduledoc """
  Advent of Code solution
  """


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

  def compartmentalize_rucksack_contents(contents) do
    String.split_at(contents, Integer.floor_div(String.length(contents), 2))
    |> Tuple.to_list()
    |> Enum.map(fn compartment -> MapSet.new(String.to_charlist(compartment)) end)
  end

  def get_common_items(sets) do
    Enum.reduce(sets, fn elem, acc -> MapSet.intersection(acc, elem) end)
  end

  def get_item_priority(item) do
    if item >= ?a do
      item - ?a + 1
    else
      item - ?A + 1 + 26
    end
  end

  def get_priorities(rucksack) do
    Enum.map(rucksack, &Day03.get_common_items/1)
    |> Enum.map(fn items ->
      MapSet.to_list(items)
      |> Enum.map(&Day03.get_item_priority/1)
      |> Enum.reduce(0, fn priority, acc -> priority + acc end)
    end)
  end

  def solve(path, 1) do
    load_input(path)
    |> Enum.map(&Day03.compartmentalize_rucksack_contents/1)
    |> get_priorities()
    |> Enum.sum()
  end

  def solve(path, 2) do
    load_input(path)
    |> Enum.map(fn rucksack -> String.to_charlist(rucksack) |> MapSet.new() end)
    |> Enum.chunk_every(3)
    |> get_priorities()
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

Day03.print()
