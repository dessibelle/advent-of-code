defmodule AOC.Day07 do

  def parse_line(raw_line) do
    parts = String.split(raw_line)
    if List.first(parts) == "$" do
      {:command, Enum.drop(parts, 1) }
    else
      {:output, parts}
    end
  end

  def parse_input(raw_input) do
    String.split(raw_input, "\n")
    |> Enum.map(&AOC.Day07.parse_line/1)
  end

  def cd(pwd, delta) do
    cond do
      String.at(delta, 0) == "/" ->
        "/"
      delta == ".." ->
        pwd
        |> String.split("/")
        |> Enum.drop(-1)
        |> Enum.join("/")
      pwd == "/" ->
        "#{pwd}#{delta}"
      true ->
        "#{pwd}/#{delta}"
    end
  end

  def process_input(input) do
    input
    |> Enum.reduce({%{}, "/"}, fn {type, data}, {tree, pwd} ->
      if type == :command && List.first(data) == "cd" do
        {tree, cd(pwd, Enum.at(data, 1))}
      else
        {tree, pwd}
      end
    end)
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> process_input()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end