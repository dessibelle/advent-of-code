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
      monkey.expression.({monkey, state})
    end
  end

  def parse_monkey(line) do
    ~r/(?P<id>\w+):\s+(?:(?P<value>\d+)|(?P<left_operand>\w+)\s+(?P<operator>[+*\/-])\s+(?P<right_operand>\w+))/
    |> Regex.named_captures(line)
    |> then(fn %{"id" => id, "left_operand" => left_operand, "operator" => operator, "right_operand" => right_operand, "value" => value} ->
      id = String.to_atom(id)

      cond do
        value != "" ->
          intval = String.to_integer(value)
          %Monkey{id: id, value: intval, expression: fn {_, _} -> intval end}
        left_operand != "" && operator != "" && right_operand != "" ->
          left_operand = String.to_atom(left_operand)
          right_operand = String.to_atom(right_operand)

          expr = fn {_, state} ->
            # IO.puts("    expr for #{monkey.id}, looking at monkeys #{left_operand} and #{right_operand}")
            lm = Map.get(state.monkeys, left_operand)
            rm = Map.get(state.monkeys, right_operand)
            l = Monkey.get_value(lm, state)
            r = Monkey.get_value(rm, state)

            apply(String.to_existing_atom("Elixir.Kernel"), String.to_atom(operator), [l, r])
          end
          %Monkey{id: id, value: nil, expression: expr}
      end
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
