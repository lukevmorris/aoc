defmodule Password do
  def iterate(string) when is_binary(string) do
    string
    |> to_charlist()
    |> Enum.reverse()
    |> iterate([])
    |> to_string()
  end

  def iterate([head | tail], acc) do
    case head + 1 do
      123 ->
        iterate(tail, ['a' | acc])

      char ->
        Enum.reverse(tail) ++ [char] ++ acc
    end
  end

  def valid?(string) do
    contains_incrementing_triplet?(string) && !contains_confusing_letters?(string) && contains_two_doubles?(string)
  end

  def contains_incrementing_triplet?(string) when is_binary(string) do
    string
    |> to_charlist()
    |> contains_incrementing_triplet?()
  end
  def contains_incrementing_triplet?([one, two, three | tail]) do
    if one + 1 == two && two + 1 == three do
      true
    else
      contains_incrementing_triplet?([two, three | tail])
    end
  end
  def contains_incrementing_triplet?(_), do: false

  def contains_confusing_letters?(string) do
    String.contains?(string, "o") || String.contains?(string, "i") || String.contains?(string, "l")
  end

  def contains_two_doubles?(string), do: contains_two_doubles?(String.codepoints(string), :first)
  def contains_two_doubles?([one, two | tail], :first) do
    if one == two do
      contains_two_doubles?(tail, :second)
    else
      contains_two_doubles?([two | tail], :first)
    end
  end
  def contains_two_doubles?([one, two | tail], :second) do
    if one == two do
      true
    else
      contains_two_doubles?([two | tail], :second)
    end
  end
  def contains_two_doubles?([_one], _), do: false
  def contains_two_doubles?([], _), do: false

  def next(string) do
    string
    |> Stream.iterate(&Password.iterate/1)
    |> Stream.drop(1)
    |> Enum.find(&Password.valid?/1)
  end
end

input = "hepxcrrq"