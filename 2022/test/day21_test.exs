defmodule AOCTest.Day21Test do
  use ExUnit.Case
  alias AOC.Day21, as: Day

  doctest Day

  @test Input.read!(21, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 152
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == 301
  end

  @input Input.read!(21, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 21120928600114
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == -1
  end
end
