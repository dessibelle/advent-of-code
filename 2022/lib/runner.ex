defmodule AOC.Runner do

  def format_usecs(u_secs) do
    cond do
      u_secs < 1_000 ->
        "#{u_secs} µs"
      u_secs < 1_000_000 ->
        "#{round(u_secs / 1_000)} ms"
      true ->
        "#{round(u_secs / 1_000_000)} s"
    end
  end

  def run!(day) do
    module_path = "Elixir.AOC.Day#{Helpers.pad_leading(day)}"
    IO.puts("== #{module_path} ==")
    for mode <- ["test", "input"] do
      input = Input.read!(day, mode)
      for part <- 1..2 do
        {u_secs, solution} = :timer.tc(String.to_existing_atom(module_path), :solve, [input, part])
        IO.puts("#{mode} pt. #{part}: #{solution} (#{format_usecs(u_secs)})")
      end
    end
    IO.puts("")
  end
end
