defmodule ShortUrl.ShortUrlProcessor do
  alias ShortUrl.ShortUrlQueries

  require Logger

  # save url with hash which is from url
  # but it has a chance url is duplicate which is already in DB.
  # when hash is duplicate, internally url will be added with '#'
  # to create new hash intentionally. It will try up to a numer
  # which is configured in :short_url, :hash_gen, :max_duplicate_try
  def save_hash_url(url) do
    # if hash from url duplicates from db, it will try again with
    # new hash up to max. try.
    {_final_url, result} =
      1..Application.get_env(:short_url, :hash_gen)[:max_duplicate_try]
      |> Enum.reduce_while({url, {:error, :unknown}}, fn try_count, acc ->
        {new_url, _} = acc

        # generate hash to insert
        {:ok, hash} = get_hash(new_url)

        Logger.debug(~s|save_hash_url retry_count=#{try_count}, hash=#{inspect(hash)}, url=#{inspect(url)}|)

        case ShortUrlQueries.insert_url(hash: hash, url: url) do
          # if insertion done successully, get out with success result
          {:ok, _record} ->
            {:halt, {new_url, {:ok, [hash: hash, url: url]}}}

          # duplicate hash? then try with additional char in url for getting new hash
          {:error, :not_unique_hash} ->
            {:cont, {new_url <> "#", {:error, :not_unique_hash}}}

          # any other error? just get out with error. Don't retry.
          {:error, change_set} ->
            {:halt, {new_url, {:error, change_set}}}
        end
      end)

    # return only {:ok, ___} or {:error, ___}
    result
  end

  def get_hash(url) do
    # get MD5 hash and take first 6 bytes.
    # Base64 will use 6 bits for each char.
    # first 6 bytes => 48 bits => Base64 (6 bits) * 8 char
    #   => 8 char long shorten url
    << first_6bytes::binary-size(6), _::binary >> = :crypto.hash(:md5, url)
    {:ok, Base.url_encode64(first_6bytes, padding: false)}
  end
end
