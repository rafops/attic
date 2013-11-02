Mercado Libre API
=================

The very first step that you should take is to create an Application with the same account that you use to manage your products:

  http://applications.mercadolibre.com

After this, you should be provided with both the 'App ID' and 'Secret Key' credentials. The big insight for Desktop (offline) applications, is to exchange your credentials for a Token, so you will not need to use the Oauth2 flow:

  curl -X POST -v -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=client_credentials&client_id=YOUR_APP_ID&client_secret=YOUR_APP_SECRET_KEY" https://api.mercadolibre.com/oauth/token

As the response for this API call, you should receive your token, as following:

  {"access_token":"APP_USR-519995259447630-032207-acfd4f83595c2cb44153b7211f6a2cf5__J_D__-123456789","token_type":"bearer","expires_in":21600,"scope":"offline_access read write","refresh_token":"TG-531e3405e4c024e529a8a823"}

With this access_token, now you can view your profile with one API call:

  curl https://api.mercadolibre.com/users/me?access_token=APP_USR-519995259447630-032207-acfd4f83595c2cb44153b7211f6a2cf5__J_D__-123456789

And the response should give you your account details and your user id:

  {"id":123456789,"nickname":"MYUSERNAME"...

At this stage, you should be able to list your products with this simple API call:

  curl https://api.mercadolibre.com/users/123456789/items/search?access_token=APP_USR-519995259447630-032207-acfd4f83595c2cb44153b7211f6a2cf5__J_D__-123456789

And the response will return something like:

  {"seller_id":"123456789","query":null,"paging":{"total":1,"offset":0,"limit":50},"results":["MLB987654321"], ...

The parameter 'results' will tell you what are your listed product IDs, so if you need, you can view its details with this API call:

  curl https://api.mercadolibre.com/items/MLB987654321

And finally, to update the price for one product:

  curl -X PUT -H "Content-Type: application/json" -H "Accept: application/json" -d '{"price": 199.90}' https://api.mercadolibre.com/items/MLB987654321?access_token=APP_USR-519995259447630-032207-acfd4f83595c2cb44153b7211f6a2cf5__J_D__-123456789

Important: Your access_token will expire under inactivity or after its lifetime (expires_in). Because of that, you should always verify the API response of your requests, because it can return something like:

  {"message":"expired_token","cause":[],"error":"not_found","status":401}

And so you will need to exchange again your credentials for a new access_token.