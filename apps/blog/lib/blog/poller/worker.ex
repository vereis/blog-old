defmodule Blog.Poller.Worker do
  @moduledoc """
  Simple Oban Worker that runs once at application startup, and every five minutes
  after the initial run.

  Delegates all further business logic to `Blog.Poller.execute/0`.
  """

  use Oban.Worker,
    queue: :default,
    max_attempts: 3,
    unique: [period: div(:timer.minutes(5), 1000)]

  alias Blog.Poller

  @impl Oban.Worker
  def perform(job) do
    if job.attempt == 1, do: schedule_next_job()
    Poller.execute()
  end

  defp schedule_next_job do
    Oban.insert(new(%{}, schedule_in: div(:timer.minutes(5), 1000)))
  end
end
