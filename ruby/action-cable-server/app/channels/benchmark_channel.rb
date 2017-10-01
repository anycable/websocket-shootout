class BenchmarkChannel < ApplicationCable::Channel
  STREAMS = (1..10).to_a

  def subscribed
    Rails.logger.info "a client subscribed: #{id}"
    stream_from "all#{STREAMS.sample if ENV['SAMPLED']}"
  end

  def echo(data)
    transmit data
  end

  def broadcast(data)
    ActionCable.server.broadcast "all#{STREAMS.sample if ENV['SAMPLED']}", data
    data["action"] = "broadcastResult"
    transmit data
  end
end
