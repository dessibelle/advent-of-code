defmodule AOC.Day04 do

  def parse_tuple(str_data, separator, parser_fn) do
    String.split(str_data, separator)
    |> Enum.map(parser_fn)
    |> List.to_tuple()
  end

  def parse_range(range) do
    parse_tuple(range, "-", &String.to_integer/1)
  end

  def parse_range_pair(range_pair) do
    parse_tuple(range_pair, ",", &AOC.Day04.parse_range/1)
  end

  def parse_input(raw_input) do
    String.split(raw_input)
    |> Enum.map(&AOC.Day04.parse_range_pair/1)
  end

  def range_is_subrange?({range1, range2}) do
    {r1a, r1b} = range1
    {r2a, r2b} = range2
    MapSet.subset?(MapSet.new(r1a..r1b), MapSet.new(r2a..r2b))
    # r2a >= r1a and r2b <= r1b
  end

  def either_range_is_subrange?({range1, range2}) do
    range_is_subrange?({range1, range2}) or range_is_subrange?({range2, range1})
  end

  def ranges_overlap?({range1, range2}) do
    {r1a, r1b} = range1
    {r2a, r2b} = range2
    !MapSet.disjoint?(MapSet.new(r1a..r1b), MapSet.new(r2a..r2b))
    # ((r1a <= r2a) and (r2a <= r1b))
    # or ((r1a <= r2b) and (r2b <= r1b))
    # or ((r2a <= r1a) and (r1a <= r2b))
    # or ((r2a <= r1b) and (r1b <= r2b))
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
