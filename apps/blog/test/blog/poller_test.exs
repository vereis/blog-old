defmodule Blog.PollerTest do
  use Blog.DataCase

  import Tesla.Mock

  alias Blog.Poller
  alias Blog.Posts.Post

  describe "execute/0" do
    setup do
      ref = :atomics.new(1, [])

      build_posts = fn count ->
        for _index <- 1..count do
          seq_id = :atomics.get(ref, 1)

          %{
            "id" => seq_id,
            "title" => "Test #{seq_id}",
            "markdown" => "Some Content",
            "content" => "<p>Some Content</p>",
            "created_at" => "2021-08-13T00:18:47Z",
            "updated_at" => "2021-08-13T00:18:47Z",
            "tags" => %{"nodes" => [%{"name" => "Tagged"}]}
          }
        end
      end

      {:ok, build_posts: build_posts}
    end

    test "does nothing when repository has no issues" do
      mock(fn _request ->
        json(%{"data" => %{"repository" => %{"issues" => %{"nodes" => []}}}}, status: 200)
      end)

      assert {:ok, insert_count: 0, errors: []} = Poller.execute()
    end

    test "reports any malformed issues, if any", ctx do
      ref = :atomics.new(1, [])

      mock(fn _request ->
        :ok = :atomics.add(ref, 1, 1)
        is_first_page? = :atomics.get(ref, 1) == 1

        if is_first_page? do
          [post] = ctx.build_posts.(1)

          json(
            %{
              "data" => %{
                "repository" => %{
                  "issues" => %{
                    "nodes" => [Map.put(post, "title", nil)],
                    "pageInfo" => %{
                      "endCursor" => "Y3Vyc29yOnYyOpHOOc4cUA==",
                      "hasNextPage" => false
                    }
                  }
                }
              }
            },
            status: 200
          )
        else
          json(
            %{
              "data" => %{
                "repository" => %{
                  "issues" => %{
                    "nodes" => [],
                    "pageInfo" => %{
                      "endCursor" => "4f7917ed5Y88AzBOOc4ce1==",
                      "hasNextPage" => false
                    }
                  }
                }
              }
            },
            status: 200
          )
        end
      end)

      assert {:ok, insert_count: 0, errors: [%Ecto.Changeset{valid?: false}]} = Poller.execute()
    end

    test "pages through issues in repository and creates posts from said issues", ctx do
      ref = :atomics.new(1, [])

      mock(fn _request ->
        :ok = :atomics.add(ref, 1, 1)
        is_first_page? = :atomics.get(ref, 1) == 1

        if is_first_page? do
          json(
            %{
              "data" => %{
                "repository" => %{
                  "issues" => %{
                    "nodes" => ctx.build_posts.(5),
                    "pageInfo" => %{
                      "endCursor" => "Y3Vyc29yOnYyOpHOOc4cUA==",
                      "hasNextPage" => false
                    }
                  }
                }
              }
            },
            status: 200
          )
        else
          json(
            %{
              "data" => %{
                "repository" => %{
                  "issues" => %{
                    "nodes" => [],
                    "pageInfo" => %{
                      "endCursor" => "4f7917ed5Y88AzBOOc4ce1==",
                      "hasNextPage" => false
                    }
                  }
                }
              }
            },
            status: 200
          )
        end
      end)

      assert {:ok, insert_count: 5, errors: []} = Poller.execute()

      assert %Blog.Posts.Post{
               content: "<p>Some Content</p>",
               is_draft: false,
               markdown: "Some Content",
               reading_time_minutes: 1,
               slug: "test_0",
               tags: ["Tagged"],
               title: "Test 0",
               created_at: ~U[2021-08-13 00:18:47.000000Z],
               updated_at: ~U[2021-08-13 00:18:47.000000Z]
             } = Repo.get_by(Post, title: "Test 0")
    end
  end
end
