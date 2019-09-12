defmodule Abot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do

    children = read_config()
    |> process_config
    
    IO.inspect(children)
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Abot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp read_config() do
    case File.read("/home/smiles/.test/abot/config") do #Application.get_env(:abot, :config_file)) do
      {:ok, x} -> x
      {:error, :enoent} -> Abot.exit(":error :enonent, File /etc/abot/config doesnt exist")
      {:error, :eacces} -> Abot.exit(":error :eacces, Missing permission for reading /etc/abot/config.")
      {:error, :eisdir} -> Abot.exit(":error :eisdir, The named file is a directory.")
      {:error, :enotdir} -> Abot.exit(":error :enotdir, Component of the file name is not a directory.")
      {:error, :enomem} -> Abot.exit(":error :enomem, There is not enough memory for the contents of the file.")  
      _ ->  Abot.exit("Abnormal error occured while trying to read /etc/abot/config")
    end
  end  

  defp process_config(file) do
    config = String.trim(file, "\n")
             |> String.split("\n\n")

    generate_children(config, [], "unique_irc")
  end 

  defp generate_children([head|tail], result, child_id) do
    child_uniqued = child_id <> "1"
    irc = String.split(head, "\n")
    irc_identity = generate_identity(irc, %{})
    generate_children(tail, result ++ [Supervisor.child_spec({Abot.Worker, irc_identity}, id: String.to_atom(child_uniqued))], child_uniqued)
  end

  defp generate_children([], result, child_id) do
    result
  end 

  defp generate_identity([head|tail], result) do
    IO.inspect(head)
    sep = String.split(head, ": ")
    key = String.to_atom(Enum.at(sep, 0))
    value = Enum.at(sep, 1)
    case key do
      :Host -> generate_identity(tail, Map.put(result, :host, String.to_charlist(value)))
      :Port -> generate_identity(tail, Map.put(result, :port, String.to_integer(value)))
      :User -> generate_identity(tail, Map.put(result, :user, value))
      :Nick -> generate_identity(tail, Map.put(result, :nick, value))
      :Join -> generate_identity(tail, Map.put(result, :join, String.split(value, ",")))
      :SSL -> generate_identity(tail, Map.put(result, :ssl, String.to_atom(value)))
      _ -> Abot.exit("Error:" <> head <> " was given as a value in the config file")
    end    
  end  

  defp generate_identity([], result) do
    result
  end 
end
