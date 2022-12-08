defmodule AOC.Day08 do

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn r ->
      String.to_charlist(r)
      |> Enum.map(&(&1 - ?0))
    end)
  end

  def get_range(row, step) do
    first = 1
    last = length(row) - 2
    cond do
      step > 0 ->
        first..last//step
      step < 0 ->
        last..first//step
    end
  end

  def visible_on_row?(row, step \\ 1) do
    get_range(row, step)
    |> Enum.reduce(row, fn idx, acc ->
      # TODO: This needs to consider all neihghbours, all the way to the edge, not just prev
      # IEx.Helpers.recompile() &&  Input.read!(8, "test") |> AOC.Day08.parse_input() |> AOC.Day08.transpose() |> Enum.at(3) |> AOC.Day08.visible_on_row?()
      max_val = row
      |> Enum.slice(0, idx)
      |> Enum.max()

      # prev = Enum.at(row, idx - step)
      this = Enum.at(row, idx)
      if this <= max_val do
        List.update_at(acc, idx, fn _ -> nil end)
      else
        acc
      end
    end)
  end

  def transpose(rows) do
    rows
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
  end

  def visible_in_grid?(grid) do
    ltr = Enum.map(grid, fn row -> visible_on_row?(row, 1) end)
    # rtl = Enum.map(grid, fn row -> visible_on_row?(row, -1) end)
    rtl = Enum.map(grid, fn row -> visible_on_row?(row |> Enum.reverse(), 1) end)

    translated_grid = transpose(grid)
    ttb = Enum.map(translated_grid, fn row -> visible_on_row?(row, 1) end) |> transpose()
    # btt = Enum.map(translated_grid, fn row -> visible_on_row?(row, -1) end) |> transpose()
    btt = Enum.map(translated_grid, fn row -> visible_on_row?(row |> Enum.reverse(), 1) end) |> transpose()

    [ltr, rtl, ttb, btt]
    |> Enum.map(&List.flatten/1)
    |> List.zip()
    |> Enum.map(fn cell ->
      cell
      |> Tuple.to_list()
      |> Enum.filter(&(&1 != nil))
      |> Enum.uniq()
      |> List.first()
    end)
    # |> Enum.chunk_every(length(Enum.at(grid, 0)))
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> visible_in_grid?()
    |> Enum.filter(&(&1 != nil))
    |> Enum.count()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
