defmodule AOCTest.Day18Test do
  use ExUnit.Case
  alias AOC.Day18, as: Day

  doctest Day

  @test Input.read!(18, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 64
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == -1
  end

  # @input Input.read!(18, "input")

  # test "Part 1" do
  #   assert Day.solve(@input, 1) == -1
  # end

  # test "Part 2" do
  #   assert Day.solve(@input, 2) == -1
  # end
end
