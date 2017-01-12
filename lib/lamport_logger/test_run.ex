defmodule LamportLogger.TestRun do
  alias LamportLogger.{Logger, Worker}

  def run(sleep, jitter) do
    logger = Logger.start([:john, :paul, :ringo, :george])

    a = Worker.start(:john,   logger, 13, sleep, jitter)
    b = Worker.start(:paul,   logger, 23, sleep, jitter)
    c = Worker.start(:ringo,  logger, 36, sleep, jitter)
    d = Worker.start(:george, logger, 49, sleep, jitter)

    Worker.peers(a, [b, c, d])
    Worker.peers(b, [a, c, d])
    Worker.peers(c, [a, b, d])
    Worker.peers(d, [a, b, c])

    :timer.sleep(5000)

    Logger.stop(logger)

    Worker.stop(a)
    Worker.stop(b)
    Worker.stop(c)
    Worker.stop(d)
  end
end
