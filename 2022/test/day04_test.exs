defmodule AOCTest.Day04Test do
  use ExUnit.Case
  alias AOC.Day04, as: Day

  doctest Day

  @input Input.read!(04, "test")

  test "Part 1" do
    assert Day.solve(@input, 1) == 2
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == 4
  end
end
