defmodule ShortUrlWeb.PageControllerTest do
  use ShortUrlWeb.ConnCase
  import Mock

  describe "GET /" do
    test "should return landing page", %{conn: conn} do
      conn = get(conn, "/")

      assert html_response(conn, 200) =~ "ShortUrl · Phoenix Framework"
    end
  end

  describe "GET /:hash" do
    test "should forward long url with valid short url", %{conn: conn} do
      # creaet mock to return forward URL.
      with_mocks([
        {ShortUrl.ShortUrlQueries,
          [],
          [get_url: fn(_) -> {:ok, %ShortUrl.Schema.ShortUrl{hash: "dont_care",
                                      url: "http://full_url/"} } end]
        }
      ]) do
        conn = get(conn, "/dont_care")
        assert redirected_to(conn, 301) =~ "http://full_url/"
      end
    end

    test "should return 404 error page when hash is not found", %{conn: conn} do
      # creaet mock to return forward URL.
      with_mocks([
        {ShortUrl.ShortUrlQueries,
          [],
          [get_url: fn(_) -> {:error, :not_found} end]
        }
      ]) do
        conn = get(conn, "/dont_care")
        assert html_response(conn, 200) =~ "Unable to find URL to redirect!"
      end
    end
  end
end
