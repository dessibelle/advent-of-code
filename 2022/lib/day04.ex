defmodule AOC.Day04 do

  def parse_tuple(str_data, separator, parser_fn) do
    String.split(str_data, separator)
    |> Enum.map(parser_fn)
    |> List.to_tuple()
  end

  def parse_range(range) do
    parse_tuple(range, "-", &String.to_integer/1)
    |> (fn s -> Range.new(elem(s, 0), elem(s, 1)) end).()
  end

  def parse_range_pair(range_pair) do
    parse_tuple(range_pair, ",", &AOC.Day04.parse_range/1)
  end

  def parse_input(raw_input) do
    String.split(raw_input)
    |> Enum.map(&AOC.Day04.parse_range_pair/1)
  end

  def range_is_subrange?({range1, range2}) do
    MapSet.subset?(MapSet.new(range1), MapSet.new(range2))
  end

  def either_range_is_subrange?({range1, range2}) do
    range_is_subrange?({range1, range2}) or range_is_subrange?({range2, range1})
  end

  def ranges_overlap?({range1, range2}) do
    !Range.disjoint?(range1, range2)
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> Enum.filter(&AOC.Day04.either_range_is_subrange?/1)
    |> Enum.count()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
    |> Enum.filter(&AOC.Day04.ranges_overlap?/1)
    |> Enum.count()
  end
end
