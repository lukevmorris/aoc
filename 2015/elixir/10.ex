defmodule Reducer do
  def look_and_say(string) do
    string
    |> String.codepoints()
    |> look([])
    |> say("")
  end

  def say([], acc), do: acc
  def say([ head | tail], acc) do
    value = List.first(head)
    count = length(head)
    acc = acc <> Integer.to_string(count) <> value
    say(tail, acc)
  end

  def look([], acc), do: acc |> Enum.reverse()
  def look([head | tail], []), do: look(tail, [[head]])
  def look([head | tail], [first | rest] = acc) do
    if head in first do
      first = [head | first]
      look(tail, [first | rest])
    else
      acc = [ [head] | acc ]
      look(tail, acc)
    end
  end
end

1..50
|> Enum.reduce("1113222113", fn _, say -> Reducer.look_and_say(say) end)
|> String.length()
|> inspect()
|> IO.puts()