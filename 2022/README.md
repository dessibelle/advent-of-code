# Advent of Code

### Usage example

#### REPL

```
iex -S mix
iex(1)> AOC.Runner.run!(1)
test pt. 1: 24000
test pt. 2: 45000
input pt. 1: 72511
input pt. 2: 212117
[[:ok, :ok], [:ok, :ok]]
iex(2)> IEx.Helpers.recompile()
:noop
```

It's also possible to run a part of a single day, like so:
```
IEx.Helpers.recompile() && Input.read!(1, "test") |> AOC.Day01.solve(1)
```


#### mix run

```
mix run aoc.ex 1
```