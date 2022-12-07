defmodule AOCTest.Day01Test do
  use ExUnit.Case
  alias AOC.Day01, as: Day

  doctest Day

  @test Input.read!(01, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 24000
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == 45000
  end

  @input Input.read!(01, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 72511
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == 212117
  end
end
