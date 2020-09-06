transition_text = "Al => ThF
Al => ThRnFAr
B => BCa
B => TiB
B => TiRnFAr
Ca => CaCa
Ca => PB
Ca => PRnFAr
Ca => SiRnFYFAr
Ca => SiRnMgAr
Ca => SiTh
F => CaF
F => PMg
F => SiAl
H => CRnAlAr
H => CRnFYFYFAr
H => CRnFYMgAr
H => CRnMgYFAr
H => HCa
H => NRnFYFAr
H => NRnMgAr
H => NTh
H => OB
H => ORnFAr
Mg => BF
Mg => TiMg
N => CRnFAr
N => HSi
O => CRnFYFAr
O => CRnMgAr
O => HP
O => NRnFAr
O => OTi
P => CaP
P => PTi
P => SiRnFAr
Si => CaSi
Th => ThCa
Ti => BP
Ti => TiTi
e => HF
e => NAl
e => OMg"

molecule = "CRnSiRnCaPTiMgYCaPTiRnFArSiThFArCaSiThSiThPBCaCaSiRnSiRnTiTiMgArPBCaPMgYPTiRnFArFArCaSiRnBPMgArPRnCaPTiRnFArCaSiThCaCaFArPBCaCaPTiTiRnFArCaSiRnSiAlYSiThRnFArArCaSiRnBFArCaCaSiRnSiThCaCaCaFYCaPTiBCaSiThCaSiThPMgArSiRnCaPBFYCaCaFArCaCaCaCaSiThCaSiRnPRnFArPBSiThPRnFArSiRnMgArCaFYFArCaSiRnSiAlArTiTiTiTiTiTiTiRnPMgArPTiTiTiBSiRnSiAlArTiTiRnPMgArCaFYBPBPTiRnSiRnMgArSiThCaFArCaSiThFArPRnFArCaSiRnTiBSiThSiRnSiAlYCaFArPRnFArSiThCaFArCaCaSiThCaCaCaSiRnPRnCaFArFYPMgArCaPBCaPBSiRnFYPBCaFArCaSiAl"

defmodule Transition do
  defstruct [:from, :to]

  defmodule MacroTransition do
    defstruct [:from, :to]
  end
  defmodule MicroTransition do
    defstruct [:from, :to]
  end

  def forwards(string) do
    [from, to] = String.split(string, " => ")
    %Transition{from: from, to: to}
  end

  def backwards(string) do
    [to, from] = String.split(string, " => ")
    cond do
      String.contains?(from, "Rn") ->
        %MacroTransition{from: from, to: to}

      true ->
        %MicroTransition{from: from, to: to}
    end
  end

  def is_macro?(%MacroTransition{}), do: true
  def is_macro?(_), do: false
end

defmodule Molecule do
  def replace(molecule, transitions) do
    transitions
    |> Enum.find(fn t -> String.contains?(molecule, t.from) end)
    |> case do
      nil -> :done
      tx ->
        reverse_from = String.reverse(tx.from)
        reverse_to = String.reverse(tx.to)
        molecule
        |> String.reverse()
        |> String.replace(reverse_from, reverse_to, global: false)
        |> String.reverse()
    end
  end
end

backwards =
  transition_text
  |> String.split("\n")
  |> Enum.map(&Transition.backwards/1)
  |> Enum.sort_by(fn t -> String.length(t.from) end, &>=/2)

backwards
|> inspect
|> IO.puts()

1..200
|> Enum.reduce_while(molecule, fn i, m ->
  case Molecule.replace(m, backwards) do
    :no_transitions -> {:halt, :womp_womp}
    "e" -> {:halt, i}
    mol ->
      {:cont, mol}
  end
end)
|> inspect()
|> IO.puts()