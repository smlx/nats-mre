# NATS Client/Account Bug Minimal Reproducible Example

## Overview

The problem is that sometimes a client which should be attached to a specific account is instead added to the global `$G` account.
This is visible in the trace log when the subscription is broadcast to attached nodes in the cluster.

Correct log:

```
->> [RS+ lagoonRemote lagoon.sshportal.api sshportalapi 1]
```

Incorrect log:

```
->> [RS+ $G lagoon.sshportal.api sshportalapi 1]
```

## Instructions

Since the problem seems to be some kind of race condition, the `find.bug.sh` script will randomly restart nodes and connect/disconnect the client until the bug is found in the logs.
In my testing the problem is reproduced within 30 seconds of running `find.bug.sh`.

Run `find.bug.sh` like this:

```
docker-compose up -d; ./find.bug.sh
```

When the problem is found, it will exit and print the logs around the trace log showing the error.
