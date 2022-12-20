defmodule AOCTest.Day20Test do
  use ExUnit.Case
  alias AOC.Day20, as: Day

  doctest Day

  @test Input.read!(20, "test")

  # Initial arrangement:
  # 1, 2, -3, 3, -2, 0, 4

  # 1 moves from 0 to 1

  test "Part 1 - step 0 (example)" do
    assert Day.mix_reducer({1, 0}, [{1, 0}, {2, 1}, {-3, 3}, {3, 3}, {-2, 4}, {0, 5}, {4, 6}]) == [{2, 1}, {1, 0}, {-3, 3}, {3, 3}, {-2, 4}, {0, 5}, {4, 6}]
  end

  test "Part 1 - step 1 (example)" do
    assert Day.mix_reducer({2, 1}, [{2, 1}, {1, 0}, {-3, 3}, {3, 3}, {-2, 4}, {0, 5}, {4, 6}]) == [{1, 0}, {-3, 3}, {2, 1},  {3, 3}, {-2, 4}, {0, 5}, {4, 6}]
  end

  test "Part 1 - step 2 (example)" do
    assert Day.mix_reducer({-3, 3}, [{1, 0}, {-3, 3}, {2, 1},  {3, 3}, {-2, 4}, {0, 5}, {4, 6}]) == [{1, 0}, {2, 1},  {3, 3}, {-2, 4}, {-3, 3}, {0, 5}, {4, 6}]
  end

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 3
  end

  # test "Part 2 (example)" do
  #   assert Day.solve(@test, 2) == -1
  # end

  @input Input.read!(20, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 2275
  end

  # test "Part 2" do
  #   assert Day.solve(@input, 2) == -1
  # end
end
