defmodule AOC.Day19 do

  def parse_line(line) do
    ~r/Each ore robot costs (?P<ore_ore>\d+) ore. Each clay robot costs (?P<clay_ore>\d+) ore. Each obsidian robot costs (?P<obsidian_ore>\d+) ore and (?P<obsidian_clay>\d+) clay. Each geode robot costs (?P<geode_ore>\d+) ore and (?P<geode_obsidian>\d+) obsidian./
    |> Regex.named_captures(line)
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      [target, material] = String.split(k, "_")
      value = Map.put(%{}, String.to_atom(material), String.to_integer(v))
      Map.update(acc, String.to_atom(target), value, fn e -> Map.merge(e, value) end)
    end)
  end

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&__MODULE__.parse_line/1)
    |> Enum.with_index(1)
  end

  # def charge(%{materials: materials, robots: robots} = state, cost, robot_type) do
  #   can_afford = Enum.reduce(cost, true, fn {material, price}, acc ->
  #     # IO.inspect([Map.get(materials, material, 0), price])
  #     acc && Map.get(materials, material, 0) >= price
  #   end)

  #   # IO.puts("Can afford #{robot_type} robot: #{can_afford} (#{inspect(materials)} vs. #{inspect(cost)})")

  #   if can_afford do
  #     # IO.puts("Can afford #{robot_type} robot: (#{inspect(materials)} vs. #{inspect(cost)})")
  #     next_materials = Enum.reduce(cost, materials, fn {material, price}, acc_materials ->
  #       IO.puts("Spend 2 ore to start building a clay-collecting robot.")
  #       Map.update(acc_materials, material, -price, &(&1 - price))
  #     end)
  #     next_robots = Map.update(robots, robot_type, 1, &(&1 + 1))
  #     %{materials: next_materials, robots: next_robots}
  #   else
  #     state
  #   end
  # end

  def can_afford?(materials, cost) do
    Enum.reduce(cost, true, fn {material, price}, acc ->
      acc && Map.get(materials, material, 0) >= price
    end)
  end

  def charge(%{materials: materials, robots: robots}, robot_type, cost) do
    next_materials = Enum.reduce(cost, materials, fn {material, price}, acc_materials ->
      IO.puts("Spend #{price} #{material} to start building a #{robot_type}-collecting robot.")
      Map.update(acc_materials, material, -price, &(&1 - price))
    end)
    next_robots = Map.update(robots, robot_type, 1, &(&1 + 1))
    %{materials: next_materials, robots: next_robots}
  end

  def reachable_in_step?(%{materials: materials, robots: robots}, cost, counter \\ 1) do
    next_materials = Map.merge(materials, robots, fn _k, v1, v2 ->
      v1 + v2
    end)
    if counter <= 1 do
      next_materials
      |> can_afford?(cost)
    else
      reachable_in_step?(%{materials: next_materials, robots: robots}, cost, counter - 1)
    end

  end

  def prioritized?(%{blueprint: blueprint, materials: materials, robots: robots}, robot_type) when robot_type in [:clay, :ore, :obsidian] do
    obsidian_cost = Map.get(blueprint, :obsidian)
    geode_cost = Map.get(blueprint, :geode)

    cond do
      reachable_in_step?(%{materials: materials, robots: robots}, geode_cost, 1) ->
        false
      robot_type != :obsidian and reachable_in_step?(%{materials: materials, robots: robots}, obsidian_cost, 2) ->
        false
      true -> true
    end
  end
  def prioritized?(_, _), do: true

  # def prioritized?(robots, robot_type) do
  #   min_num = Map.values(robots) |> Enum.min()
  #   existing = Map.get(robots, robot_type, 0)
  #   diff = existing - min_num # abs(existing - min_num)
  #   threshold = 3
  #   # IO.puts("prioritized? #{robot_type}: currently #{existing} vs. #{min_num} => #{diff} < #{threshold} = #{diff < threshold}")
  #   diff < threshold
  # end

  def buy_robots(blueprint, %{materials: materials, robots: robots} = state) do
    material_keys = [:geode, :obsidian, :clay, :ore]
    all_robots = material_keys
    |> Enum.zip(Enum.map(material_keys, fn _ -> 0 end))
    |> Map.new()
    |> Map.merge(robots)

    first_affordable = material_keys
    |> Enum.filter(fn robot_type -> prioritized?(%{blueprint: blueprint, materials: materials, robots: all_robots}, robot_type) end)
    |> Enum.filter(fn robot_type -> can_afford?(materials, blueprint[robot_type]) end)
    |> List.first()

    if first_affordable != nil do
      cost = blueprint[first_affordable]
      charge(state, first_affordable, cost)
    else
      state
    end
  end


  def collect_materials(%{materials: _, robots: robots} = state) do
    # next_materials = Map.update(materials, :ore, 1, fn e -> e + 1 end)
    Enum.reduce(robots, state, fn {robot_type, num_robots}, %{materials: acc_materials, robots: r} ->
      next_amount = Map.get(acc_materials, robot_type, 0) + num_robots
      IO.puts("#{num_robots} #{robot_type}-collecting robot collects #{num_robots} #{robot_type}; you now have #{next_amount} #{robot_type}.")
      %{materials: Map.put(acc_materials, robot_type, next_amount), robots: r}
    end)
  end

  def turn(blueprint, %{materials: materials, robots: robots} = state, idx) do
    IO.puts("== Minute #{idx} ==")
    # # spend
    %{materials: next_materials, robots: next_robots} = buy_robots(blueprint, state)
    # # collect materials
    %{materials: next_materials} = collect_materials(%{materials: next_materials, robots: robots})
    # # update materials + robots
    # IO.inspect(next_materials)
    # IO.inspect(next_robots)

    Enum.each(next_robots, fn {k, v} ->
      prev = Map.get(robots, k, 0)
      if prev != v do
        IO.puts("The new #{k}-collecting robot is ready; you now have #{v} of them.")
      end
    end)

    IO.puts("")
    %{materials: next_materials, robots: next_robots}
  end

  def apply_blueprint({blueprint, bidx}, initial_state, range \\ 1..24) do
    IO.puts("== Blueprint #{bidx} ==")
    range
    |> Enum.scan(initial_state, &turn(blueprint, &2, &1))
    |> then(fn state -> {state, bidx} end)
  end

  def score({state, blueprint_index}) do
    state
    |> List.last()
    |> then(fn %{materials: materials} ->
      num_geodes = Map.get(materials, :geode, 0)
      r = num_geodes * blueprint_index
      IO.puts("Blueprint #{blueprint_index} can open #{num_geodes} geodes => #{r}")
      r
    end)
  end

  def solve(raw_input, 1) do
    initial_state = %{robots: %{ore: 1}, materials: %{}}

    parse_input(raw_input)
    |> Enum.map(&apply_blueprint(&1, initial_state))
    |> Enum.map(&__MODULE__.score/1)
    |> Enum.with_index(1)
    |> Enum.map(fn {score, idx} -> score * idx end)
    |> Enum.sum()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
    |> inspect()
  end
end
