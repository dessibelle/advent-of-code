defmodule AOCTest.Day07Test do
  use ExUnit.Case
  alias AOC.Day07, as: Day

  doctest Day

  @test Input.read!(07, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 95437
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == 24933642
  end

  @input Input.read!(07, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 1583951
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == -1
  end
end
