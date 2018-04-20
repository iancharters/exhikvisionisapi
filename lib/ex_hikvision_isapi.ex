defmodule EXHikvisionISAPI do
  @host System.get_env("ISAPI_HOST")
  @username System.get_env("ISAPI_USERNAME")
  @password System.get_env("ISAPI_PASSWORD")

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
    EXHikvisionISAPI.Rest.conn({@host, @username, @password}, :get, "/ISAPI/System/status")
  end
end
