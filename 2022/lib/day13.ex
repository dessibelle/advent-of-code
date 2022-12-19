defmodule AOC.Day13 do

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reject(&(String.length(&1) == 0))
    |> Enum.map(fn s -> Code.eval_string(s) |> elem(0) end)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [i1, i2] -> {i1, i2} end)
  end

  def padded_lists(short, long, padding \\ nil) do
    {short ++ (1..(length(long) - length(short))//1 |> Enum.map(fn _ -> padding end)), long}
  end

  def ordered_pair?({l1, l2}) when is_number(l1) and is_number(l2) do
    {l1, l2}
  end

  def ordered_pair?({l1, l2}) when is_number(l1) and is_list(l2) do
    ordered_pair?({[l1], l2})
  end

  def ordered_pair?({l1, l2}) when is_list(l1) and is_number(l2) do
    ordered_pair?({l1, [l2]})
  end

  def ordered_pair?({l1, l2}) when l1 == nil and l2 != nil do
    {l1, l2}
  end

  def ordered_pair?({l1, l2}) when l1 != nil and l2 == nil do
    {l1, l2}
  end

  def ordered_pair?({l1, l2}) when is_list(l1) and is_list(l2) do
    left_len = length(l1)
    right_len = length(l2)
    cond do
      left_len == 0 and right_len == 0 ->
        {-1, -1}
      left_len == 0 and right_len > 0 ->
        {0, right_len}
      left_len > 0 and right_len == 0 ->
        {left_len, 0}
      left_len < right_len ->
        {l, r} = padded_lists(l1, l2)
        ordered_pair?({l, r})
      right_len < left_len ->
        {r, l} = padded_lists(l2, l1)
        ordered_pair?({l, r})
      true ->
        Enum.zip(l1, l2)
        |> Enum.reduce_while([], fn pair, acc ->
          if length(acc) == 0 or acc |> hd |> then(&(elem(&1, 0) == elem(&1, 1))) do
            {:cont, [ordered_pair?(pair) | acc]}
          else
            {:halt, acc}
          end
        end)
        |> List.first()
    end
  end

  def correctly_ordered?(pair) do
    {left, right} = ordered_pair?(pair)
    cond do
      right == left ->
        true
      left == nil ->
        true
      right == nil ->
        false
      true ->
        left < right
    end
  end

  def sorter(l1, l2) do
    correctly_ordered?({l1, l2})
  end

  def solve(raw_input, 1) do
    parse_input(raw_input)
    |> Enum.map(&__MODULE__.ordered_pair?/1)
    |> Enum.with_index(1)
    |> Enum.filter(fn {pair, _} -> correctly_ordered?(pair) end)
    |> Enum.map(fn {_, idx} -> idx end)
    |> Enum.sum()
  end

  def solve(raw_input, 2) do
    divider_packets = [[[2]], [[6]]]
    parse_input(raw_input)
    |> Enum.unzip()
    |> then(fn {l1, l2} -> l1 ++ l2 ++ divider_packets end)
    |> Enum.sort(&__MODULE__.sorter/2)
    |> Enum.with_index(1)
    |> Enum.filter(fn {l, _} -> l in divider_packets end)
    |> Enum.map(fn {_, idx} -> idx end)
    |> Enum.product()
  end
end
