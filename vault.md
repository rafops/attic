# Vault

## Vault as a CA

I set up vault as a CA for a personal project and I find it to be significantly easier than using `openssl ca`. To be clear, I'm operating it with a very specific limited use case: intended purely to replace `openssl ca`, so it still involves admins needing to ssh into the "CA server" to use the command line tools locally. With that said, I was able to launch and fully configure a CA in under 30 minutes and issuing process is so much more intuitive and simple that it's well worth the time. Here's what I did:

1) use a very simple and "insecure" config file. Persist locally to disk and uses unencrypted loopback as the only interface. (the same security posture as `openssl ca`)

```storage "file" {
  path = "/Users/foobar/vault.data"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
}

disable_mlock = true
```
(edited)

2) `vault init -key-shares=1 -key-threshold=1` only need one shared key for unlocking the vault (same posture as `openssl ca`). I put the key and the root auth token into my password manager.
3)

`vault secrets enable pki` enable the PKI backend
`vault write pki/root/generate/internal common_name=foobar.com ttl=87600h` this would be different for you, given that you probably want to make a csr and sign it with the nulogy root CA, which would probably be the most tedious part of this whole operation, but still take less than 30 mins
`vault write pki/roles/client allow_any_name=true server_flag=false client_flag=true enforce_hostnames=false ttl=17532h` make a role - I needed client certs so this is the only role for my CA. It's very easy to make other roles for classic scenarios by just turning the flags on and off. The documentation here covers your options https://www.vaultproject.io/api/secret/pki/index.html#create-update-role , and it's significantly simpler than trying to decipher the documentation for and write an openssl.cnf (edited)
4) `vault write pki/sign/client csr=@client.csr` issue a cert, wow that's easy
need to list all your certs? `vault list pki/certs`
need to view a cert you've issued? `vault read pki/cert/65-9a-b3-cb-03-04-a0-06-67-50-06-86-ea-5f-3c-fb-34-b1-12-cd`
need backups? just a cron job that uploads `/Users/foobar/vault.data` (in my case) to s3. It's already encrypted at rest.
