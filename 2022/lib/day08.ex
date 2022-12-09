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
    last = length(row) - 1
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

  defp scenic_score_reducer({value, idx}, threshold, indices) do
    if (value < threshold) do
      {:cont, MapSet.put(indices, {value, idx})}
    else
      {:halt, MapSet.put(indices, {value, idx})}
    end
  end

  def scenic_score(grid, tree_idx, width) do
    row_idx = div(tree_idx, width)
    col_idx = rem(tree_idx, width)

    cond do
      tree_idx < width || tree_idx >= length(grid) - width || col_idx == 0 || col_idx == width - 1 ->
        0 # Everything at the edge is 0 (plus this helps avoid some issues with Enum.chunk_by below :D)
      true ->
        value_at_coord = elem(Enum.at(grid, tree_idx), 0)

        row = grid |> Enum.filter(fn {_, i} -> i >= row_idx * width && i < (row_idx + 1) * width  end)
        col = grid |> Enum.filter(fn {_, i} -> Integer.mod(i, width) == col_idx end)

        [left_chunk, _, right_chunk] = row
        |> Enum.chunk_by(fn {_, i} -> i == tree_idx end)

        [top_chunk, _, bottom_chunk] = col
        |> Enum.chunk_by(fn {_, i} -> i == tree_idx end)

        score_reducer = fn {value, idx}, acc ->
          scenic_score_reducer({value, idx}, value_at_coord, acc)
        end

        [
          left_chunk |> Enum.reverse() |> Enum.reduce_while(MapSet.new(), score_reducer),
          right_chunk |> Enum.reduce_while(MapSet.new(), score_reducer),
          top_chunk |> Enum.reverse() |> Enum.reduce_while(MapSet.new(), score_reducer),
          bottom_chunk |> Enum.reduce_while(MapSet.new(), score_reducer),
        ]
        |> Enum.map(&MapSet.size/1)
        |> Enum.product()
    end
  end

  def scenic_scores(grid) do
    grid_width = length(List.first(grid))

    flat_grid = grid
    |> List.flatten()
    |> Enum.with_index()

    flat_grid
    |> Enum.map(fn {_, idx} -> scenic_score(flat_grid, idx, grid_width) end)
  end

  def visible_in_grid?(grid) do
    # TODO: Flat list is probably (possibly?) simpler...
    ltr = Enum.map(grid, fn row -> visible_on_row?(row, 1) end)
    # rtl = Enum.map(grid, fn row -> visible_on_row?(row, -1) end)
    rtl = Enum.map(grid, fn row -> visible_on_row?(row |> Enum.reverse(), 1) |> Enum.reverse() end)

    translated_grid = transpose(grid)
    ttb = Enum.map(translated_grid, fn row -> visible_on_row?(row, 1) end) |> transpose()
    # btt = Enum.map(translated_grid, fn row -> visible_on_row?(row, -1) end) |> transpose()
    btt = Enum.map(translated_grid, fn row -> visible_on_row?(row |> Enum.reverse(), 1) end) |> transpose() |> Enum.reverse()

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
    # |> Enum.chunk_every(length(Enum.at(grid, 0))) # for rendering resulting grid
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> visible_in_grid?()
    |> Enum.filter(&(&1 != nil))
    |> Enum.count()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
    |> scenic_scores()
    |> Enum.max()
  end
end
