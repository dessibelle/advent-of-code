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

  def start(_type, _args) do
    data = solve("./test", 1)
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
