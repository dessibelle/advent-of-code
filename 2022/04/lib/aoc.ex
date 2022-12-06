defmodule AOC do
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

  def parse_tuple(str_data, separator, parser_fn) do
    String.split(str_data, separator)
    |> Enum.map(parser_fn)
    |> List.to_tuple()
  end

  def parse_range(range) do
    parse_tuple(range, "-", &String.to_integer/1)
  end

  def parse_range_pair(range_pair) do
    parse_tuple(range_pair, ",", &AOC.parse_range/1)
  end

  def parse_input(raw_input) do
    String.split(raw_input)
    |> Enum.map(&AOC.parse_range_pair/1)
  end

  def load_input(path) do
    raw_input = read_input(path)
    parse_input(raw_input)
  end

  def range_is_subrange?({range1, range2}) do
    {r1a, r1b} = range1
    {r2a, r2b} = range2
    # MapSet.subset?(MapSet.new(r1a..r1b), MapSet.new(r2a..r2b))
    r2a >= r1a and r2b <= r1b
  end

  def range_is_subrange?({range1, range2}) do
    {r1a, r1b} = range1
    {r2a, r2b} = range2
    # MapSet.subset?(MapSet.new(r1a..r1b), MapSet.new(r2a..r2b))
    r2a >= r1a and r2b <= r1b
  end

  def either_range_is_subrange?({range1, range2}) do
    range_is_subrange?({range1, range2}) or range_is_subrange?({range2, range1})
  end

  def solve(path, 1) do
    load_input(path)
    |> Enum.filter(&AOC.either_range_is_subrange?/1)
    |> Enum.count()
  end

  def solve(path, 1) do
    load_input(path)
  end

  def start(_type, _args) do
    data = solve("./input", 1)
    IO.puts(data |> inspect(charlists: :as_lists))

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: A.Worker.start_link(arg)
      # {A.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: A.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
