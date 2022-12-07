defmodule AOCTest.Day05Test do
  use ExUnit.Case
  alias AOC.Day05, as: Day

  doctest Day

  @test Input.read!(05, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == "CMZ"
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == "MCD"
  end

  @input Input.read!(05, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == "LJSVLTWQM"
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == "BRQWDBBJM"
  end
end
