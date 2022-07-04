defmodule Blog.Poller.WorkerTest do
  use Blog.DataCase
  use Oban.Testing, repo: Blog.Repo

  import Tesla.Mock

  alias Blog.Poller.Worker

  describe "perform/1" do
    test "schedules next job in 5 minutes on first attempt and calls `Poller.execute/0`" do
      now = DateTime.utc_now()
      test_process = self()

      mock(fn _request ->
        send(test_process, :execute_was_called)
        json(%{"data" => %{"repository" => %{"issues" => %{"nodes" => []}}}}, status: 200)
      end)

      assert {:ok, insert_count: 0, errors: []} = Worker.perform(%{attempt: 1})
      assert_received :execute_was_called

      assert [worker] = all_enqueued(worker: Worker)
      assert worker.state == "scheduled"
      assert DateTime.diff(worker.scheduled_at, now, :second) == 60 * 5
    end

    test "does not schedule next job in 5 minutes if not on first attempt, still calls `Poller.execute/0`" do
      test_process = self()

      mock(fn _request ->
        send(test_process, :execute_was_called)
        json(%{"data" => %{"repository" => %{"issues" => %{"nodes" => []}}}}, status: 200)
      end)

      assert {:ok, insert_count: 0, errors: []} = Worker.perform(%{attempt: 2})
      assert_received :execute_was_called

      assert [] = all_enqueued(worker: Worker)
    end
  end
end
