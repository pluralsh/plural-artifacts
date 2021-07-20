# kafka

Deploys the CNCF's strimzi [kafka operator](https://github.com/strimzi/strimzi-kafka-operator) and optionally provisions a cluster with it.  The operator itself provides most of the tools you'll need for full lifecycle support of kafka, including:

* zookeeper management
* topic management
* user management
* prometheus support
* kafka connect
* ...many other features

The plural distribution will also enhance it further with important dashboards, cli extensions, runbooks, and other features to make life easier