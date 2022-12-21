defmodule AOC.Day21 do

  defmodule State do
    defstruct monkeys: %{}, yell_candidate: nil

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

    def get_value_p2(monkey, state) do
      # IO.puts("querying monkey #{monkey.id} for value")
      cond do
        monkey.value != nil ->
          case monkey.id do
            :humn ->
              # IO.puts("Attempting yell_candidate #{state.yell_candidate}")
              state.yell_candidate
            _ ->
              monkey.value
          end
        monkey.expression ->
          l = Map.get(state.monkeys, monkey.left_operand)
          |> Monkey.get_value_p2(state)
          r = Map.get(state.monkeys, monkey.right_operand)
          |> Monkey.get_value_p2(state)

          case monkey.id do
            :root ->
              {l == r, [l, r]}
            _ ->
              monkey.expression.(l, r)
          end
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

  def evaluate_yell_candidate(state, yell_candidate) do
    next_state = struct!(state, yell_candidate: yell_candidate)

    next_state.monkeys.root
    |> Monkey.get_value_p2(next_state)
  end

  def evaluate_yell_candidate_pair(state, {lower, upper}) do
    {_, [lower_value, lower_target]} = evaluate_yell_candidate(state, lower)
    {_, [upper_value, upper_target]} = evaluate_yell_candidate(state, upper)

    {{lower_value - lower_target}, {upper_target - upper_value}}
  end

  def get_candidate_pairs_and_midpoint(low, high) do
    midpoint = low + round((high - low) / 2)
    {[{low, midpoint}, {midpoint + 1, high}], midpoint}
  end

  def run_p2(state, max_iterations \\ 100) do
    1..max_iterations
    |> Enum.reduce_while({1, 3_500_000_000_000}, fn idx, {left_candidate, right_candidate} ->
      midpoint = left_candidate + round((right_candidate - left_candidate) / 2)

      {left_res, [left_value, target]} = evaluate_yell_candidate(state, left_candidate)
      {right_res, [right_value, _]} = evaluate_yell_candidate(state, right_candidate)

      left_diff = abs(target - left_value)
      right_diff = abs(target - right_value)

      # IO.puts("left: #{left_diff} (#{left_value}), right: #{right_diff} (#{right_value})")

      next_pair = if left_diff < right_diff do
        next_right = midpoint
         {left_candidate + 1, next_right}
      else
        next_left = midpoint
        {next_left, right_candidate - 1}
      end

      cond do
        left_res == true ->
          {:halt, left_candidate}
        right_res == true ->
          {:halt, right_candidate}
        true ->
          if idx == max_iterations do
            {:cont, {:err, "Number not found in #{max_iterations} iterations"}}
          else
            {:cont, next_pair}
          end
      end
    end)

  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> run()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
    |> run_p2()
  end
end
