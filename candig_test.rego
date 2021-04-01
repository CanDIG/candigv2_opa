package candig_access

input_correct := {
    "path": "api/individuals",
    "method": "GET",
    "ga4gh_passport_v1": [
        {
            "ga4gh_visa_v1": {
                "type": "ControlledAccessGrants",
                "value": {
                    "dataset123": {
                        "access": "4"
                    },
                    "dataset1123": {
                        "access": "4"
                    }
                }
            }
        }
    ]
}

input_low_access := {
    "path": "api/individuals",
    "method": "GET",
    "ga4gh_passport_v1": [
        {
            "ga4gh_visa_v1": {
                "type": "ControlledAccessGrants",
                "value": {
                    "dataset123": {
                        "access": "1"
                    },
                    "dataset1123": {
                        "access": "1"
                    }
                }
            }
        }
    ]
}

input_wrong_path := {
    "path": "api/v2/individuals",
    "method": "GET",
    "ga4gh_passport_v1": [
        {
            "ga4gh_visa_v1": {
                "type": "ControlledAccessGrants",
                "value": {
                    "dataset123": {
                        "access": "1"
                    },
                    "dataset1123": {
                        "access": "1"
                    }
                }
            }
        }
    ]
}

input_post := {
    "path": "api/individuals",
    "method": "POST",
    "ga4gh_passport_v1": [
        {
            "ga4gh_visa_v1": {
                "type": "ControlledAccessGrants",
                "value": {
                    "dataset123": {
                        "access": "4"
                    },
                    "dataset321": {
                        "access": "2"
                    }
                }
            }
        }
    ]
}


test_get_with_header {
    datasets := allow_with_header with input as input_correct
    trace(format_int(count(datasets), 10))
    count(datasets) == 2
    
}

test_get_with_header_access_1 {
    datasets := allow_with_header with input as input_low_access
    trace(format_int(count(datasets), 10))
    count(datasets) == 0
    
}

test_get_with_header_bad_path {
    datasets := allow_with_header with input as input_wrong_path
    trace(format_int(count(datasets), 10))
    count(datasets) == 0
    
}


test_post_with_header {
    datasets := allow_with_header with input as input_post
    count(datasets) == 0
}