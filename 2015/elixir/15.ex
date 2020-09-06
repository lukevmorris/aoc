input = "Sugar: capacity 3, durability 0, flavor 0, texture -3, calories 2
Sprinkles: capacity -3, durability 3, flavor 0, texture 0, calories 9
Candy: capacity -1, durability 0, flavor 4, texture 0, calories 1
Chocolate: capacity 0, durability 0, flavor -2, texture 2, calories 8"

defmodule Ingredient do
  defstruct [:capacity, :durability, :flavor, :texture, :proportion, :calories]

  @matcher ~r/capacity ([-\d]+), durability ([-\d]+), flavor ([-\d]+), texture ([-\d]+), calories ([-\d]+)/

  def new(description) do
    [_, capacity, durability, flavor, texture, calories] = Regex.run(@matcher, description)

    %Ingredient{
      capacity: String.to_integer(capacity),
      durability: String.to_integer(durability),
      flavor: String.to_integer(flavor),
      texture: String.to_integer(texture),
      calories: String.to_integer(calories)
    }
  end

  def capacity(%{capacity: c, proportion: p}), do: c * p
  def durability(%{durability: d, proportion: p}), do: d * p
  def flavor(%{flavor: f, proportion: p}), do: f * p
  def texture(%{texture: t, proportion: p}), do: t * p
  def calories(%{calories: c, proportion: p}), do: c * p

  def with_proportion({ingredient, proportion}), do: %{ingredient | proportion: proportion}
end

defmodule Cookie do
  def recipe(proportions, ingredients) do
    ingredients
    |> Enum.zip(proportions)
    |> Enum.map(&Ingredient.with_proportion/1)
  end

  def with_calories(ingredients, calories) do
    calories == ingredients |> Enum.map(&Ingredient.calories/1) |> Enum.sum()
  end

  def capacity(ingredients), do: ingredients |> Enum.map(&Ingredient.capacity/1) |> Enum.sum() |> max(0)
  def durability(ingredients), do: ingredients |> Enum.map(&Ingredient.durability/1) |> Enum.sum() |> max(0)
  def flavor(ingredients), do: ingredients |> Enum.map(&Ingredient.flavor/1) |> Enum.sum() |> max(0)
  def texture(ingredients), do: ingredients |> Enum.map(&Ingredient.texture/1) |> Enum.sum() |> max(0)

  def score(ingredients) do
    capacity(ingredients) * durability(ingredients) * flavor(ingredients) * texture(ingredients)
  end
end

defmodule Proportions do
  def enumerate() do
    for su <- 0..100, sp <- 0..100, ca <- 0..100, ch <- 0..100, su + sp + ca + ch == 100, into: [], do: [su, sp, ca, ch]
  end
end

ingredients =
  input
  |> String.split("\n")
  |> Enum.map(&Ingredient.new/1)

Proportions.enumerate()
|> Enum.map(&Cookie.recipe(&1, ingredients))
|> Enum.filter(&Cookie.with_calories(&1, 500))
|> Enum.map(&Cookie.score/1)
|> Enum.max()
|> inspect()
|> IO.puts()

