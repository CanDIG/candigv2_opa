package ga4ghPassport


sevenTen := {
    "iat": 1580000100,
    "exp": 1617616523,
    "ga4gh_visa_v1": {
        "type": "ControlledAccessGrants",
        "asserted": 1549632872,
        "value": "https://ega-archive.org/datasets/710",
        "source": "https://grid.ac/institutes/grid.0000.0a",
        "by": "dac"
    }
}

sevenTwelve := {
    "iat": 1580000100,
    "exp": 1617616523,
    "ga4gh_visa_v1": {
        "type": "ControlledAccessGrants",
        "asserted": 1549632872,
        "value": "https://ega-archive.org/datasets/712",
        "source": "https://grid.ac/institutes/grid.0000.0a",
        "by": "dac"
    }
}


termsAndPolicies := {
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
}

researchStatus := {
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
}

facultyMember := {
    "iat": 1580000000,
    "exp": 1617616523,
    "ga4gh_visa_v1": {
        "type": "AffiliationAndRole",
        "asserted": 1549680000,
        "value": "faculty@med.stanford.edu",
        "source": "https://grid.ac/institutes/grid.240952.8",
        "by": "so"
    }
}


input_researcher_only_710 := {
    "path": "api/ga4gh/individuals",
    "method": "GET",
    "ga4gh_passport_v1": [
        sevenTen, termsAndPolicies, researchStatus
    ]
}

input_researcher_both_710_712 := {
    "path": "api/ga4gh/individuals",
    "method": "GET",
    "ga4gh_passport_v1": [
        sevenTen, sevenTwelve, termsAndPolicies, researchStatus
    ]
}

input_regular_with_710 := {
    "path": "api/ga4gh/individuals",
    "method": "GET",
    "ga4gh_passport_v1": [
        sevenTen, termsAndPolicies
    ]
}

input_regular := {
    "path": "api/ga4gh/individuals",
    "method": "GET",
    "ga4gh_passport_v1": [
        termsAndPolicies
    ]
}

input_expired := {
    "path": "api/ga4gh/individuals",
    "method": "GET",
    "ga4gh_passport_v1": [

        {
            "iss": "https://issuer.example1.org/oidc",
            "sub": "10001",
            "iat": 1580000300,
            "exp": 1612518923,
            "ga4gh_visa_v1": {
                "type": "AcceptedTermsAndPolicies",
                "asserted": 1549680000,
                "value": "https://doi.org/10.1038/s41431-018-0219-y",
                "source": "https://grid.ac/institutes/grid.240952.8",
                "by": "self"
            }
        },
        {
            "iat": 1580000100,
            "exp": 1612518923,
            "ga4gh_visa_v1": {
                "type": "ControlledAccessGrants",
                "asserted": 1549632872,
                "value": "https://ega-archive.org/datasets/710",
                "source": "https://grid.ac/institutes/grid.0000.0a",
                "by": "dac"
            }
        },
        {
            "iss": "https://other.example2.org/oidc",
            "sub": "abcd",
            "iat": 1580000400,
            "exp": 1612518923,
            "ga4gh_visa_v1": {
                "type": "ResearcherStatus",
                "asserted": 1549680000,
                "value": "https://doi.org/10.1038/s41431-018-0219-y",
                "source": "https://grid.ac/institutes/grid.240952.8",
                "by": "so"
            }
        }
    ]
}


input_researcher_faculty_only_710 := {
    "path": "api/ga4gh/individuals",
    "method": "GET",
    "ga4gh_passport_v1": [
        sevenTen, termsAndPolicies, researchStatus, facultyMember
    ]
}





test_ga4gh_get_with_header_controlled_710 {
    datasets := inputControlledAccess with input as input_researcher_only_710
    trace(format_int(count(datasets), 10))
    count(datasets) == 1
    
}

test_ga4gh_get_with_header_controlled_710_712 {
    datasets := inputControlledAccess with input as input_researcher_both_710_712
    trace(format_int(count(datasets), 10))
    count(datasets) == 2
    
}

test_ga4gh_get_with_header_registered {
    datasets := inputRegisteredAccess with input as input_researcher_both_710_712
    trace(format_int(count(datasets), 10))
    count(datasets) == 3
    
}

test_ga4gh_get_with_header_regular_with_710 {
    datasets := inputControlledAccess with input as input_regular_with_710
    trace(format_int(count(datasets), 10))
    count(datasets) == 1
    
}

test_ga4gh_get_with_header_regular_registered {
    datasets := inputRegisteredAccess with input as input_regular_with_710
    trace(format_int(count(datasets), 10))
    count(datasets) == 0
    
}

test_ga4gh_get_with_header_controlled_expired {
    datasets := inputControlledAccess with input as input_expired
    trace(format_int(count(datasets), 10))
    count(datasets) == 0
    
}

test_ga4gh_get_with_header_registered_expired {
    datasets := inputRegisteredAccess with input as input_expired
    trace(format_int(count(datasets), 10))
    count(datasets) == 0
    
}

test_ga4gh_get_with_header_faculty_controlled {
    datasets := inputFacultyControlled with input as input_researcher_faculty_only_710
    trace(format_int(count(datasets), 10))
    count(datasets) == 1
    
}

test_ga4gh_get_with_header_faculty_registered {
    datasets := inputFacultyRegistered with input as input_researcher_faculty_only_710
    trace(format_int(count(datasets), 10))
    count(datasets) == 3
}


