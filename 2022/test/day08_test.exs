defmodule AOCTest.Day08Test do
  use ExUnit.Case
  alias AOC.Day08, as: Day

  doctest Day

  @test Input.read!(08, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 21
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == 8
  end

  @input Input.read!(08, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 1676
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == 313200
  end
end
