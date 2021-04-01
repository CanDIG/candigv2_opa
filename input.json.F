{
    "path": "api//individuals",
    "method": "GET",
    "ga4gh_passport_v1": [
        {
            "iat": 1580000000,
            "exp": 1617616523,
            "ga4gh_visa_v1": {
                "type": "AffiliationAndRole",
                "asserted": 1549680000,
                "value": "faculty@med.stanford.edu",
                "source": "https://grid.ac/institutes/grid.240952.8",
                "by": "so"
            }
        },
        {
            "iat": 1580000100,
            "exp": 1617616523,
            "ga4gh_visa_v1": {
                "type": "ControlledAccessGrants",
                "asserted": 1549632872,
                "value": "https://ega-archive.org/datasets/710",
                "source": "https://grid.ac/institutes/grid.0000.0a",
                "by": "dac"
            }
        },
        {
            "iat": 1580000200,
            "exp": 1617616523,
            "ga4gh_visa_v1": {
                "type": "ControlledAccessGrants",
                "asserted": 1549640000,
                "value": "https://ega-archive.org/datasets/712",
                "source": "https://ega-archive.org/dacs/712",
                "by": "dac",
                "conditions": [
                    [
                        {
                            "type": "AffiliationAndRole",
                            "value": "const:faculty@med.stanford.edu",
                            "source": "const:https://grid.ac/institutes/grid.240952.8",
                            "by": "const:so"
                        }
                    ],
                    [
                        {
                            "type": "AffiliationAndRole",
                            "value": "const:faculty@med.stanford.edu",
                            "source": "const:https://grid.ac/institutes/grid.240952.8",
                            "by": "const:system"
                        }
                    ]
                ]
            }
        },
        {
            "iss": "https://issuer.example1.org/oidc",
            "sub": "10001",
            "iat": 1580000300,
            "exp": 1617616523,
            "ga4gh_visa_v1": {
                "type": "AcceptedTermsAndPolicies",
                "asserted": 1549680000,
                "value": "https://doi.org/10.1038/s41431-018-0219-y",
                "source": "https://grid.ac/institutes/grid.240952.8",
                "by": "self"
            }
        },
        {
            "iss": "https://other.example2.org/oidc",
            "sub": "abcd",
            "iat": 1580000400,
            "exp": 1617616523,
            "ga4gh_visa_v1": {
                "type": "ResearcherStatus",
                "asserted": 1549680000,
                "value": "https://doi.org/10.1038/s41431-018-0219-y",
                "source": "https://grid.ac/institutes/grid.240952.8",
                "by": "so"
            }
        },
        {
            "iss": "https://broker.example3.org/oidc",
            "sub": "999999",
            "iat": 1580000500,
            "exp": 1617616523,
            "ga4gh_visa_v1": {
                "type": "LinkedIdentities",
                "asserted": 1549680000,
                "value": "10001,https:%2F%2Fissuer.example1.org%2Foidc;abcd,https:%2F%2Fother.example2.org%2Foidc",
                "source": "https://broker.example3.org/oidc",
                "by": "system"
            }
        }
    ]
}