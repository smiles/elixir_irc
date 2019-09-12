defmodule Abot.Worker do
  def start_link(opts) do
    IO.inspect(opts)
    irc = IRC.generate_irc(opts.host, opts.port, opts.user, opts.nick)
    {:ok, pid} = IRC.start_link(irc)

    if opts.ssl do
      IRC.ssl_connect(pid)
    else
      IRC.connect(pid)
    end 
  
    IRC.init_irc(pid)    

    :timer.sleep(3000)

    join_all(opts.join, pid)

    processdata(pid)
  end 

  defp join_all([head|tail], pid) do
    IRC.join(pid, head)
    join_all(tail, pid)
  end 

  defp join_all([], pid) do
  end 

  defp processdata(pid) do
    IRC.buffer(pid)
    |> run_plugs
    :timer.sleep(1000)
    processdata(pid)
  end 

  defp run_plugs([head | tail]) do
    YoutubePlug.plug(head)
  end   

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end 
