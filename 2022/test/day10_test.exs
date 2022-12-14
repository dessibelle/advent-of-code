defmodule AOCTest.Day10Test do
  use ExUnit.Case
  alias AOC.Day10, as: Day

  doctest Day

  @test Input.read!(10, "test")

  test "Part 1 (example)" do
    assert Day.solve(@test, 1) == 13140
  end

  test "Part 2 (example)" do
    assert Day.solve(@test, 2) == "##..##..##..##..##..##..##..##..##..##..\n###...###...###...###...###...###...###.\n####....####....####....####....####....\n#####.....#####.....#####.....#####.....\n######......######......######......####\n#######.......#######.......#######.....\n.."
  end

  @input Input.read!(10, "input")

  test "Part 1" do
    assert Day.solve(@input, 1) == 15880
  end

  test "Part 2" do
    assert Day.solve(@input, 2) == "###..#.....##..####.#..#..##..####..##..\n#..#.#....#..#.#....#.#..#..#....#.#..#.\n#..#.#....#....###..##...#..#...#..#....\n###..#....#.##.#....#.#..####..#...#.##.\n#....#....#..#.#....#.#..#..#.#....#..#.\n#....####..###.#....#..#.#..#.####..###.\n.."
  end
end
