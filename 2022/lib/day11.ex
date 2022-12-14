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

  def parse_monkey(monkey_input) do
    [_, items_str, op_str, test_str, truthy_str, falsy_str] = String.split(monkey_input, "\n")
    digits_pattern = ~r/\d+/
    items = Regex.scan(digits_pattern, items_str) |> List.flatten() |> Enum.map(&String.to_integer/1)
    operation_matches = Regex.scan(~r/new = (old|\d+) ([+*\/-]) (old|\d+)/, op_str) |> List.flatten()
    divisible_by = Regex.scan(digits_pattern, test_str) |> List.flatten() |> List.first() |> String.to_integer()
    truthy_val = Regex.scan(digits_pattern, truthy_str) |> List.flatten() |> List.first() |> String.to_integer()
    falsy_val = Regex.scan(digits_pattern, falsy_str) |> List.flatten() |> List.first() |> String.to_integer()

    [operation_str, l, op, r] = operation_matches
    operation = parse_operation(l, op, r)

    %{
      items: items,
      truthy_val: truthy_val,
      falsy_val: falsy_val,
      divisible_by: divisible_by,
      test: &(Integer.mod(&1, divisible_by) == 0),
      operation_str: operation_str,
      operation: operation,
      l: l,
      r: r,
    }
  end

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&AOC.Day11.parse_monkey/1)
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
