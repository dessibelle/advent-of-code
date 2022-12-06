defmodule AOCTest.Day00Test do
  use ExUnit.Case
  alias AOC.Day00, as: Day

  doctest Day

  @input Input.read!(00, "test")

  test "Part 1" do
    assert Day.solve(@input, 1) == -1
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == -1
  end
end
