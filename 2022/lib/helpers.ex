defmodule Helpers do
  def pad_leading(value, num_pad \\ 2, pad_char \\ "0") do
    value
    |> to_string()
    |> String.pad_leading(num_pad, pad_char)
  end
end
