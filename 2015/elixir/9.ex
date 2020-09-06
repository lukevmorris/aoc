input = "Tristram to AlphaCentauri = 34
Tristram to Snowdin = 100
Tristram to Tambi = 63
Tristram to Faerun = 108
Tristram to Norrath = 111
Tristram to Straylight = 89
Tristram to Arbre = 132
AlphaCentauri to Snowdin = 4
AlphaCentauri to Tambi = 79
AlphaCentauri to Faerun = 44
AlphaCentauri to Norrath = 147
AlphaCentauri to Straylight = 133
AlphaCentauri to Arbre = 74
Snowdin to Tambi = 105
Snowdin to Faerun = 95
Snowdin to Norrath = 48
Snowdin to Straylight = 88
Snowdin to Arbre = 7
Tambi to Faerun = 68
Tambi to Norrath = 134
Tambi to Straylight = 107
Tambi to Arbre = 40
Faerun to Norrath = 11
Faerun to Straylight = 66
Faerun to Arbre = 144
Norrath to Straylight = 115
Norrath to Arbre = 135
Straylight to Arbre = 127"

defmodule RouteFinder do
  def evaluate(route, distances), do: evaluate(route, distances, 0)
  def evaluate([_last], _distances, sum), do: sum
  def evaluate([first, second | tail], distances, sum) do
    total = sum + get_in(distances, [first, second])
    evaluate([second | tail], distances, total)
  end

  def to_route_map(list) do
    for {city, edges} <- list, into: %{} do
      distances = for edge <- edges, into: %{}, do: {edge.to, edge.distance}
      {city, distances}
    end
  end

  def perms([]), do: [[]]
  def perms(list) do
    for h <- list, t <- perms(list -- [h]), do: [h | t]
  end
end

defmodule Edge do
  defstruct [:from, :to, :distance]

  def from(edge), do: edge.from
  def distance(edge), do: edge.distance

  def parse(string) when is_binary(string) do
    string
    |> String.replace("= ", "")
    |> String.split(" ")
    |> parse()
  end
  def parse([from, "to", to, distance]) do
    distance = String.to_integer(distance)
    one = %Edge{from: from, to: to, distance: distance}
    two = %Edge{from: to, to: from, distance: distance}
    [one, two]
  end
end

route_map =
  input
  |> String.split("\n")
  |> Enum.flat_map(&Edge.parse/1)
  |> Enum.group_by(&Edge.from/1)
  |> RouteFinder.to_route_map()

route_map
|> Map.keys()
|> RouteFinder.perms()
|> Enum.map(& RouteFinder.evaluate(&1, route_map))
|> Enum.max()
|> inspect()
|> IO.puts()