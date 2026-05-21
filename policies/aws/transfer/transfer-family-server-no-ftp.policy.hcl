# Policy: Transfer.2 - Transfer Family servers should not use FTP protocol

policy {}

resource_policy "aws_transfer_server" "no_ftp_protocol" {
    locals {
        // Get protocols list, default to empty list if not specified
        // Note: If protocols is not specified, AWS defaults to SFTP which is compliant
        protocols = core::try(attrs.protocols, [])
        
        // Check if FTP is in the protocols list
        has_ftp = core::contains(local.protocols, "FTP")
        
        // Get allowed protocols for error message
        allowed_protocols = ["SFTP", "FTPS", "AS2"]
    }

    enforce {
        condition = !local.has_ftp
        error_message = "Transfer Family server uses insecure FTP protocol. FTP transmits data unencrypted, making it vulnerable to person-in-the-middle attacks. Use secure protocols instead: ${core::join(", ", local.allowed_protocols)}. Current protocols: ${core::join(", ", local.protocols)}. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/transfer-controls.html#transfer-2 for more details."
    }
}
