# console

Administration console and upgrade manager for plural.  Supports bootstrapping and querying upgrade queues to automatically upgrade any application in cluster, and also handles observability, logging and kubernetes api introspection for users.

Requires git credentials and plural credentials to operate fully, and utilizes a number of `platform.plural.sh` CRDs to build out the observability features within it.