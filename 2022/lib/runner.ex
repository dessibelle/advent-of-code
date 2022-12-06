defmodule AOC.Runner do
  def run!(day) do
    module_path = "Elixir.AOC.Day#{Helpers.pad_leading(day)}"
    for mode <- ["test", "input"] do
      input = Input.read!(day, mode)
      for part <- 1..2 do
        solution = apply(String.to_existing_atom(module_path), :solve, [input, part])
        IO.puts("#{mode} pt. #{part}: #{solution}")
      end
    end
  end
end
