file = File.open(Rails.root.join("config", "firebase.yml").to_s)
firebase_url = YAML.load(file.read)['FIREBASE_URL']
file.close

FIREBASE = Firebase::Client.new(firebase_url)
