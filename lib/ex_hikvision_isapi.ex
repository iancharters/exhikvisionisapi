defmodule EXHikvisionISAPI do
  @host "http://15782marine.proactivealarms.com:81"

  @moduledoc """
  Documentation for ExHikvisionIsapi.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ExHikvisionIsapi.hello
      :world

  """
  def start(_type, _args) do

  end

  def go do
    EXHikvisionISAPI.Rest.conn(@host, :get, "/ISAPI/System/status")
  end
end
