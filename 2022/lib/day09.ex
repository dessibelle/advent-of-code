defmodule AOC.Day09 do

  @all_offsets [
    {-1, -1}, {0, -1}, {1, -1},
    {-1,  0}, {0,  0}, {1,  0},
    {-1,  1}, {0,  1}, {1,  1},
  ]

  @valid_position_offsets [
              {0, -1},
    {-1,  0}, {0,  0}, {1,  0},
              {0,  1}
  ]

  def parse_command([direction_str, distance_str]) do
    movement = (fn d ->
      cond do
        d == "U" -> {0, 1}
        d == "R" -> {1, 0}
        d == "D" -> {0, -1}
        d == "L" -> {-1, 0}
      end
    end).(direction_str)
    distance = String.to_integer(distance_str)

    for _ <- 1..distance, do: movement
  end


  def parse_input(raw_input) do
    raw_input
    |> String.split()
    |> Enum.chunk_every(2)
    |> Enum.map(&AOC.Day09.parse_command/1)
    |> List.flatten()
  end

  def add_coords({ x1, y1 }, { x2, y2 }), do: { x1 + x2, y1 + y2}

  def surrounding_coordinates(cell, offsets) do
    MapSet.new(Enum.map(offsets, fn offset -> add_coords(cell, offset) end))
  end

  def in_vicinity?(head, tail) do
    surrounding_coordinates(head, @all_offsets)
    |> MapSet.member?(tail)
  end

  def next_tail_position(head, tail) do
    if !in_vicinity?(head, tail) do
      valid_cells = surrounding_coordinates(head, @valid_position_offsets)
      reachable_cells = surrounding_coordinates(tail, @all_offsets)
      MapSet.intersection(valid_cells, reachable_cells)
      |> MapSet.to_list()
      |> List.first()
    else
      tail
    end
  end

  def apply_movement(movement, %{head: head, tail: tail, visited_positions: visited_positions}) do
    next_head = add_coords(head, movement)
    next_tail = next_tail_position(next_head, tail)

    %{
      head: next_head,
      tail: next_tail,
      visited_positions: MapSet.put(visited_positions, next_tail),
    }
  end

  def apply_movements(movements) do
    movements
    |> Enum.reduce(%{
      head: {0, 0},
      tail: {0, 0},
      visited_positions: MapSet.new(),
    }, &AOC.Day09.apply_movement/2)
  end

  def get_score(%{visited_positions: visited_positions}) do
    visited_positions
    |> MapSet.size()
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> apply_movements
    |> get_score()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
