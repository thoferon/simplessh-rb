require 'simplessh/foreign'
require 'simplessh/either'
require 'simplessh/session'
require 'simplessh/result'

module SimpleSSH
  def self.open_session(hostname, port, known_hosts)
    either_pointer = SimpleSSH::Foreign.open_session(hostname, port, known_hosts)

    SimpleSSH::Either.from_pointer!(either_pointer) do |sess_pointer|
      SimpleSSH::Session.from_pointer(sess_pointer)
    end
  end

  def self.with_session_password(hostname, username, password, opts = {}, &block)
    port        = opts[:port] || 22
    known_hosts = opts[:known_hosts] || File.join(Dir.home, ".ssh", "known_hosts")

    sess = self.open_session(hostname, port, known_hosts).flat_map do |s|
      s.authenticate_with_password(username, password)
    end

    res = sess.flat_map do |s|
      block.call s
    end

    sess.flat_map { |s| s.close }
    res
  end

  def self.with_session_key(hostname, username, opts = {}, &block)
    passphrase  = opts[:passphrase]  || ""
    public_key  = opts[:public_key]  || File.join(Dir.home, ".ssh", "id_rsa.pub")
    private_key = opts[:private_key] || File.join(Dir.home, ".ssh", "id_rsa")
    known_hosts = opts[:known_hosts] || File.join(Dir.home, ".ssh", "known_hosts")

    sess = self.open_session(hostname, port, known_hosts).flat_map do |s|
      s.authenticate_with_key(username, public_key, private_key, passphrase)
    end

    res = sess.flat_map do |s|
      block.call s
    end

    sess.flat_map { |s| s.close }
    res
  end
end
