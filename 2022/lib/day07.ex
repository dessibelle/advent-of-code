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
        [delta | pwd] # NOTE: stack is reversed because of linked lists being efficient that way
    end
  end

  def prepend(str, prepend), do: "#{prepend}#{str}"
  def format_pwd(pwd) do
    pwd
    |> Enum.reverse()
    |> Enum.join("/")
    |> prepend("/")
  end

  def dir_paths_for_pwd(pwd) do
    format_pwd(pwd)
  end

  def increment_dir_size(tree, pwd, file_size) do
    0..length(pwd)
    |> Enum.reduce(tree, fn idx, acc ->
      Map.update(acc, format_pwd(Enum.take(pwd, idx * -1)), file_size, &(&1 + file_size))
    end)
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
          {increment_dir_size(tree, pwd, file_size), pwd}
        true ->
          {tree, pwd}
      end
    end)
  end

  def find_dir_to_delete(tree) do
    free_space = 70000000 - Map.get(tree, "/")
    threshold = 30000000
    tree
    |> Map.filter(fn {_path, size} -> free_space + size >= threshold end)
    |> Map.values()
    |> Enum.min()
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> process_input()
    |> elem(0)
    |> Map.filter(fn {_path, size} -> size <= 100000 end)
    |> Map.values()
    |> Enum.sum()
  end

  def solve(raw_input, 2) do
    parse_input(raw_input)
    |> process_input()
    |> elem(0)
    |> find_dir_to_delete()
  end
end
