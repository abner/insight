json.array!(@users) do |user|
  json.extract! user, :id, :nome, :email, :cliente, :uf, :telefone
  json.url user_url(user, format: :json)
end
