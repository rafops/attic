Java
====

```
sudo mv jdk1.7.0_05 /opt
sudo ln -s jdk1.7.0_05 java-7-oracle
sudo update-alternatives --install "/usr/bin/java" "java" /opt/java-7-oracle/bin/java 1
sudo update-alternatives --install "/usr/bin/ControlPanel" "ControlPanel" /opt/java-7-oracle/bin/ControlPanel 1
java -version
```
