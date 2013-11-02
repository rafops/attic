Chef
====

Download and install Chef
-------------------------

```
curl -L https://www.opscode.com/chef/install.sh | sudo bash
```


Installing Chef on OSX 10.9
---------------------------

```
wget https://www.opscode.com/chef/install.sh
sed -i -e "s/10.8/10.9/" install.sh
chmod +x install.sh
sudo ./install.sh
```


Creating a recipe
-----------------

```
knife cookbook create my-recipe -o cookbooks/ -r md
```
