defmodule AOC do
  @moduledoc """
  Documentation for `AOC`.
  """

  @doc """
  Hello world.
  ## Examples
      iex> AOC.hello()
      :world
  """
  def start(_type, _args) do
    System.argv()
    |> then(fn l ->
      if length(l) > 0 do
        l |> Enum.map(&String.to_integer/1)
      else
        1..21
      end
    end)
    |> Enum.map(&AOC.Runner.run!/1)

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: A.Worker.start_link(arg)
      # {A.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: A.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
