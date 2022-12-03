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

  def parse_integer(str_val, fallback \\ nil) do
    case Integer.parse(str_val) do
      {int_val, ""} -> int_val
      :error        -> fallback
    end
  end

  def parse_input(raw_input) do
    String.split(raw_input, "\n")
    |> Enum.map(&AOC.parse_integer/1)
  end

  def load_input(path) do
    raw_input = read_input(path)
    parse_input(raw_input)
  end

  def solve_first(input) do
    Enum.chunk_by(input, fn item -> item == nil end)
    |> Enum.filter(fn item -> item != [nil] end)
    |> Enum.map(fn item -> Enum.sum(item) end)
    |> Enum.max()
  end

  def solve_second(input) do
    Enum.chunk_by(input, fn item -> item == nil end)
    |> Enum.filter(fn item -> item != [nil] end)
    |> Enum.map(fn item -> Enum.sum(item) end)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end

  def solve(path, 1) do
    input = load_input(path)
    solve_first(input)
  end

  def solve(path, 2) do
    input = load_input(path)
    solve_second(input)
  end

  def start(_type, _args) do
    # IO.puts(inspect(_args))
    data = solve("./input", 2)
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
