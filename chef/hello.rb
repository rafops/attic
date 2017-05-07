file '/vagrant/hello.txt' do
    content 'hello, eh'
end

file '/vagrant/totalmem.txt' do
    content "total memory #{node['memory']['total']}"
end
