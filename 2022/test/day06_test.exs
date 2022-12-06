defmodule AOCTest.Day06Test do
  use ExUnit.Case
  alias AOC.Day06, as: Day

  doctest Day

  @input Input.read!(06, "test")

  test "Part 1" do
    assert Day.solve(@input, 1) == -1
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == -1
  end
end
