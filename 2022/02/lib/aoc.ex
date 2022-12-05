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

    def move_idx(move) do
      cond do
        Enum.member?(["A", "X"], move) ->
          0
        Enum.member?(["B", "Y"], move) ->
          1
        Enum.member?(["C", "Z"], move) ->
          2
      end
    end

  def parse_input(raw_input) do
    String.split(String.trim(raw_input), "\n")
    |> Enum.map(fn round ->
      String.split(round)
      |> Enum.map(&AOC.move_idx/1)
      |> List.to_tuple()
    end)
  end

  def get_losing_move(opponent_move) do
    Integer.mod(opponent_move - 1, 3)
  end

  def get_draw_move(opponent_move) do
    opponent_move
  end

  def get_winning_move(opponent_move) do
    Integer.mod(opponent_move + 1, 3)
  end

  def beats?(our_move, opponent_move) do
    # Rock       :X / :A / 1
    # Paper      :Y / :B / 2
    # Scissors   :Z / :C / 3
    Integer.mod(our_move - opponent_move, 3) == 1
  end

  def score_p1({opponent_move, our_move}) do
    cond do
      beats?(our_move, opponent_move) ->
        6 + our_move + 1
      beats?(opponent_move, our_move) ->
        0 + our_move + 1
      true ->
        3 + our_move + 1
      end
  end

  def score_p2({opponent_move, outcome}) do
    cond do
      outcome == 0 ->
        0 + get_losing_move(opponent_move) + 1
      outcome == 1 ->
        3 + get_draw_move(opponent_move) + 1
      outcome == 2 ->
        6 + get_winning_move(opponent_move) + 1
      end
  end

  def load_input(path) do
    raw_input = read_input(path)
    rounds = parse_input(raw_input)
  end

  def solve(path, 1) do
    rounds = load_input(path)
    score = Enum.map(rounds, &AOC.score_p1/1)
    |> Enum.sum()
  end

  def solve(path, 2) do
    rounds = load_input(path)
    score = Enum.map(rounds, &AOC.score_p2/1)
    |> Enum.sum()
  end

  def start(_type, _args) do
    score = solve("./input", 1)
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
