# # Plezi Rack Application file.

# # NOTE: Plezi requires `iodine` for Websocket support.
# #       No Iodine, no websockets.

# # Run using `rackup` or using:
# iodine -t <number of threads> -w <number of processes> -p <port>
# # i.e.:
# iodine -t 8 -p 3334


require 'plezi'

class ShootoutApp
  def on_open
    subscribe "all"
  end

  # we won't be using AutoDispatch, but directly using the `on_message` callback.
  def on_message data
    cmd, payload = JSON(data).values_at('type', 'payload')
    if cmd == 'echo'
      write({type: 'echo', payload: payload}.to_json)
    else
      ::Iodine.publish "all", { type: 'broadcast', payload: payload }.to_json
      write({type: "broadcastResult", payload: payload}.to_json)
    end
  end
end

Plezi.route '/cable', ShootoutApp

run Plezi.app
