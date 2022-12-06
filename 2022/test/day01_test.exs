defmodule AOCTest.Day01Test do
  use ExUnit.Case
  alias AOC.Day01, as: Day

  doctest Day

  @input Input.read!(01, "test")

  test "Part 1" do
    assert Day.solve(@input, 1) == 24000
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == 45000
  end
end
