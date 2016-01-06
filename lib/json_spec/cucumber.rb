require File.expand_path("../../json_spec", __FILE__)

World(JsonSpec::Helpers, JsonSpec::Matchers)

After do
  JsonSpec.forget
end

When /^(?:I )?keep the (?:JSON|json)(?: response)?(?: at "(.*)")? as "(.*)"$/ do |path, key|
  JsonSpec.memorize(key, normalize_json(last_json, path))
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be:$/ do |path, negative, json|
  if negative
    last_json.should_not be_json_eql(JsonSpec.remember(json)).at_path(path)
  else
    last_json.should be_json_eql(JsonSpec.remember(json)).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? with UUIDs should( not)? be:$/ do |path, negative, json|
  uuid_regexp = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
  time_regexp = /[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{3}Z/
  last_json_stripped_uuids = last_json.gsub(uuid_regexp, 'UUID').gsub(time_regexp, 'TIME')
  expected_json_stripped_uuids = json.gsub(uuid_regexp, 'UUID').gsub(time_regexp, 'TIME')
  if negative
    last_json_stripped_uuids.should_not be_json_eql(JsonSpec.remember(expected_json_stripped_uuids)).at_path(path)
  else
    last_json_stripped_uuids.should be_json_eql(JsonSpec.remember(expected_json_stripped_uuids)).at_path(path)
  end
end

Then /^in any order the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be:$/ do |path, negative, json|
  if negative
    last_json.should_not be_json_eql(JsonSpec.remember(json)).at_path(path).in_any_order
  else
    last_json.should be_json_eql(JsonSpec.remember(json)).at_path(path).in_any_order
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be file "(.+)"$/ do |path, negative, file_path|
  if negative
    last_json.should_not be_json_eql.to_file(file_path).at_path(path)
  else
    last_json.should be_json_eql.to_file(file_path).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be (".*"|\-?\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?|\[.*\]|%?\{.*\}|true|false|null)$/ do |path, negative, value|
  if negative
    last_json.should_not be_json_eql(JsonSpec.remember(value)).at_path(path)
  else
    last_json.should be_json_eql(JsonSpec.remember(value)).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? include:$/ do |path, negative, json|
  if negative
    last_json.should_not include_json(JsonSpec.remember(json)).at_path(path)
  else
    last_json.should include_json(JsonSpec.remember(json)).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? include file "(.+)"$/ do |path, negative, file_path|
  if negative
    last_json.should_not include_json.from_file(file_path).at_path(path)
  else
    last_json.should include_json.from_file(file_path).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? include (".*"|\-?\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?|\[.*\]|%?\{.*\}|true|false|null)$/ do |path, negative, value|
  if negative
    last_json.should_not include_json(JsonSpec.remember(value)).at_path(path)
  else
    last_json.should include_json(JsonSpec.remember(value)).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should have the following:$/ do |base, table|
  table.raw.each do |path, value|
    path = [base, path].compact.join("/")

    if value
      step %(the JSON at "#{path}" should be:), value
    else
      step %(the JSON should have "#{path}")
    end
  end
end

Then /^the (?:JSON|json)(?: response)? should( not)? have "(.*)"$/ do |negative, path|
  if negative
    last_json.should_not have_json_path(path)
  else
    last_json.should have_json_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be an? (.*)$/ do |path, negative, type|
  if negative
    last_json.should_not have_json_type(type).at_path(path)
  else
    last_json.should have_json_type(type).at_path(path)
  end
end

Then /^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? have (\d+)/ do |path, negative, size|
  if negative
    last_json.should_not have_json_size(size.to_i).at_path(path)
  else
    last_json.should have_json_size(size.to_i).at_path(path)
  end
end
