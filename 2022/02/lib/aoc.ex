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
    String.split(String.trim(raw_input), "\n")
    |> Enum.map(fn round ->
      String.split(round)
      |> Enum.map(&String.to_atom/1)
      |> List.to_tuple()
    end)
  end

  def move_idx(move) do
    cond do
      Enum.member?([:A, :X], move) ->
        1
      Enum.member?([:B, :Y], move) ->
        2
      Enum.member?([:C, :Z], move) ->
        3
    end
  end

  def beats?(our_move, opponent_move) do
    # Rock       :X / :A / 1
    # Paper      :Y / :B / 2
    # Scissors   :Z / :C / 3
    our_move_idx = move_idx(our_move)
    opponent_move_idx = move_idx(opponent_move)
    # TODO: Can use some -1 and modulo math instead
    cond do
      our_move_idx == 1 && opponent_move_idx == 3 ->
        true
      our_move_idx == 2 && opponent_move_idx == 1 ->
        true
      our_move_idx == 3 && opponent_move_idx == 2 ->
        true
      true ->
        false
    end
  end

  def score({opponent_move, our_move}) do
    move_points = move_idx(our_move)
    cond do
      beats?(our_move, opponent_move) ->
        6 + move_points
      beats?(opponent_move, our_move) ->
        0 + move_points
      true ->
        3 + move_points
      end
  end

  def load_input(path) do
    raw_input = read_input(path)
    rounds = parse_input(raw_input)
  end

  def start(_type, _args) do
    data = load_input("./input")
    score = Enum.map(data, &AOC.score/1)
    |> Enum.sum()
    IO.puts(inspect(score))

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
