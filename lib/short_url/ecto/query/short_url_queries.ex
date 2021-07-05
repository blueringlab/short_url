defmodule ShortUrl.ShortUrlQueries do
  # import Ecto.Query
  alias ShortUrl.Repo
  alias ShortUrl.Schema.ShortUrl
  require Logger

  # query url with hash
  def get_url(hash) do
    try do
      case Repo.get_by(ShortUrl, [hash: hash]) do
        nil -> {:error, :not_found}
        good_record -> {:ok, good_record}
      end
    rescue
      ex -> {:error, "Failed to get url. detail=#{inspect ex}"}
    end
  end

  # insert url with hash
  def insert_url(params) do
    Logger.debug(~s|insert_url=#{inspect(params)}|)

    # create chageset for new record
    url_changeset = ShortUrl.changeset(
      %ShortUrl{
        hash:    params[:hash],
        url:     params[:url]
      }
    )

    # try to insert
    Repo.insert(url_changeset)
    |> test_query_result()
  end

  # just pass through :ok result
  defp test_query_result({:ok, set}), do: {:ok, set}

  # get detail error if the result is :error
  defp test_query_result({:error, %Ecto.Changeset{errors: errors} = change_set}) do
    Logger.debug(~s|test_query_result errors=#{inspect(errors)}|)
    case errors do
      # try to match to non_unique hash error
      [hash: { _, [constraint: :unique, constraint_name: _] }] ->
        Logger.debug(~s|test_query_result errors=:not_unique_hash|)
        {:error, :not_unique_hash}

      # all other error, just pass through
      _ ->
        Logger.debug(~s|test_query_result errors=#{inspect(change_set)}|)
        {:error, change_set}
    end
  end
end
