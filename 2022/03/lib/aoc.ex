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
    Enum.map(rucksack, &AOC.get_common_items/1)
    |> Enum.map(fn items ->
      MapSet.to_list(items)
      |> Enum.map(&AOC.get_item_priority/1)
      |> Enum.reduce(0, fn priority, acc -> priority + acc end)
    end)
  end

  def solve(path, 1) do
    load_input(path)
    |> Enum.map(&AOC.compartmentalize_rucksack_contents/1)
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

  def start(_type, _args) do
    sum = solve("./input", 2)
    IO.puts(sum |> inspect(charlists: :as_lists))

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
