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
    send_data(IRC.Commands.user(state.user, state.user), state)
    :timer.sleep(500)
    send_data(IRC.Commands.nick(state.nick), state)

    {:noreply, state}
  end  

  def handle_cast({:join, channel}, state) do
    send_data(IRC.Commands.join(channel), state)

    {:noreply, state}
  end

  def handle_info({:tcp, _socket, data}, state) do 
    data
    |> to_string
    |> String.split("\r\n")
    |> process_irc(state)
    
    {:noreply, state}
  end 

  def handle_info({:ssl, {:sslsocket, {:gen_tcp, _socket, :tls_connection, :undefined}, _ports}, data}, state) do
    data
    |> to_string
    |> String.split("\r\n")
    |> process_irc(state)
    
    {:noreply, state}
  end 
  
  defp process_irc([head|tail], state) do
    irc_command(head)
    |> pong_response(state)
    |> plugin_list

    process_irc(tail, state) 
  end 

  defp process_irc([], _state) do
    :ok 
  end 

  defp irc_command(line) do
    if String.contains?(line, "PING") do 
      {:pong, "PONG " <> List.last(String.split(line, " ")) <> "\r\n"}
    else 
      if String.contains?(line, "PRIVMSG") do 
        process_privmsg(line)
      else 
        {:info, line}
      end 
    end   
  end 

  defp process_privmsg(irc) do
    first = String.split(irc, " :")
    second = String.split(List.first(first), " PRIVMSG ")
    {:privmsg, List.last(second), List.last(first)}
  end 

  defp send_data(data, state) do
    if state.ssl do
      :ssl.send(state.socket, data)
    else 
      :gen_tcp.send(state.socket, data)
    end
  end  

  defp pong_response(irc, state) do
    if elem(irc, 0) == :pong do
      send_message(elem(irc, 1), state)
    end

   irc 
  end 

  defp plugin_list(data) do
    IO.inspect(data)
  end 
end
