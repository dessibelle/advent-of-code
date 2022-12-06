defmodule AOC.Day05 do

  def parse_row(raw_row, size) do
    Range.new(0, size - 1)
    |> Enum.to_list()
    |> Enum.map(fn idx ->
      pos = idx + 1 + 3 * idx
      val = String.at(raw_row, pos)
      if val == " ", do: nil, else: val
    end)
  end

  def extract_rows(raw_stacks) do
    {index, rows} = String.split(raw_stacks, "\n")
    |> List.pop_at(-1)

    size = index
    |> String.at( -2)
    |> String.to_integer()

    data = rows
    |> Enum.reverse()
    |> Enum.map(fn row -> AOC.Day05.parse_row(row, size) end)

    {data, size}
  end

  def parse_stacks(raw_stacks) do
    {rows, size} = extract_rows(raw_stacks)

    Range.new(0, size - 1)
    |> Enum.to_list()
    |> Enum.map(fn idx ->
      Enum.map(rows, fn row -> Enum.at(row, idx) end)
      |> Enum.filter(fn
        nil -> false
        _ -> true
      end)
    end)
  end

  # TODO: adjust from/to for zero-indexed lists
  def parse_operation(raw_operation) do
    matches = Regex.named_captures(~r/move (?<amount>\d+) from (?<from>\d+) to (?<to>\d+)/, raw_operation)
    for {key, val} <- matches, into: %{}, do: {String.to_atom(key), String.to_integer(val)}
  end

  def parse_operations(raw_operations) do
    raw_operations
    |> String.split("\n")
    |> Enum.map(&AOC.Day05.parse_operation/1)
  end

  def parse_input(raw_input) do
    {raw_stacks, raw_operations} = raw_input
    |> String.trim("\n")
    |> String.split("\n\n")
    |> List.to_tuple()

    stacks = parse_stacks(raw_stacks)
    operations = parse_operations(raw_operations)

    {stacks, operations}
  end

  def apply_operation(stacks, %{:amount => amount, :from => from, :to => to}) do
    cond do
      from == to -> stacks
      true ->
        # TODO: This could be reflected in parse_operation instead
        from_idx = from - 1
        to_idx = to - 1
        {from_stack, moved_items} = stacks
        |> Enum.at(from - 1)
        |> Enum.split(amount * -1)

        to_stack = stacks
        |> Enum.at(to - 1)
        |> Enum.concat(moved_items |> Enum.reverse())

        List.replace_at(stacks, from_idx, from_stack)
        |> List.replace_at(to_idx, to_stack)
    end
  end

  def apply_operations({stacks, operations}) do
    Enum.reduce(operations, stacks, fn operation, acc ->
      AOC.Day05.apply_operation(acc, operation)
    end)
  end

  def top_level_items(stacks) do
    stacks
    |> Enum.map(fn stack -> List.last(stack, nil) end)
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> apply_operations()
    |> top_level_items()
    |> Enum.join("")
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
