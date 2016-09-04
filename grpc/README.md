gRPC
====

Download protoc

```
https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-osx-x86_64.zip
```

Unzip, add bin to PATH. Install ruby plugin:

```
gem install grpc --pre
```

Compile proto:

```
grpc_tools_ruby_protoc -I protos --ruby_out=ruby-code --grpc_out=ruby-code protos/helloworld.proto
```

Certificates:

https://github.com/codequest-eu/grpc-demo/blob/master/keys/generate.sh
