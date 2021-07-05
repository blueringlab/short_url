defmodule ShortUrlWeb.UrlControllerTest do
  use ShortUrlWeb.ConnCase
  import Mock

  @create_short_url_body %{
    "url" => "https://www.cnn.com/"
  }

  @create_short_url_1st_response %{
    "fullUrl" => "http://localhost:4002/DCd5PMVt",
    "hash" => "DCd5PMVt",
    "url" => "https://www.cnn.com/"
  }

  @create_short_url_2nd_response %{
    "fullUrl" => "http://localhost:4002/A-DwvhqC",
    "hash" => "A-DwvhqC",
    "url" => "https://www.cnn.com/"
  }

  @create_short_url_dup_error_response %{
    "status" => "error",
    "description" => "Duplicate hash"
  }

  @create_short_url_bad_url_body %{
    "url" => "bad_url_/123/#$%#"
  }

  @create_short_url_bad_url_error_response %{
    "status" => "error",
    "description" => "Bad request url"
  }

  @create_short_url_bad_data_error_response %{
    "status" => "error",
    "description" => "Bad data"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "content-type", "application/json;charset=UTF-8")}
  end

  describe "POST /api/url" do
    test "should respond with 200 Ok with shorturl response.", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create_url), @create_short_url_body)

      response = json_response(conn, 200)
      assert response == @create_short_url_1st_response
    end

    test "should respond with 200 Ok for 2nd duplicate long url with different hash", %{conn: conn} do
      # 1st long url
      conn = post(conn, Routes.url_path(conn, :create_url), @create_short_url_body)

      response = json_response(conn, 200)
      assert response == @create_short_url_1st_response

      # 2nd long url, but it will return different hash
      conn = post(conn, Routes.url_path(conn, :create_url), @create_short_url_body)

      response = json_response(conn, 200)
      assert response == @create_short_url_2nd_response

    end

    test "should respond with 400 Error with bad format of long URL.", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create_url), @create_short_url_bad_url_body)

      response = json_response(conn, 400)
      assert response == @create_short_url_bad_url_error_response
    end

    test "should respond with 409 Error when max duplicate long url reached", %{conn: conn} do
      # create mock to make ShortUrlQueries.insert_url() function return insert failed.
      with_mocks([
        {ShortUrl.ShortUrlQueries,
          [],
          [insert_url: fn(_) -> {:error, :not_unique_hash} end]
        }
      ]) do
        conn = post(conn, Routes.url_path(conn, :create_url), @create_short_url_body)

        response = json_response(conn, 409)
        assert response == @create_short_url_dup_error_response
      end
    end

    test "should respond with 400 Error when DB insert failed", %{conn: conn} do
      # create mock to make ShortUrlQueries.insert_url() function return insert failed.
      with_mocks([
        {ShortUrl.ShortUrlQueries,
          [],
          [insert_url: fn(_) -> {:error, %Ecto.Changeset{errors: []}} end]
        }
      ]) do
        conn = post(conn, Routes.url_path(conn, :create_url), @create_short_url_body)

        response = json_response(conn, 400)
        assert response == @create_short_url_bad_data_error_response
      end
    end
  end

  describe "GET /api/url" do
    test "should respond with 200 Ok with shorturl response.", %{conn: conn} do
      # insert a url to database.
      ShortUrl.ShortUrlProcessor.save_hash_url("https://www.cnn.com/")

      # hash for the long url
      conn = get(conn, Routes.url_path(conn, :get_url, "DCd5PMVt") )

      response = json_response(conn, 200)
      assert response == @create_short_url_1st_response
    end
  end
end
