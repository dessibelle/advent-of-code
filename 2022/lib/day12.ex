defmodule AOC.Day12 do

  def init_state(matrix) do
    flat_grid = matrix |> List.flatten()

    flat_grid
    |> Enum.with_index()
    |> Enum.reduce(%{
      :grid => flat_grid,
      :height => length(matrix),
      :width => length(List.first(matrix, 0)),
      :moves => [],
      :shortest_path => flat_grid},
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
            target_idx: idx,
            grid: List.update_at(Map.get(acc, :grid), idx, fn _ -> ?z end),
          })
        true ->
          acc
      end
    end)
    |> then(fn %{grid: grid} = state ->
      indices_by_height = grid
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {value, idx}, acc ->
        Map.update(acc, value, MapSet.new([idx]), fn existing_values -> MapSet.put(existing_values, idx) end)
      end)
      Map.merge(state, %{indices_by_height: indices_by_height})
    end)
  end

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  def bfs_get_relative_indices(%{graph: graph, width: width, height: height}, pos) do
    num_items = length(graph)
    col_idx = Integer.mod(pos, width)

    %{
      up: (if pos >= width, do: pos - width, else: nil),
      right: (if col_idx != width - 1, do: pos + 1, else: nil),
      down: (if pos < (width * height - 1), do: pos + width, else: nil),
      left: (if col_idx != 0, do: pos - 1, else: nil),
    }
    |> Enum.filter(fn {_, idx} -> idx in 0..(num_items - 1) end)
    |> Enum.into(%{})
  end

  def bfs_get_neighbours(%{graph: graph, width: _, height: _} = grid, pos) do
    current_val = Enum.at(graph, pos)

    is_index_reachable? = fn {_, idx} ->
      candidate_val = Enum.at(graph, idx, 1000) # Fallback to prevent the height_diff calculation from choking
      height_diff = current_val - candidate_val
      height_diff >= -1
    end

    bfs_get_relative_indices(grid, pos)
    |> Enum.filter(is_index_reachable?)
  end


  def bfs_inner_reducer({_, neighbour}, %{queue: acc_q, explored: acc_e} = acc, node) do
    if neighbour not in acc_e do
      acc_e = MapSet.put(acc_e, neighbour)
      w = %{value: neighbour, parent: node}
      acc_q = :queue.in(w, acc_q)

      %{queue: acc_q, explored: acc_e}
    else
      acc
    end
  end

  def bfs_reducer(_, %{queue: q, explored: e}, %{target_idx: target_idx, grid: grid}) do
    {{:value, node}, q} = :queue.out(q)
    %{value: idx} = node

    if idx == target_idx do
      {:halt, node}
    else
      state = bfs_get_neighbours(grid, idx)
      |> Enum.reduce(%{queue: q, explored: e}, &(bfs_inner_reducer(&1, &2, node)))
      {:cont, state}
    end
  end

  def bfs(grid, root, target_idx) when is_number(root) do
    bfs(grid, %{value: root, parent: nil}, target_idx)
  end

  def bfs(%{graph: graph, width: _, height: _} = grid, root, target_idx) do
    %{value: root_idx} = root
    explored = MapSet.new([root_idx])
    queue = :queue.in(root, :queue.new())

    Enum.reduce_while(1..length(graph), %{queue: queue, explored: explored}, &(bfs_reducer(&1, &2, %{target_idx: target_idx, grid: grid})))
  end

  def collect_path(_, path \\ [])
  def collect_path(%{value: value, parent: nil}, path) do [value | path] end
  def collect_path(%{value: value, parent: parent}, path) do
    collect_path(parent, [value | path])
  end

  def run(%{grid: graph, width: width, height: height, start_idx: start_idx, target_idx: target_idx}) do
    bfs(%{graph: graph, width: width, height: height}, start_idx, target_idx)
    |> collect_path()
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> init_state()
    |> run()
    |> then(&(length(&1) - 1))
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
