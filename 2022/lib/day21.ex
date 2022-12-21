defmodule AOC.Day21 do

  defmodule State do
    defstruct monkeys: %{}

    def add_monkey(state, monkey) do
      # next_monkeys = Map.put(state.monkey, monkey.id, monkey)
      struct!(state,
        monkeys: Map.put(state.monkeys, monkey.id, monkey)
      )
    end
  end

  defmodule Monkey do
    defstruct id: nil, value: nil, expression: nil, left_operand: nil, right_operand: nil

    def get_value(monkey, state) do
      # IO.puts("querying monkey #{monkey.id} for value")
      cond do
        monkey.value ->
          monkey.value
        monkey.expression ->
          l = Map.get(state.monkeys, monkey.left_operand)
          |> Monkey.get_value(state)
          r = Map.get(state.monkeys, monkey.right_operand)
          |> Monkey.get_value(state)

          monkey.expression.(l, r)
      end
    end
  end

  def parse_monkey(line) do
    ~r/(?P<id>\w+):\s+(?:(?P<value>\d+)|(?P<left_operand>\w+)\s+(?P<operator>[+*\/-])\s+(?P<right_operand>\w+))/
    |> Regex.named_captures(line)
    |> then(fn %{"id" => id, "left_operand" => left_operand, "operator" => operator, "right_operand" => right_operand, "value" => value} ->
      id = String.to_atom(id)
      value = if value == "", do: nil, else: String.to_integer(value)
      left_operand = if left_operand == "", do: nil, else: String.to_atom(left_operand)
      right_operand = if right_operand == "", do: nil, else: String.to_atom(right_operand)
      expr = fn l, r ->
        apply(String.to_existing_atom("Elixir.Kernel"), String.to_atom(operator), [l, r])
      end
      %Monkey{id: id, value: value, left_operand: left_operand, right_operand: right_operand, expression: expr}
    end)
  end

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&__MODULE__.parse_monkey/1)
    |> Enum.into(%{}, fn a -> {a.id, a} end)
    |> then(&(%State{monkeys: &1}))
  end

  def run(state) do
    state.monkeys.root
    |> Monkey.get_value(state)
    |> round()
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> run()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
