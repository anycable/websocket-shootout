# Run with: bundle exec falcon serve -b http://0.0.0.0:8080

# Based on https://github.com/socketry/async-websocket/blob/master/examples/chat/config.ru

require 'async/websocket/adapters/rack'
require 'async/clock'
require 'async/semaphore'

class Bench
  def initialize
    @connections = Set.new
    @semaphore = Async::Semaphore.new(512)
  end

  def connect(connection)
    @connections << connection
    connection.write({type: "welcome"})
  end

  def disconnect connection
		@connections.delete(connection)
	end

	def each(&block)
		@connections.each(&block)
	end

  def broadcast(message)
		start_time = Async::Clock.now

		@connections.each do |connection|
			@semaphore.async do
				connection.write(message)
				connection.flush
			end
		end

		end_time = Async::Clock.now
		Async.logger.info "Broadcast duration: #{(end_time - start_time).round(3)}s for #{@connections.count} connected clients."
  end

  def open(connection)
		self.connect(connection)

    while message = connection.read
      if message[:command] == "subscribe"
        next connection.write({type: "confirm_subscription", identifier: message[:identifier]})
      end

      next unless message[:command] == "message"

      data = JSON.parse(message[:data])
      cmd, payload = data.values_at("action", "payload")

      if cmd == "echo"
        connection.write({message: data, identifier: message[:identifier]})
      else
        broadcast({message: data, identifier: message[:identifier]})
        data["action"] = "broadcastResult"
        connection.write({message: data, identifier: message[:identifier]})
      end
    end

    connection.close
	ensure
		self.disconnect(connection)
  end

  def call(env)
		Async::WebSocket::Adapters::Rack.open(env, &self.method(:open))
	end
end

run Bench.new
