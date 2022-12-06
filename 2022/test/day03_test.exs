defmodule AOCTest.Day03Test do
  use ExUnit.Case
  alias AOC.Day03, as: Day

  doctest Day

  @input Input.read!(03, "test")

  test "Part 1" do
    assert Day.solve(@input, 1) == 157
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == 70
  end
end
