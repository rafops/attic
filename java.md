Java
====

## Setup

Download Java Development Kit (JDK):

```
http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
```

Install JDK:

```
open ~/Downloads/jdk-8u74-macosx-x64.dmg
```

```
echo 'export JAVA_HOME=`/usr/libexec/java_home`' >> ~/.zshrc
source ~/.zshrc
```

Download Apache Maven:

```
https://maven.apache.org/download.cgi
```

Install Apache Maven:

```
unzip ~/Downloads/apache-maven-3.3.9-bin.zip
sudo mv apache-maven-3.3.9 /opt
```

Create a new project:

```
mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```
