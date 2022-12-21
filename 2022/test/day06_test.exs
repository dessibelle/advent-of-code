defmodule AOCTest.Day06Test do
  use ExUnit.Case
  alias AOC.Day06, as: Day

  doctest Day

  @test Input.read!(06, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == "Found marker 'jpqm' after 7 chars"
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == "Found marker 'qmgbljsphdztnv' after 19 chars"
  end

  @test2 Input.read!(06, "test2")

  test "Part 1 (example)" do
    assert Day.solve(@test2, 1) == "Found marker 'vwbj' after 5 chars\nFound marker 'pdvj' after 6 chars\nFound marker 'rfnt' after 10 chars\nFound marker 'zqfr' after 11 chars"
  end

  test "Part 2 (example)" do
    assert Day.solve(@test2, 2) == "Found marker 'vbhsrlpgdmjqwf' after 23 chars\nFound marker 'ldpwncqszvftbr' after 23 chars\nFound marker 'wmzdfjlvtqnbhc' after 29 chars\nFound marker 'jwzlrfnpqdbhtm' after 26 chars"
  end

  @input Input.read!(06, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == "Found marker 'wbcl' after 1833 chars"
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == "Found marker 'vbnwqdhtlsfcjz' after 3425 chars"
  end
end
