defmodule AOC.Day12 do

  def init_state(matrix) do
    flat_grid = matrix |> List.flatten()
    flat_grid
    |> Enum.with_index()
    |> Enum.reduce(%{
      :grid => flat_grid,
      :height => length(matrix),
      :width => length(List.first(matrix, 0)),
      :moves => []},
      fn indexed_item, acc ->
      {value, idx} = indexed_item
      cond do
        value == ?S ->
          Map.merge(acc, %{
            start_idx: idx,
            path: [idx],
            grid: List.update_at(Map.get(acc, :grid), idx, fn _ -> ?a end),
          })
        value == ?E ->
          Map.merge(acc, %{
            end_idx: idx,
            grid: List.update_at(Map.get(acc, :grid), idx, fn _ -> ?z end),
          })
        true ->
          acc
      end
    end)
  end

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  def get_relative_indices(%{path: path, width: w}) do
    pos = path |> hd
    %{
      right: pos + 1,
      left: pos - 1,
      up: pos - w,
      down: pos + w,
    }
  end

  def possible_moves(%{grid: grid, path: path} = state) do
    pos = path |> hd
    current_val = Enum.at(grid, pos)
    num_items = length(grid)

    is_index_reachable? = fn {_, idx} ->
      in_bounds = idx in 0..(num_items - 1)
      candidate_val = Enum.at(grid, idx, 1000) # Fallback to prevent the height_diff calculation from choking
      height_diff = current_val - candidate_val
      in_bounds && height_diff >= -1 && idx not in path
    end

    get_relative_indices(state)
    |> Enum.filter(is_index_reachable?)
    |> Enum.into(%{})
  end

  def move_to_index(%{path: path, moves: moves} = state, {direction, next_pos}) do
    direction_char = fn
      :right -> ?>
      :left -> ?<
      :up -> ?^
      :down -> ?v
    end

    Map.merge(state, %{
      :path => [next_pos | path],
      :moves => [direction_char.(direction) | moves],
    })
  end

  def at_destination?(%{path: path, end_idx: end_idx}) do
    current_idx = path |> hd
    current_idx == end_idx
  end

  def find_best_path(%{moves: moves} = state) do
    if at_destination?(state) do
      {moves |> Enum.reverse()}
    else
      state
      |> possible_moves()
      |> Enum.map(fn {_direction, _idx} = move ->
        state
        |> move_to_index(move)
        |> find_best_path()
      end)
    end
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> init_state()
    |> find_best_path()
    |> List.flatten()
    |> Enum.filter(fn s -> s != nil end)
    |> Enum.map(&(elem(&1, 0)) |> length)
    |> Enum.min()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
