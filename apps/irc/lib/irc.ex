defmodule IRC do
  use GenServer

  def start_link(irc) do
    GenServer.start_link(__MODULE__, irc)
  end 

  def init(irc) do
    {:ok, irc}
  end

  def connect(pid) do
    GenServer.cast(pid, :connect)
  end 

  def ssl_connect(pid) do
    GenServer.cast(pid, :ssl)
  end 

  def send_message(pid, message) do
    GenServer.cast(pid, {:send, message})
  end 
  
  def init_irc(pid) do
    GenServer.cast(pid, :init)
  end 

  def join(pid, channel) do
    GenServer.cast(pid, {:join, channel})
  end 

  def buffer(pid) do
    GenServer.call(pid, :buffer)
  end 

  def generate_irc(ip, port, user, nick) do
    %{ip: ip, port: port, user: user, nick: nick, buffer: []}
  end

  #GenServer call

  def handle_call(:buffer, _from, state) do
    buffer = state.buffer
    new_state = Map.put(state, :buffer, [])
    {:reply, buffer, new_state}
  end 

  #GenServer cast

  def handle_cast(:connect, state) do
    {:ok, socket} = :gen_tcp.connect(state.ip, state.port, [])
    adding_ssl = Map.put(state, :ssl, false)
    {:noreply, Map.put(adding_ssl, :socket, socket)}
  end 

  def handle_cast(:ssl, state) do
    {:ok, socket} = :ssl.connect(state.ip, state.port, [])
    adding_ssl = Map.put(state, :ssl, true)
    {:noreply, Map.put(adding_ssl, :socket, socket)}
  end 
  
  def handle_cast({:send, message}, state) do
    :gen_tcp.send(state.socket, message)
    {:noreply, state}
  end 

  def handle_cast(:init, state) do
    send_data(IRC.Commands.user(state.user, state.user), state)
    :timer.sleep(500)
    send_data(IRC.Commands.nick(state.nick), state)

    {:noreply, state}
  end  

  def handle_cast({:join, channel}, state) do
    send_data(IRC.Commands.join(channel), state)

    {:noreply, state}
  end

  #GenServer handle_info

  def handle_info({:tcp, _socket, data}, state) do 
    buffer_data = irc_data(data)
    handle_ping(buffer_data, state)

    {:noreply, Map.put(state, :buffer, state.buffer ++ buffer_data)}
  end 

  def handle_info({:ssl, {:sslsocket, {:gen_tcp, _socket, :tls_connection, :undefined}, _ports}, data}, state) do
    buffer_data = irc_data(data)
    handle_ping(buffer_data, state)

    {:noreply, Map.put(state, :buffer, state.buffer ++ buffer_data)}
  end 

  #Private functions

  defp irc_data(data) do
    data
    |> String.Chars.to_string
    |> String.split("\r\n")
    |> timestamp_data([])
  end 

  defp timestamp_data([head|tail], result) do
    if head != "" do
      timestamp_data(tail, result ++ [{head, DateTime.utc_now}])
        else 
      timestamp_data(tail, result)
    end 
  end 

  defp timestamp_data([], result) do
      result
  end 

  defp handle_ping([head|tail], state) do 
    irc = elem(head, 0)

    if String.contains?(irc, "PING") do
      send_data("PONG :" <> String.trim(irc, "PING :") <> "\r\n", state)
    end  

    handle_ping(tail, state)
  end 

  defp handle_ping([], state) do
  end 


  defp send_data(data, state) do
    if state.ssl do
      :ssl.send(state.socket, data)
    else 
      :gen_tcp.send(state.socket, data)
    end
  end  
end
