defmodule AOCTest.Day02Test do
  use ExUnit.Case
  alias AOC.Day02, as: Day

  doctest Day

  @input Input.read!(02, "test")

  test "Part 1" do
    assert Day.solve(@input, 1) == 15
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == 12
  end
end
