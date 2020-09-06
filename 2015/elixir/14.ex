input = "Rudolph can fly 22 km/s for 8 seconds, but then must rest for 165 seconds.
Cupid can fly 8 km/s for 17 seconds, but then must rest for 114 seconds.
Prancer can fly 18 km/s for 6 seconds, but then must rest for 103 seconds.
Donner can fly 25 km/s for 6 seconds, but then must rest for 145 seconds.
Dasher can fly 11 km/s for 12 seconds, but then must rest for 125 seconds.
Comet can fly 21 km/s for 6 seconds, but then must rest for 121 seconds.
Blitzen can fly 18 km/s for 3 seconds, but then must rest for 50 seconds.
Vixen can fly 20 km/s for 4 seconds, but then must rest for 75 seconds.
Dancer can fly 7 km/s for 20 seconds, but then must rest for 119 seconds."

defmodule Reindeer do
  defstruct [:name, :speed, :fly_time, :rest_time, :action, :action_time_left, :distance_traveled, :points]
  @matcher ~r/(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./

  def new(string) do
    [reindeer, speed, fly_time, rest_time] =
      @matcher
      |> Regex.run(string)
      |> Enum.drop(1)

    %Reindeer{
      name: reindeer,

      speed: String.to_integer(speed),
      fly_time: String.to_integer(fly_time),
      rest_time: String.to_integer(rest_time),

      action: :flying,
      action_time_left: String.to_integer(fly_time),
      distance_traveled: 0,

      points: 0
    }
  end

  def act(%Reindeer{action: :flying, action_time_left: 1} = reindeer) do
    reindeer
    |> move()
    |> begin_resting()
  end
  def act(%Reindeer{action: :resting, action_time_left: 1} = reindeer) do
    reindeer
    |> begin_flying()
  end
  def act(%Reindeer{action: :flying} = reindeer) do
    reindeer
    |> move()
    |> tick()
  end
  def act(%Reindeer{action: :resting} = reindeer) do
    reindeer
    |> tick()
  end

  def distance(%Reindeer{distance_traveled: d}), do: d
  def points(%Reindeer{points: p}), do: p

  def tick(reindeer), do: %{reindeer | action_time_left: reindeer.action_time_left - 1}
  def move(reindeer), do: %{reindeer | distance_traveled: reindeer.distance_traveled + reindeer.speed}
  def begin_resting(reindeer), do: %{reindeer | action: :resting, action_time_left: reindeer.rest_time}
  def begin_flying(reindeer), do: %{reindeer | action: :flying, action_time_left: reindeer.fly_time}
end

defmodule Race do
  def tick(reindeers) do
    reindeers
    |> Enum.map(&Reindeer.act/1)
    |> Enum.sort_by(&Reindeer.distance/1, &>=/2)
    |> award_points()
  end

  def award_points([leader | tail]) do
    [%{leader | points: leader.points + 1} | tail]
  end
end

reindeers =
  input
  |> String.split("\n")
  |> Enum.map(&Reindeer.new/1)

1..2503
|> Enum.reduce(reindeers, fn _, rs -> Race.tick(rs) end)
|> Enum.max_by(&Reindeer.points/1)
|> inspect()
|> IO.puts()