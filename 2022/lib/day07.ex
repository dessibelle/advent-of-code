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
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&AOC.Day07.parse_line/1)
  end

  def cd(pwd, delta) do
    cond do
      delta == "/" ->
        []
      delta == ".." ->
        pwd |> tl
      true ->
        [delta | pwd]
    end
  end

  def prepend(str, prepend), do: "#{prepend}#{str}"
  def format_pwd(pwd) do
    pwd
    |> Enum.reverse()
    |> Enum.join("/")
    |> prepend("/")
  end

  def process_input(input) do
    input
    |> Enum.reduce({%{}, []}, fn {type, data}, {tree, pwd} ->
      cond do
        type == :command && List.first(data) == "cd" ->
          {tree, cd(pwd, Enum.at(data, 1))}
        type == :output && List.first(data) != "dir" ->
          file_size = data
            |> List.first()
            |> String.to_integer()
          {Map.update(tree, format_pwd(pwd), file_size, &(&1 + file_size)), pwd}
        true ->
          {tree, pwd}
      end
    end)
  end

  def filter_dirs({tree, _}, filter_fn) do
    tree
    |> Map.filter(filter_fn)
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> process_input()
    |> filter_dirs(fn {_path, size} -> size <= 100000 end)
    |> Map.values()
    |> Enum.sum()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
  end
end
