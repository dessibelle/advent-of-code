defmodule AOCTest.Day09Test do
  use ExUnit.Case
  alias AOC.Day09, as: Day

  doctest Day

  @test Input.read!(09, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 13
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == 1
  end

  @test2 Input.read!(09, "test2")

  test "Part 1 (example 2)" do
    assert Day.solve(@test2, 1) == 88
  end

  test "Part 2 (example 2)" do
    assert Day.solve(@test2, 2) == 36
  end

  @input Input.read!(09, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 6498
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == 2531
  end
end
