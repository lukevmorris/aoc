defmodule Presents do
  def count(house) do
    factors(house) ++ [house]
    |> Enum.sum()
    |> Kernel.*(10)
  end

  def factors(house) do
    half = house / 2 |> trunc()
    for n <- 1..half, rem(house, n) == 0, into: [], do: n
  end
end

# 3_310_000

# Stream.iterate(786432, &(&1 + 2))
# |> Enum.find(fn n ->
#   Presents.count(n) >= 33100000
# end)
Presents.count(8)
|> inspect()
|> IO.puts()