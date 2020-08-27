# CanDIGv2 setup for OPA

As it stands right now this is merely a stub to try out
authorization for the metadata service.

Most services will require this combo between a data file (the json file)
where we list the static information needed for OPA to make a decision on
the claim (e.g. a list of endpoints for a REST API) and a list of rules to 
make sense of this and the input provided by every client requests (so
the rego file).


## Dev setup

First off install OPA: https://www.openpolicyagent.org/docs/latest/#running-opa

To run the service:

```
./opa run -s metadata-service.json metadata-service.rego
```

## TODO

Packaging the data files and rego files in bundles seems like a no brainer:
<https://www.openpolicyagent.org/docs/latest/management/#bundle-file-format>

Especially considering we'll have something like a rego file per service
and thus also whole lot more data files. Something else to consider will
be how these bundles are distributed: when are these going to be created and
should these be offered as is to OPA or provided through an HTTP API?
<https://www.openpolicyagent.org/docs/latest/management/#bundle-service-api>

Something else I think is unlikely to be needed but still relevant to mention
is how to deploy OPA: as a single instance which N services refer to or
by colocation next to each of these services. Performance would be better
in this latter configuration but since OPA keeps everything in memory,
latency should not be much of an issue.
