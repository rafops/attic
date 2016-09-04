this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir)
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'helloworld_services_pb'

class GreeterServer < Helloworld::Greeter::Service
  def say_hello(hello_req, _unused_call)
    Helloworld::HelloReply.new(message: "Hello #{hello_req.name}")
  end

 def say_hello_again(hello_req, _unused_call)
   Helloworld::HelloReply.new(message: "Hello again, #{hello_req.name}")
 end
end

def main
  s = GRPC::RpcServer.new

  test_root = File.join(File.dirname(File.dirname(__FILE__)))
  files = ['ca.crt', 'server.key', 'server.crt']
  certs = files.map { |f| File.open(File.join(test_root, f)).read }

  creds = GRPC::Core::ServerCredentials.new(
           certs[0], [{ private_key: certs[1], cert_chain: certs[2] }], false)

  s.add_http2_port('0.0.0.0:50051', creds)
  s.handle(GreeterServer)
  s.run_till_terminated
end

main
