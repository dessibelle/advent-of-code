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

  def solve(path, 1) do
    load_input(path)
  end

  def solve(path, 1) do
    load_input(path)
  end

  def start(_type, _args) do
    data = solve("./test", 1)
    IO.puts(inspect(data))

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
