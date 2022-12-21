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

  def move_block(block, direction) do
    # TODO: Edge detection
    case direction do
      ?> ->
        block
        |> Enum.map(&Enum.slide(&1, @block_width - 1, 0))
      ?< ->
        block
        |> Enum.map(&Enum.slide(&1, 0, @block_width - 1))
      ?v ->
        block
        |> Enum.slide(length(block) - 1, 0)
      _ ->
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
      case Integer.mod(idx, 3) do
        0 ->
          move_block(block, ?>)
        1 ->
          move_block(block, ?<)
        2 ->
          move_block(block, ?v)
        _ ->
          block
      end
    end)
    |> Enum.map(&__MODULE__.format_block/1)
    |> Enum.map(&IO.puts/1)
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
