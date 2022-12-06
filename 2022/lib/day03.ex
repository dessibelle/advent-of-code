defmodule AOC.Day03 do

  def parse_input(raw_input) do
    String.split(raw_input)
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
    Enum.map(rucksack, &AOC.Day03.get_common_items/1)
    |> Enum.map(fn items ->
      MapSet.to_list(items)
      |> Enum.map(&AOC.Day03.get_item_priority/1)
      |> Enum.reduce(0, fn priority, acc -> priority + acc end)
    end)
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> Enum.map(&AOC.Day03.compartmentalize_rucksack_contents/1)
    |> get_priorities()
    |> Enum.sum()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
    |> Enum.map(fn rucksack -> String.to_charlist(rucksack) |> MapSet.new() end)
    |> Enum.chunk_every(3)
    |> get_priorities()
    |> Enum.sum()
  end
end
