package ga4ghPassport
import data.paths

default allowed = false
default iss = "http://localhost:8080/auth/realms/mockrealm"
default aud = "mock_login_client"

default full_authn_pk=`-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlxY3PhZtA4ghjg19ndPIbuAyKIejBFouwp8KahT09EMFAZzPDWrzDpXTwgnJexhqVOuX2qUu0tsdnLyOwWpGl1iPVKzqsejeHXajfHNDFVbeU6FpFLPTgAjbhH02SX0VdkIMA6UU15fylfNeb4Yuw3+7l0aI5CaQLGWdbrirD6dWdOi8S6EZGcne/FEX4fqkcyOEy3SvuTVCsOCOCcY+XlzSndWXsNW9It3phFIq+cFwBmLbR6SFOlcgHwxANDNzXPQEGccyysnAS+Lm/9hFze88JfUOtCeFSxpBD1AcJlw/RbaiPVxGk6Xillhde5T1Sivp/3zx5A2CoxJ6lmfjnQIDAQAB
-----END PUBLIC KEY-----`

now := time.now_ns()/1000000000


allowed = passport {
    # retrieve authn/x token parts
    [authN_token_header, authN_token_payload, authN_token_signature] := io.jwt.decode(input.keycloak)

    # Verify authn/x token signature
    authN_token_is_valid := io.jwt.verify_rs256(input.keycloak, full_authn_pk)

    all([
        # Authentication
        authN_token_is_valid == true,
        authN_token_payload.aud[_] == aud,
        authN_token_payload.iss == iss,
        authN_token_payload.iat < now,
    ])
    # Return passport for Authorization parsing 
    passport := authN_token_payload.ga4gh_passport_v1
}


faculty {
    "AffiliationAndRole" == input.temp.ga4gh_visa_v1.type
    output := split(input.temp.ga4gh_visa_v1.value, "@")
    "faculty" == output[0]
}

student {
    "AffiliationAndRole" == input.temp.ga4gh_visa_v1.type
    [role, affiliation] := split(input.temp.ga4gh_visa_v1.value, "@")
    "student" == role
}

member {
    "AffiliationAndRole" == input.temp.ga4gh_visa_v1.type
    [role, affiliation] := split(input.temp.ga4gh_visa_v1.value, "@")
    "member" == role
}

researcherStatus {
    # trace(input.temp.type)
    "ResearcherStatus" == input.temp.ga4gh_visa_v1.type
    "https://doi.org/10.1038/s41431-018-0219-y" == input.temp.ga4gh_visa_v1.value
    # trace(format_int(now, 10))
    # trace(format_int(input.temp.exp, 10))
    now < input.temp.exp
}

acceptedTermsAndPolicies {
    "AcceptedTermsAndPolicies" == input.temp.ga4gh_visa_v1.type
    "https://doi.org/10.1038/s41431-018-0219-y" == input.temp.ga4gh_visa_v1.value
    now < input.temp.exp

}

controlledAccessGrants {
    "ControlledAccessGrants" == input.temp.ga4gh_visa_v1.type
    now < input.temp.exp
}

# Returns ONLY datasets with a "Public" access level
PublicAccess[allowedDataset] {
    some i,j
    # match data path/method with input path/method
    paths[i].path == input.path
    paths[i].method == input.method

    access_level := "Public"

    # return all datasets matching the access_level
    paths[i].datasets[j].access_level == access_level
    allowedDataset := paths[i].datasets[j].dataset
}


## Input functions take passports as a direct input. See input.json.X as an example ##

# Returns ONLY datasets with a "Registered" access level (passport contains researcherStatus and acceptedTermsAndPolicies visas)
inputRegisteredAccess[allowedDataset] {
    some i,j
    paths[i].path == input.path
    paths[i].method == input.method

    researcherStatus with input.temp as input.ga4gh_passport_v1[_]
    acceptedTermsAndPolicies with input.temp as input.ga4gh_passport_v1[_]

    access_level := "Registered"

    paths[i].datasets[j].access_level[_] == access_level
    allowedDataset := paths[i].datasets[j].dataset

}

# Returns ONLY datasets with a "Controlled" access level (Claim exists in a controlledAccessGrant visa)
inputControlledAccess[allowedDataset] {
    some i,j,k
    paths[i].path == input.path
    paths[i].method == input.method


    controlledAccessGrants with input.temp as input.ga4gh_passport_v1[k]

    access_level := "Controlled"
    

    paths[i].datasets[j].dataset == input.ga4gh_passport_v1[k].ga4gh_visa_v1.value
    paths[i].datasets[j].access_level[_] == access_level
    allowedDataset := paths[i].datasets[j].dataset

}

## Token rules take tokens as a direct input. See input.json as an example. ##

# Returns ONLY datasets with a "Registered" access level (passport contains researcherStatus and acceptedTermsAndPolicies visas)
tokenRegisteredAccess[allowedDataset] {
    some i,j
    paths[i].path == input.path
    paths[i].method == input.method

    passport = allowed


    researcherStatus with input.temp as passport[_]
    acceptedTermsAndPolicies with input.temp as passport[_]

    access_level := "Registered"

    paths[i].datasets[j].access_level[_] == access_level
    allowedDataset := paths[i].datasets[j].dataset

}

# Returns ONLY datasets with a "Controlled" access level (Claim exists in a controlledAccessGrant visa)
tokenControlledAccess[allowedDataset] {
    some i,j,k
    paths[i].path == input.path
    paths[i].method == input.method

    passport = allowed

    controlledAccessGrants with input.temp as passport[k]

    access_level := "Controlled"
    

    paths[i].datasets[j].dataset == passport[k].ga4gh_visa_v1.value
    paths[i].datasets[j].access_level[_] == access_level
    allowedDataset := paths[i].datasets[j].dataset

}



inputFacultyControlled = inputControlledAccess {
    faculty with input.temp as input.ga4gh_passport_v1[_]
    inputControlledAccess
} else = []

inputFacultyRegistered = inputRegisteredAccess {
    faculty with input.temp as input.ga4gh_passport_v1[_]
    inputRegisteredAccess
} else = []

