yaml = File.expand_path('../../google.yml', __FILE__)
GOOGLE_API_KEY = YAML.load(IO.read(yaml))['api_key']