# Let's Encrypt

## New Certificate

Install certbot:

	sudo snap install --classic certbot

Generate wildcard certificate:

	sudo certbot certonly --manual --preferred-challenges=dns --email example@example.com --agree-tos -d *.example.com

Create the TXT record and press Enter to continue certbot validation.

Certificates will be stored in `/etc/letsencrypt/live/example.com/`.
