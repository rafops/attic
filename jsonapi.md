REQUEST

curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"data": {"type":"contacts", "attributes":{"name-first":"John", "name-last":"Doe", "email":"john.doe@boring.test"}}}' http://localhost:3000/contacts

RESPONSE

{"data":{"id":"1","type":"contacts","links":{"self":"http://localhost:3000/contacts/1"},"attributes":{"name-first":"John","name-last":"Doe","email":"john.doe@boring.test","twitter":null},"relationships":{"phone-numbers":{"links":{"self":"http://localhost:3000/contacts/1/relationships/phone-numbers","related":"http://localhost:3000/contacts/1/phone-numbers"}}}}}

^^^ I dont think it gets the phone number yet.

UPDATE

curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{ "data": { "type": "phone-numbers", "relationships": { "contact": { "data": { "type": "contacts", "id": "1" } } }, "attributes": { "name": "home", "phone-number": "(603) 555-1212" } } }' http://localhost:3000/phone-numbers

RESPONSE

{"data":{"id":"1","type":"phone-numbers","links":{"self":"http://localhost:3000/phone-numbers/1"},"attributes":{"name":"home","phone-number":"(603) 555-1212"},"relationships":{"contact":{"links":{"self":"http://localhost:3000/phone-numbers/1/relationships/contact","related":"http://localhost:3000/phone-numbers/1/contact"},"data":{"type":"contacts","id":"1"}}}}}

QUERY

curl -i -H "Accept: application/vnd.api+json" "http://localhost:3000/contacts"

RESPONSE

{"data":[{"id":"1","type":"contacts","links":{"self":"http://localhost:3000/contacts/1"},"attributes":{"name-first":"John","name-last":"Doe","email":"john.doe@boring.test","twitter":null},"relationships":{"phone-numbers":{"links":{"self":"http://localhost:3000/contacts/1/relationships/phone-numbers","related":"http://localhost:3000/contacts/1/phone-numbers"}}}}]}
