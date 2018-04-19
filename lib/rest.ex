defmodule EXHikvisionISAPI.Rest do
  @user "admin"
  @password "Pro_4303"

  def conn(host, type, command) do
    HTTPoison.start

    #headers = "Authorization: Basic " <> Base.encode64("#{@user}:#{@password}")
    headers = [
      "Authorization": "Basic " <> Base.encode64("#{@user}:#{@password}"),
      "Connection": "keep-alive",
      "Host": host,
    ]

    options = []

    case type do
      :get ->
        #call server
        HTTPoison.get!("#{host}#{command}", headers)
        |> digest

        #digest


        #interpret response
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

  def digest(response) do
    if response.status_code === 401 do
      {_, digest_value} = response.headers
                |> Enum.find fn {x,y} -> x == "WWW-Authenticate" end

    String.replace(digest_value, "Digest ", "")
    |> String.split(",")
    |> Enum.reduce(%{}, fn(string, acc) ->
     parse_map = Regex.named_captures(~r/(?<key>.+)="(?<val>.+)"/, string)
     if parse_map["key"] !== nil do
       trimmed_key = String.trim(parse_map["key"])
       item = %{trimmed_key => parse_map["val"]}
        Map.merge(acc, item)
      else
        Map.merge(acc, %{})
     end
    end)



    end
  end
end
