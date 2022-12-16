defmodule AOCTest.Day13Test do
  use ExUnit.Case
  alias AOC.Day13, as: Day

  doctest Day

  @test Input.read!(13, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 13
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == -1
  end

  @input Input.read!(13, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 6240
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == -1
  end
end
