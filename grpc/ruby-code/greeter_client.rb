this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir)
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'helloworld_services_pb'

def main
  test_root = File.join(File.dirname(File.dirname(__FILE__)))
  files = ['server.crt', 'client.key', 'client.crt']
  certs = files.map { |f| File.open(File.join(test_root, f)).read }

  creds = GRPC::Core::ChannelCredentials.new(certs[0], nil, nil)

  opts = {
    channel_args: {
      GRPC::Core::Channel::SSL_TARGET => 'example.com'
    }
  }
  stub = Helloworld::Greeter::Stub.new('localhost:50051', creds, opts)

  user = ARGV.size > 0 ?  ARGV[0] : 'world'
  message = stub.say_hello(Helloworld::HelloRequest.new(name: user)).message
  p "Greeting: #{message}"
  message = stub.say_hello_again(Helloworld::HelloRequest.new(name: user)).message
  p "Greeting: #{message}"
end

main
