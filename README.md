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
