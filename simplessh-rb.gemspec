Gem::Specification.new "simplessh-rb", "1.0.0" do |s|
  s.summary    = "Ruby version of SimpleSSH"
  s.extensions << "ext/simplessh/extconf.rb"
  s.authors    = ["Tom Feron"]
  s.email      = "tho.feron@gmail.com"
  s.files      = ["lib/simplessh.rb", "lib/simplessh/foreign.rb", "lib/simplessh/session.rb", "lib/simplessh/either.rb", "lib/simplessh/result.rb", "lib/simplessh/helpers.rb", "ext/simplessh/simplessh.c", "ext/simplessh/simplessh.h", "ext/simplessh/simplessh_types.c", "ext/simplessh/simplessh_types.h"]
  s.add_dependency 'ffi'
end
