defmodule AOCTest.Day03Test do
  use ExUnit.Case
  alias AOC.Day03, as: Day

  doctest Day

  @test Input.read!(03, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 157
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == 70
  end

  @input Input.read!(03, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 7742
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == 2276
  end
end
