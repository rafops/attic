  # Document.where("'{}'::jsonb @> '{}'").first
  # Document.where("'" + {}.to_json + "'::jsonb @> '{}'").first
  # ActiveRecord::Base.connection.execute("SELECT json_array_length('[1,2,3]')").first
  # ActiveRecord::Base.connection.execute("SELECT * FROM json_each('" + {a:2,b:3}.to_json + "')").first
  # ActiveRecord::Base.connection.execute("SELECT '" + {a:1}.to_json + "'::jsonb#>'{a}' AS x").first
  # Document.where("data -> 'info' ->> 'name' = 'TRC160110003'").first
  # Document.select("data#>'{info,tags}' AS tags").where("data -> 'info' ->> 'name' = 'TRC160110003'").first['tags']
  # ActiveRecord::Base.connection.execute("SELECT * FROM jsonb_each_text('" + {a:2,b:3}.to_json + "'::jsonb) WHERE value = '2'").to_a
  # Document.select("jsonb_each_text(data#>'{info,tags}') AS tags").where("data -> 'info' ->> 'name' = 'TRC160110003'").first['tags']
  # select * from json_to_record('{"a":1,"b":[1,2,3],"c":"bar"}') as x(a int, b text, d text)
  
  # ActiveRecord::Base.connection.execute("SELECT id FROM documents, jsonb_each_text(documents.data#>'{info,tags}')")[0]
  # Document.where("id IN (SELECT id FROM documents, jsonb_each_text(documents.data#>'{info,tags}') AS tags WHERE tags.value IN (?))", ['xenon', 'chicken'])