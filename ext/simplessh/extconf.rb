require 'mkmf'

# TODO: this check's not working
abort "libssh2 is missing" unless have_library "ssh2", "libssh2_session_handshake", "libssh2.h"

create_makefile "simplessh/simplessh"
puts "running the Makefile"
puts `cd ext/simplessh; make install`
