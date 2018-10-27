# Run with: bundle exec falcon serve -b http://0.0.0.0:3334

require 'async/websocket/server'

$connections = []

run lambda {|env|
	Async::WebSocket::Server.open(env) do |connection|
		$connections << connection
		
		while message = connection.next_message   
      cmd, payload = message.values_at('type', 'payload')
      if cmd == 'echo'
        connection.send_message({type: 'echo', payload: payload})
      else
        message = { type: 'broadcast', payload: payload }

        $connections.each do |connection|
          connection.send_message(message)
        end

        connection.send_message({type: "broadcastResult", payload: payload})
      end
    end
	end
	
	[200, {}, ["Hello World"]]
}
