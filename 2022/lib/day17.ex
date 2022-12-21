defmodule AOC.Day17 do

  @block_width 7

  @blocks [
    [
      [?., ?., ?@, ?@, ?@, ?@, ?.],
    ],
    [
      [?., ?., ?., ?@, ?., ?., ?.],
      [?., ?., ?@, ?@, ?@, ?., ?.],
      [?., ?., ?., ?@, ?., ?., ?.],
    ],
    [
      [?., ?., ?., ?., ?@, ?., ?.],
      [?., ?., ?., ?., ?@, ?., ?.],
      [?., ?., ?@, ?@, ?@, ?., ?.],
    ],
    [
      [?., ?., ?@, ?., ?., ?., ?.],
      [?., ?., ?@, ?., ?., ?., ?.],
      [?., ?., ?@, ?., ?., ?., ?.],
      [?., ?., ?@, ?., ?., ?., ?.],
    ],
    [
      [?., ?., ?@, ?@, ?., ?., ?.],
      [?., ?., ?@, ?@, ?., ?., ?.],
    ],
  ]

  @empty_row [?., ?., ?., ?., ?., ?., ?.]

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.to_charlist()
  end

  def get_block(idx, trailing_rows \\ 3) do
    @blocks
    |> Enum.at(Integer.mod(idx, length(@blocks)))
    |> then(fn l -> l ++ for _ <- 1..trailing_rows//1, do: @empty_row end)
  end

  def can_move?(block, fun) do
    block
    |> Enum.map(fun)
    |> Enum.all?(&(&1 == ?.))
  end

  def can_move_left?(block) do
    block
    |> can_move?(&Kernel.hd/1)
  end

  def can_move_right?(block) do
    block
    |> can_move?(&List.last/1)
  end

  def can_move_down?(block) do
    block
    |> List.last()
    |> Enum.all?(&(&1 == ?.))
  end

  def move_block(block, direction) do
    cond do
      direction == ?> && can_move_right?(block) ->
        block
        |> Enum.map(&Enum.slide(&1, @block_width - 1, 0))
      direction == ?< && can_move_left?(block) ->
        block
        |> Enum.map(&Enum.slide(&1, 0, @block_width - 1))

      direction == ?v && can_move_down?(block) ->
        block
        |> Enum.slide(length(block) - 1, 0)
      direction != ?v ->
        block
      true ->
        # raise "No block movement possible"
        block
    end
  end

  def format_block(block) do
    block
    |> Enum.map(fn l -> "|" <> List.to_string(l) <> "|" end)
    |> Enum.join("\n")
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)

    1..24
    |> Enum.map(&__MODULE__.get_block/1)
    |> Enum.with_index()
    |> Enum.map(fn {block, idx} ->
      1..5
      |> Enum.reduce(block, fn _, block_acc ->
        case Integer.mod(idx, 3) do
          0 ->
            move_block(block_acc, ?>)
          1 ->
            move_block(block_acc, ?<)
          2 ->
            move_block(block_acc, ?v)
          _ ->
            block_acc
        end
      end)
    end)
    |> Enum.map(&__MODULE__.format_block/1)
    # |> Enum.map(&IO.puts/1)
    |> Enum.with_index()
    |> Enum.map(fn {block_str, idx} ->

      case Integer.mod(idx, 3) do
        0 ->
          IO.puts("right:")
        1 ->
          IO.puts("left:")
        2 ->
          IO.puts("down:")
        _ ->
          IO.puts("in place:")
      end
      IO.puts(block_str <> "\n")
      block_str
    end)
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
