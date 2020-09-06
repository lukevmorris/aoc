secret_key = "bgvyzdsv"
hash = fn nonce ->
  :md5
  |> :crypto.hash(secret_key <> nonce)
  |> Base.encode16(case: :lower)
end
valid_block = fn hash ->
  String.starts_with?(hash, "000000")
end

Stream.iterate(0, &(&1 + 1))
|> Stream.map(&Integer.to_string/1)
|> Enum.find(& &1 |> hash.() |> valid_block.())
|> IO.puts()
