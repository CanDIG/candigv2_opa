package candig_access
import data.paths


# This will eventually need to be converted to a template form similar to the permissions.rego rather than have these values hardcoded

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


allow_with_token[datasets] {
    some i, j
    paths[i].path == input.path
    paths[i].method == input.method
    [header, payload, _] := io.jwt.decode(input.user_tokens["X-Candig-Local-Vault"])
    payload.aud == "mock_login_client"
    datasets := [allowDataset | "ControlledAccessGrants" == payload.ga4gh_passport_v1.ga4gh_visa_v1.type
                        passportDataset := payload.ga4gh_passport_v1.ga4gh_visa_v1.value[paths[i].datasets[j].dataset]
                        paths[i].datasets[j].access_level <= passportDataset.access
                        allowDataset := paths[i].datasets[j].dataset]
}


allow_with_header[allowDataset] {
    # payload := input
    some i, j
    paths[i].path == input.path
    paths[i].method == input.method


    "ControlledAccessGrants" == input.ga4gh_passport_v1[k].ga4gh_visa_v1.type
    trace(paths[i].datasets[j].dataset)
    passportDataset := input.ga4gh_passport_v1[k].ga4gh_visa_v1.value[paths[i].datasets[j].dataset]
    paths[i].datasets[j].access_level <= passportDataset.access
    allowDataset := paths[i].datasets[j].dataset
}

allow_with_header_REMS[allowDataset] {
    # payload := input
    some i, j
    paths[i].path == input.body.path
    paths[i].method == input.body.method


    "ControlledAccessGrants" == input.headers["X-Candig-Ext-Rems"].ga4gh_passport_v1[k].ga4gh_visa_v1.type
    trace(paths[i].datasets[j].dataset)
    passportDataset := input.ga4gh_passport_v1[k].ga4gh_visa_v1.value[paths[i].datasets[j].dataset]
    paths[i].datasets[j].access_level <= passportDataset.access
    allowDataset := paths[i].datasets[j].dataset
}
