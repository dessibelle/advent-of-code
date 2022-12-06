defmodule Input do
  def read!(day, mode \\ "input") do
    day = Helpers.pad_leading(day)
    File.read!("./input/#{day}/#{mode}")
  end
end
