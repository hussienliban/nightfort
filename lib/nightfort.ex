defmodule NightFort do

  use Application
  use HTTPoison.Base

  def start(_type, _args) do
    start #start HTTPoison.Base.start inherited from use statement
    NightFort.Supervisor.start_link
  end

  @doc """
  Creates the URL for our endpoint.
  Args:
    * endpoint - part of the API we're hitting
  Returns string
  """
  def process_url(endpoint) do
    "https://api.start.payfort.com/" <> endpoint
  end

  def req_headers(key) do
    Map.new
    |> Map.put("Authorization", "Basic #{key |> key_encode64}")
    |> Map.put("User-Agent",    "Start/payfort-elixir/0.1.0")
    |> Map.put("Content-Type",  "application/x-www-form-urlencoded")
  end

  def make_request_with_key( method, endpoint, key, body \\ [], headers \\ %{}, options \\ []) do
    rb = NightFort.URI.encode_query(body)
    rh = req_headers( key )
          |> Map.merge(headers)
          |> Map.to_list

    {:ok, response} = request(method, endpoint, rb, rh, options)
    response.body
  end

  @doc """
  Grabs PAYFORT_SECRET_KEY from system ENV
  Returns binary
  """
  def config_or_env_key do
    Application.get_env(:nightfort, :secret_key) || System.get_env("PAYFORT_SECRET_KEY")
  end

  defp key_encode64(%{"username": username, "password": password}) do
    username <> ":" <> password |> Base.encode64
  end

  defp key_encode64(key) do
    key |> Base.encode64
  end
end
