# CanDIG Authorization

The candig_access.rego file has the startings for parsing CanDIG-centric passports and data formats to allow for access based on access level of the user. Vault support is currently limited by rotating keys needing to be fixed but information contained within Keycloak tokens can be
successfully used. REMS related requests still need to be addressed via additional rules.


# GA4GH Passport Parsing

This repo contains the startings of Rego code to parse GA4GH [Passport](https://github.com/ga4gh-duri/ga4gh-duri.github.io/blob/master/researcher_ids/ga4gh_passport_v1.md#passport) claims to be used with [Open Policy Agent](https://www.openpolicyagent.org/). Currently most visas are able to be parsed and used to enforce OPA policies through a combination of both Rego rules and structured data. When making policy decisions, the **conditions** claim is not yet evaluated if it exists within relevant visas. Additional work will need to be done to fully check that visas containing condition claims are satisfied.

## Getting Started

[Download OPA](https://www.openpolicyagent.org/docs/latest/#running-opa)

**Optional but highly recommended**: Install the Open Policy Agent [extension](https://marketplace.visualstudio.com/items?itemName=tsandall.opa) in VSCode. Installing this will also install OPA if it's not detected on your system, but the main benefit of the extension is being able to evaluate rules and run tests in VSCode. You will need to bind the evaluate and run tests command to keyboard shortcuts once the extension is installed.

Once OPA is installed, rule evaulation can be tested with data by changing the input.json


## Test Data

Within this repo is a Keycloak access token containing a GA4GH passport. This is not the typical way a passport would be acquired. It **should** be returned via the userinfo endpoint. However, this is just easier for isolated testing.