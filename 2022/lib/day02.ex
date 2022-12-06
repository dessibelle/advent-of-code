defmodule AOC.Day02 do

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
      |> Enum.map(&AOC.Day02.move_idx/1)
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

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> Enum.map(&AOC.Day02.score_p1/1)
    |> Enum.sum()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
    |> Enum.map(&AOC.Day02.score_p2/1)
    |> Enum.sum()
  end
end
