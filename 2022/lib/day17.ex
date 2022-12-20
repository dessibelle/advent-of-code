defmodule AOC.Day17 do

  @blocks [
    [
      [?., ?., ?@, ?@, ?@, ?., ?.],
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

  @empty_row [[?., ?., ?., ?., ?., ?., ?.]]

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

  def format_block(block) do
    block
    |> Enum.map(fn l -> "|" <> List.to_string(l) <> "|" end)
    |> Enum.join("\n")
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)

    1..24
    |> Enum.map(&__MODULE__.get_block/1)
    |> Enum.map(&__MODULE__.format_block/1)
    |> Enum.map(&IO.puts/1)
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
