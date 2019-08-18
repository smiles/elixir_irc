defmodule ElixirIRC.Commands do

  @doc "Instructs the server to return information about the administrators of the server specified by <target>, where <target> is either a server or a user. If <target> is omitted, the server should return information about the administrators of the current server."
  def admin(target) do
    "ADMIN " <> target
  end 

  @doc "Provides the server with a message to automatically send in reply to a PRIVMSG directed at the user, but not to a channel they are on. If <message> is omitted, the away status is removed."
  def away(message) do
    "AWAY " <> message
  end 

  @doc "Sends a channel NOTICE message to <nickname> on <channel> that bypasses flood protection limits."
  def cnotice(nickname, channel, message) do
    "CNOTICE " <> nickname <> " " <> channel <> " " <> ":" <> message
  end 

  @doc "Sends a private message to <nickname> on <channel> that bypasses flood protection limits."
  def cprivmsg(nickname, channel, message) do
    "CPRIVMSG " <> nickname <> " " <> channel <> " " <> ":" <> message
  end 

  @doc "Instructs the server <remote server> (or the current server, if <remote server> is omitted) to connect to <target server> on port <port>."
  def connect(server, port, remote_server) do
    "CONNECT " <> server <> " " <> port <> " " <> remote_server <> "\n"
  end 

  @doc "Instructs the server to shut down."
  def die() do
    "DIE \n"
  end 

  #Didn't seem needed to implement this at the time
  #def encap() do
  #end 

  #Didn't implement was only useful for server to instruct client of error
  #def error() do
  #end 

  @doc "Requests the server to display the help file."
  def help() do
    "HELP \n"
  end 

  @doc "Returns information about the <target> server, or the current server if <target> is omitted."
  def info(target) do
    "INFO " <> target <> "\n"
  end 

  @doc "Invites <nickname> to the channel <channel>."
  def invite(nickname, channel) do
    "INVITE " <> nickname <> " " <> channel <> "\n"
  end 

  @doc "Queries the server to see if the clients in the space-separated list <nicknames> are currently on the network."
  def ison(nickname) do
    "ISON " <> nickname <> "\n"
  end 

  @doc "Makes the client join the channels in the comma-separated string <channels>, specifying the passwords, if needed, in the comma-separated string<keys>."
  def join(channel) do
    "JOIN " <> channel <> "\r\n"
  end 

  def join(channels, keys) do
    "JOIN " <> channels <> " " <> keys <> "\r\n"
  end 

  @doc "Forcibly removes <client> from <channel>."
  def kick(channel, client, message) do
    "KICK " <> channel <> " " <> client <> " " <> ":[" <> message <> "]"
  end 

  @doc "Forcibly removes <client> from the network."
  def kill(client, comment) do
    "KILL " <> client <> " " <> comment
  end 

  @doc "Sends a NOTICE to an invitation-only <channel> with an optional <message>, requesting an invite."
  def knock(channel, message) do
    "KNOCK " <> channel <> " " <> "[" <> message <> "]"
  end 

  @doc "Lists all server links matching <server mask>, if given, on <remote server>, or the current server if omitted."
  def links(remote_server, server_mask) do
    "LINKS [" <> remote_server <> "[" <> server_mask <> "]]"
  end 

  @doc "Lists all channels on the server.[15] If the comma-separated list <channels> is given, it will return the channel topics. If <server> is given, the command will be forwarded to <server> for evaluation."
  def list(channels, server) do
    "LIST [" <> channels <> "[" <> server <> "]]" 
  end 

  def lusers() do
  end 

  def mode() do
  end 

  @doc "Returns the message of the day on <server> or the current server if it is omitted."
  def motd(server) do
    "MOTD " <> server <> "\n"
  end

  def names() do
  end 

  def namesx() do
  end 

  @doc "Allows a client to change their IRC nickname."
  def nick(nickname) do
    "NICK " <> nickname <> "\r\n"
  end 

  @doc "This command works similarly to PRIVMSG, except automatic replies must never be sent in reply to NOTICE messages."
  def notice(msgtarget, message) do
    "NOTICE " <> msgtarget <> " " <> message 
  end 

  def oper() do
  end 

  @doc "Causes a user to leave the channels in the comma-separated list <channels>."
  def part(channels, message) do
    "PART " <> channels <> " " <> message 
  end 

  @doc "Sets a connection password. This command must be sent before the NICK/USER registration combination."
  def pass(password) do
    "PASS " <> password
  end 

  @doc "Tests the presence of a connection. A PING message results in a PONG reply. If <server2> is specified, the message gets passed on to it."
  def ping(server) do
    "PING " <> server <> "\n"
  end 

  @doc "This command is a reply to the PING command and works in much the same way."
  def pong(server) do
    "PONG " <> server <> "\n"
  end 

  @doc "Sends <message> to <msgtarget>, which is usually a user or channel."
  def privmsg(msgtarget, message) do
    "PRIVMSG " <> msgtarget <> " " <> message <> "\n"
  end 

  def quit() do
  end

  def rehash() do
  end

  def restart() do
  end

  def rules() do
  end 

  def server() do
  end 

  def service() do
  end 

  def servlist() do
  end 

  def squery() do
  end

  def squit() do
  end 

  def setname() do
  end 

  def silence() do
  end

  def stats() do
  end

  def summon() do
  end

  def time() do
  end 

  def topic() do
  end 

  def trace() do
  end 

  def uhnames() do
  end 

  @doc "This command is used at the beginning of a connection to specify the username, hostname, real name and initial user modes of the connecting client."
  def user(user, realname) do
    "USER " <> user <> " 0 * :" <> realname <> "\r\n" 
  end 

  def user(user, realname, mode) do
    "USER " <> user <> " " <> mode  <> " * :" <> realname <> "\r\n" 
  end 
  
  def userhost() do
  end 

  def userip() do
  end   

  def users() do
  end 

  def version() do
  end 

  def wallops do
  end 

  def watch() do
  end 

  def who() do
  end 

  def whois() do
  end 

  def whowas() do
  end 

end 
