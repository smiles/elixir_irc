defmodule ElixirIRC do
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

  def add_plug(pid, script) do
    GenServer.cast(pid, {:add_plug, script})
  end 

  def generate_irc(ip, port, user, nick) do
    %{ip: ip, port: port, user: user, nick: nick}
  end

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
    send_data(ElixirIRC.Commands.user(state.user, state.user), state)
    :timer.sleep(500)
    send_data(ElixirIRC.Commands.nick(state.nick), state)

    {:noreply, state}
  end  

  def handle_cast({:join, channel}, state) do
    send_data(ElixirIRC.Commands.join(channel), state)

    {:noreply, state}
  end

  def handle_info({:tcp, _socket, data}, state) do 
    data
    |> to_string
    |> String.split("\r\n")
    |> process_irc(state)
    
    {:noreply, state}
  end 

  def handle_info({:ssl, {:sslsocket, {:gen_tcp, _socket, :tls_connection, :undefined}, ports}, data}, state) do
    data
    |> to_string
    |> String.split("\r\n")
    |> process_irc(state)
    
    {:noreply, state}
  end 
  
  defp process_irc([head|tail], state) do
    irc_command(head)
    |> irc_response(state)
    process_irc(tail, state)  
  end 

  defp process_irc([], state) do
    :ok 
  end 

  defp irc_command(line) do
    String.split(line, " ")
    |> case do
      [x, y] when x == "PING" -> {:ping, y}
      [host, b, channel, msg] when b == "PRIVMSG" -> {:privmsg, host, channel, msg}    
      _ -> {:no_command, line}
    end 
  end 

  defp irc_response(data, state) do 
    case data do 
      {:ping, x} -> send_data("PONG " <> x <> "\r\n", state)
      {:privmsg, _, _, _} -> plugin_list(data)  
      _ -> :ok
    end 
  end 

  defp send_data(data, state) do
    if state.ssl do
      :ssl.send(state.socket, data)
    else 
      :gen_tcp.send(state.socket, data)
    end
  end  

  defp plugin_list(data) do
    IO.inspect(data)
  end 
end
