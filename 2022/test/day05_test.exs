defmodule AOCTest.Day05Test do
  use ExUnit.Case
  alias AOC.Day05, as: Day

  doctest Day

  @input Input.read!(05, "test")

  test "Part 1" do
    assert Day.solve(@input, 1) == "CMZ"
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == ""
  end
end
