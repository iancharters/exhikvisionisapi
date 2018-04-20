defmodule EXHikvisionISAPI.Rest do
  def conn({host, username, password}, type, uri) do
    HTTPoison.start

    case type do
      :get ->
        #call server
        digest_header = HTTPoison.get!("#{host}#{uri}")
        |> handle_header
        |> build_digest(username, password, "GET", host, uri)
        |> build_header(host)

        HTTPoison.get!("#{host}#{uri}", digest_header)

      :put ->
        IO.puts "PUT ACTION"
      :post ->
        IO.puts "POST ACTION"
      :delete ->
        IO.puts "DELETE ACTION"
      _ ->
        IO.puts "Something went wrong."
    end
  end

  def build_digest(auth, username, password, method, host, path) do
    ha1 = md5(username <> ":" <> auth["realm"] <> ":" <> password)
    ha2 = md5("#{method}:#{path}")
    client_nonce =  cnonce()
    nc = "00000001"
    response = md5("#{ha1}:#{auth["nonce"]}:#{nc}:#{client_nonce}:#{auth["qop"]}:#{ha2}")
    result = Map.to_list(%{
      "username" => username,
      "realm" => auth["realm"],
      "nonce" => auth["nonce"],
      "uri" => path,
      "qop" => auth["qop"],
      "nc" => nc,
      "cnonce" => client_nonce,
      "response" => response,
    })
    |> add_opaque(auth["opaque"])
    |> Enum.reduce([], fn({key, val}, acc) ->
      case key do
        "nc" -> acc ++ ["#{key}=#{val}"]
        _ -> acc ++ ["#{key}=\"#{val}\""]
      end
    end)
    |> Enum.join(",")

    "Digest #{result}"
  end

  def handle_header(response) do
    if response.status_code === 401 do
      {_, digest_value} = response.headers
                |> Enum.find fn {x,y} -> x == "WWW-Authenticate" end

    #TODO: Fix RegEx so I can remove the String.contains? hack
    String.replace(digest_value, "Digest ", "")
    |> String.split(",")
    |> Enum.reduce(%{}, fn(string, acc) ->
      if String.contains?(string, "opaque") do
        key = "opaque"
        value = ""
      end

      parse_map = Regex.named_captures(~r/(?<key>.+)="(?<val>.+)"/, string)

      if parse_map["key"] !== nil do
       trimmed_key = String.trim(parse_map["key"])
       item = %{trimmed_key => parse_map["val"]}
        Map.merge(acc, item)
      else
        Map.merge(acc, %{key => value})
      end
    end)
    end
  end

  def build_header(auth, host) do
    [
      "Authorization": auth,
      "Connection": "keep-alive",
      "Host": host,
    ]
  end

  defp cnonce() do
   :crypto.strong_rand_bytes(4)
   |> Base.encode16(case: :lower)
  end

  def md5(data) do
    Base.encode16(:erlang.md5(data), case: :lower)
  end

  defp add_opaque(response, opaque) when opaque in [nil, ""], do: response
  defp add_opaque(response, opaque), do: Map.put(response, "opaque", opaque)
end
