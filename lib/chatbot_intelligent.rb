# ligne très importante qui appelle les gems.
require 'http'
require 'json'
require 'dotenv'# Appelle la gem Dotenv

# n'oublie pas les lignes pour Dotenv ici…
Dotenv.load('.env')



def converse_with_ai
  # création de la clé d'api et indication de l'url utilisée.
  api_key = ENV["OPENAI_API_KEY"]
  url = "https://api.openai.com/v1/engines/text-davinci-003/completions"

  # un peu de json pour faire la demande d'autorisation d'utilisation à l'api OpenAI
  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{api_key}"
  }
  conversation_history = ""

  loop do
    #historique de la conversation
    print "Vous: "
    user_input = gets.chomp
    conversation_history += "#{user_input}\n "
    break if user_input.downcase == "stop"

    # un peu de json pour envoyer des informations directement à l'API
    data = {
      "prompt" => conversation_history,
      "max_tokens" => 150,
      "n" => 1,
      "temperature" => 0.1
    }

    # une partie un peu plus complexe :
    # - cela permet d'envoyer les informations en json à ton url
    # - puis de récupéré la réponse puis de séléctionner spécifiquement le texte rendu
    response = HTTP.post(url, headers: headers, body: data.to_json)
    response_body = JSON.parse(response.body.to_s)
    response_string = response_body['choices'][0]['text'].strip
    conversation_history += "Bot: #{response_string}\n"
    print "#{response_string}\n"
  
  end
end
converse_with_ai