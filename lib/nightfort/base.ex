defmodule NightFort.Base do
  defmacro __using__(endpoint) do
    quote do

      def create(amount, params) do
        create amount, params, NightFort.config_or_env_key || "test_sec_k_520720630ead07b289f72"
      end

      def create(amount, params, key) do
        # Default currency
        params = Map.put_new params, :currency, "USD"
        params = Map.put_new params, :amount, amount

        NightFort.make_request_with_key(:post, @endpoint, key, params)
      end

      def get(id) do
        get id, NightFort.config_or_env_key
      end

      def get(id, key) do

        NightFort.make_request_with_key(:get, "#{@endpoint}/#{id}", key)
        |> NightFort.Util.handle_payfort_response(@endpoint)
      end


      def list do
        get NightFort.config_or_env_key
      end

      def list(key) do
        NightFort.make_request_with_key(:get, @endpoint, key)
      end
    end
  end
end
