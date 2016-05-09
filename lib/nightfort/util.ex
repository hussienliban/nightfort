defmodule NightFort.Util do

  def handle_payfort_response(res, key) do
    res = res |> Poison.decode!
    cond do
      res["error"] -> {:error, res}
      res[key] -> {:ok, Enum.map(res[key], &NightFort.Util.string_map_to_atoms &1)}
      true -> {:ok, NightFort.Util.string_map_to_atoms res}
    end
  end

end
