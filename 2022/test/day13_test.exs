defmodule AOCTest.Day13Test do
  use ExUnit.Case
  alias AOC.Day13, as: Day

  doctest Day

  @test Input.read!(13, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 13
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == 140
  end

  test "Part 2 (empty lists 1)" do
    assert Day.sorter([], [[]]) == true
  end

  test "Part 2 (empty lists 2)" do
    assert Day.sorter([[]], []) == false
  end

  test "Part 2 (empty lists 3)" do
    assert Day.sorter([[]], [[[]]]) == true
  end

  test "Part 2 (empty lists 4)" do
    assert Day.sorter([[[]]], [[]]) == false
  end

  test "Part 2 (empty lists 5)" do
    assert Day.sorter([[]], [1,1,3,1,1]) == true
  end

  test "Part 2 (empty lists 6)" do
    assert Day.sorter([[[]]], [1,1,3,1,1]) == true
  end

  test "Part 2 (empty lists 7)" do
    assert Day.sorter([[]], [1,1,3,1,1]) == true
  end

  test "Part 2 (empty lists 7b)" do
    assert Day.sorter([[]], [9]) == true
  end

  test "Part 2 (empty lists 8)" do
    assert Day.sorter([[[]]], [1,1,3,1,1]) == true
  end

  test "Part 2 (empty lists 9)" do
    assert Day.sorter([1,1,3,1,1], [1,1,5,1,1]) == true
  end

  test "Part 2 (empty lists 10)" do
    assert Day.sorter([1,[2,[3,[4,[5,6,7]]]],8,9], [1,[2,[3,[4,[5,6,0]]]],8,9]) == false
  end
  test "Part 2 (empty lists 11)" do
    assert Day.sorter([2,[3,[4,[5,6,7]]]], [2,[3,[4,[5,6,0]]]]) == false
  end
  test "Part 2 (empty lists 12)" do
    assert Day.sorter([3,[4,[5,6,7]]], [3,[4,[5,6,0]]]) == false
  end
  test "Part 2 (empty lists 13)" do
    assert Day.sorter([4,[5,6,7]], [4,[5,6,0]]) == false
  end
  test "Part 2 (empty lists 14)" do
    assert Day.sorter([5,6,7], [5,6,0]) == false
  end

  @input Input.read!(13, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 6240
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == 23142
  end
end
