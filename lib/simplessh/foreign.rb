require 'ffi'

module SimpleSSH
  module Foreign
    extend FFI::Library
    extension = FFI::Platform.mac? ? "bundle" : "so"
    ffi_lib File.join(File.dirname(__FILE__), "..", "..", "ext", "simplessh", "simplessh.#{extension}")
    ffi_convention :stdcall

    attach_function :open_session, :simplessh_open_session, [:string, :int, :string], :pointer
    attach_function :authenticate_with_password, :simplessh_authenticate_password, [:pointer, :string, :string], :pointer
    attach_function :authenticate_with_key, :simplessh_authenticate_key, [:pointer, :string, :string, :string, :string], :pointer
    attach_function :exec_command, :simplessh_exec_command, [:pointer, :string], :pointer
    attach_function :send_file, :simplessh_send_file, [:pointer, :int, :string, :string], :pointer
    attach_function :close_session, :simplessh_close_session, [:pointer], :void

    attach_function :is_left, :simplessh_is_left, [:pointer], :int
    attach_function :error, :simplessh_get_error, [:pointer], :int
    attach_function :value, :simplessh_get_value, [:pointer], :pointer
    attach_function :free_either_result, :simplessh_free_either_result, [:pointer], :void
    attach_function :free_either_count, :simplessh_free_either_count, [:pointer], :void
    attach_function :out, :simplessh_get_out, [:pointer], :string
    attach_function :err, :simplessh_get_err, [:pointer], :string
    attach_function :exit_code, :simplessh_get_exit_code, [:pointer], :int
    attach_function :exit_signal, :simplessh_get_exit_signal, [:pointer], :string
    attach_function :count, :simplessh_get_count, [:pointer], :int

    attach_function :free, :simplessh_free, [:pointer], :void
  end
end
