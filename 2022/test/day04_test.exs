defmodule AOCTest.Day04Test do
  use ExUnit.Case
  alias AOC.Day04, as: Day

  doctest Day

  @test Input.read!(04, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 2
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == 4
  end

  @input Input.read!(04, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 582
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == 893
  end
end
