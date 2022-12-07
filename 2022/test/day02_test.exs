defmodule AOCTest.Day02Test do
  use ExUnit.Case
  alias AOC.Day02, as: Day

  doctest Day

  @test Input.read!(02, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 15
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == 12
  end

  @input Input.read!(02, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 13675
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == 14184
  end
end
