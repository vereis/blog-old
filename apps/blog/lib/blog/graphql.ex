defmodule Blog.GraphQL do
  @backend_url "https://api.github.com/graphql"
  @access_token "Bearer " <> Application.get_env(:blog, :access_token, "missing")
  @ssl_options [ssl: [{:versions, [:"tlsv1.2"]}]]

  @spec query(String.t()) :: {:ok, map()} | {:error, term()}
  def query(query, variables \\ %{}) do
    with {:ok, payload} <- build_payload(query, variables),
         {:ok, %{status_code: 200} = response} <- do_request(payload, @access_token),
         {:ok, result} <- process_response(response) do
      case result do
        %{"errors" => [_error | _errors] = errors} ->
          {:error, errors}

        result ->
          {:ok, result}
      end
    end
  end

  defp build_payload(query, variables) do
    case Jason.encode(%{query: query, variables: variables}) do
      {:ok, payload} -> {:ok, payload}
      error -> {:error, reason: :encode_query_error, error: error}
    end
  end

  defp do_request(payload, access_token) do
    headers = [authorization: access_token]

    case HTTPoison.post(@backend_url, payload, headers, @ssl_options) do
      {:ok, %HTTPoison.Response{} = response} ->
        {:ok, response}

      error ->
        {:error, reason: :do_request_error, error: error}
    end
  end

  defp process_response(%HTTPoison.Response{body: body}) do
    case Jason.decode(body) do
      {:ok, result} ->
        {:ok, result}

      error ->
        {:error, reason: :process_response_error, error: error}
    end
  end
end
