defmodule AOCTest.Day12Test do
  use ExUnit.Case
  alias AOC.Day12, as: Day

  doctest Day

  @test Input.read!(12, "test")

  @tag long_running: true
  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 31
  end

  @tag long_running: true
  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == -1
  end

  @input Input.read!(12, "input")

  @tag long_running: true
  test "Part 1" do
    assert Day.solve(@input, 1) == 330
  end

  @tag long_running: true
  test "Part 2" do
    assert Day.solve(@input, 2) == -1
  end
end
