defmodule AOC.Day11 do

  defmodule Monkey do
    defstruct name: nil,
              items: [],
              operation: nil,
              truthy: nil,
              falsy: nil
  end

  def parse_operand(operand, default \\ nil) do
    try do
      String.to_integer(operand)
    rescue
      _ in ArgumentError -> default
    end
  end

  def parse_operation(l_str, op_str, r_str) do
    l = parse_operand(l_str)
    r = parse_operand(r_str)
    fn value ->
      operands = [l, r] |> Enum.map(fn o -> if o == nil, do: value, else: o end)
      apply(String.to_existing_atom("Elixir.Kernel"), String.to_existing_atom(op_str), operands)
    end
  end

  def parse_monkey(monkey_input, {denominator, common_multiple}) do
    [_, items_str, op_str, test_str, truthy_str, falsy_str] = String.split(monkey_input, "\n")
    digits_pattern = ~r/\d+/
    items = Regex.scan(digits_pattern, items_str) |> List.flatten() |> Enum.map(&String.to_integer/1)
    operation_matches = Regex.scan(~r/new = (old|\d+) ([+*\/-]) (old|\d+)/, op_str) |> List.flatten()
    divisible_by = Regex.scan(digits_pattern, test_str) |> List.flatten() |> List.first() |> String.to_integer()
    truthy_idx = Regex.scan(digits_pattern, truthy_str) |> List.flatten() |> List.first() |> String.to_integer()
    falsy_idx = Regex.scan(digits_pattern, falsy_str) |> List.flatten() |> List.first() |> String.to_integer()

    [operation_str, l, op, r] = operation_matches
    operation = parse_operation(l, op, r)

    operation = cond do
      is_number(denominator) ->
        &(operation.(&1) |> Integer.floor_div(denominator))
      is_number(common_multiple) ->
        &(Integer.mod(&1, common_multiple)) |> operation.()
    end

    %{
      items: items,
      truthy_idx: truthy_idx,
      falsy_idx: falsy_idx,
      divisible_by: divisible_by,
      test: &(Integer.mod(&1, divisible_by) == 0),
      operation: operation,
      operation_str: operation_str,
      l: l,
      r: r,
      op: op,
      num_inspected_items: 0,
    }
  end

  def get_common_multiple(raw_input) do
    Regex.scan(~r/Test: divisible by (\d+)/, raw_input)
    |> Enum.map(fn l -> l |> List.last() |> String.to_integer() end)
    |> Enum.product()
  end

  def parse_input(raw_input, denominator \\ nil) do
    common_multiple = if denominator == nil do
      get_common_multiple(raw_input)
    else
      nil
    end

    raw_input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn monkey_input -> parse_monkey(monkey_input, {denominator, common_multiple}) end)
    |> Enum.with_index()
  end

  def take_turn(monkey_idx, monkeys) do
    {monkey, _} = Enum.at(monkeys, monkey_idx)

    # IO.puts("Monkey #{monkey_idx}: (#{Enum.join(monkey.items, ", ")})")

    inspected_items = Enum.map(monkey.items, fn item ->
      # IO.puts("  Monkey inspects an item with a worry level of #{item}.")
      # Integer.floor_div(monkey.operation.(item), 3)

      monkey.operation.(item)
      # |> then(fn l ->
      #   IO.puts("    Worry level #{monkey.op} by #{monkey.r} to #{l}.")
      #   l
      # end)
      # |> Integer.floor_div(3)
      # |> then(fn l ->
      #   IO.puts("    Monkey gets bored with item. Worry level is divided by 3 to to #{l}.")
      #   l
      # end)
    end)

    num_inspected_items = length(inspected_items)
    {truthy_items, falsy_items} = Enum.split_with(inspected_items, monkey.test)

    # IO.puts("#{inspect(monkey.items, charlists: :as_lists)} => #{inspect(inspected_items, charlists: :as_lists)} => #{inspect(truthy_items, charlists: :as_lists)} + #{inspect(falsy_items, charlists: :as_lists)}")

    0..(length(monkeys) - 1)
    |> Enum.reduce(monkeys, fn idx, acc ->
      {m, _} = Enum.at(acc, idx)
      cond do
        idx == monkey_idx ->
          Map.put(m, :items, [])
          |> Map.update(:num_inspected_items, num_inspected_items, fn i -> i + num_inspected_items end)
        idx == monkey.truthy_idx ->
          # truthy_items
          # |> Enum.map(fn i ->
          #   IO.puts("  Current worry level is divisible by #{monkey.divisible_by}.")
          #   IO.puts("  Item with worry level #{i} is thrown to monkey #{monkey.truthy_idx}.")
          # end)
          Map.update(m, :items, truthy_items, fn e -> e ++ truthy_items end)
        idx == monkey.falsy_idx ->
          # falsy_items
          # |> Enum.map(fn i ->
          #   IO.puts("  Current worry level is not divisible by #{monkey.divisible_by}.")
          #   IO.puts("  Item with worry level #{i} is thrown to monkey #{monkey.falsy_idx}.")
          # end)
          Map.update(m, :items, falsy_items, fn e -> e ++ falsy_items end)
        true ->
          m
      end
      |> then(fn next_monkey -> List.update_at(acc, idx, fn _ -> {next_monkey, idx} end) end)
    end)
  end

  def play_round(monkeys) do
    0..(length(monkeys) - 1)
    |> Enum.reduce(monkeys, &AOC.Day11.take_turn/2)
    # |> then(fn state ->
    #   state
    #   |> Enum.map(fn {monkey, idx} -> "Monkey #{idx}: #{Enum.join(monkey.items, ", ")}" end)
    #   |> then(fn s -> IO.puts(Enum.join(s, "\n")) end)
    #   state
    # end)
  end

  def play(monkeys, iterations) do
    1..iterations
    |> Enum.reduce(monkeys, fn _idx, acc ->
      # if idx in 1..10_000//1000 do
      #   IO.puts("== After round #{idx - 1} ==")
      #   print_inspections(acc)
      # end
      play_round(acc)
    end)
  end

  def count_item_inspections({monkey, idx}) do
    {monkey.num_inspected_items, idx}
  end

  def format_item_inspections({_, _} = monkey_and_index) do
    monkey_and_index
    |> count_item_inspections()
    |> then(fn {num_insections, idx} -> "Monkey #{idx} inspected items #{num_insections} times." end)
  end

  def print_inspections(monkeys) do
    monkeys
    |> Stream.map(&AOC.Day11.format_item_inspections/1)
    |> Enum.join("\n")
    |> then(fn s -> IO.puts(s) end)
  end

  def sum_most_active(monkeys, top_n) do
    # IO.puts("== Done ==")
    # print_inspections(monkeys)

    counts = monkeys
    |> Stream.map(&AOC.Day11.count_item_inspections/1)
    |> Enum.sort_by(fn {inspections, _} -> inspections end, :desc)
    |> Enum.take(top_n)

    {first, _} = List.first(counts)
    {last, _} = List.last(counts)
    first * last
  end

  def solve(raw_input, 1) do
    parse_input(raw_input, 3)
    |> play(20)
    |> sum_most_active(2)
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
    |> play(10_000)
    |> sum_most_active(2)
  end
end
