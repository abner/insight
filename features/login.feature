# language: pt

@javascript
Funcionalidade: Login do Usuário
  Como um usuário
  Com o objetivo de acessar a aplicação de Feedback
  Eu quero efetuar o login na aplicação

  Cenário: Login com sucesso
    Dado que eu acesse a tela de login
    Quando eu informo meu login "joao" e minha senha "ninguem"
    E clico "Login"
    Entao Eu devo ser redirecionado a lista de Minhas Aplicações

  Cenário: Login com credenciais incorretas
    Dado que eu acesse a tela de login
    E informe credencias erradas
    E clico "Login"
    Entao vejo mensagem de erro "Erro na autenticação. Verifique se o nome de usuário (CPF) ou senha estão corretos"
