# language: pt

#@javascript
Funcionalidade: Login do Usuário
  Como um usuário
  Com o objetivo de acessar a aplicação de Feedback
  Eu quero efetuar o login na aplicação

#  Cenário: Login com sucesso
#    Dado que eu acesse a tela de login
#    Quando eu informo meu login "joao" e minha senha "ninguem"
#    E clico no botão "Login"
#    Entao Eu devo ser redirecionado a lista de Minhas Aplicações

#  Cenário: Login com credenciais incorretas
#    Dado que eu acesse a tela de login
#    E informe credencias erradas
#    E clico no botão "Login"
#    Entao vejo mensagem de erro "Erro na autenticação. Verifique se o nome de usuário (CPF) ou senha estão corretos"

  Cenário: Test Pickle
    Dado que um usuário existe com username: "jo", password: "jo"
    #Então um usuario com username "teo" deve existir
