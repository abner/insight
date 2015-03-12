# language: pt

@javascript
Funcionalidade: Gerenciar os Feedbacks Targets
  Como um usuário da aplicação de Feedback
  Com o objetivo de agrupar meus formulários de Feedback
  Eu quero gerenciar meus Feedback Targets
  Que serão utilizados como centralizadores do meus Formulários

  Cenário: Listar Feedback Targets
    Dado que eu sou um usuário autenticado
    E eu acesse a tela Feedback Targets
    Entao Eu devo ver a listagem com meus Feedback Targets

  Cenário: Criar um Feedback Target
    Dado que eu sou um usuário autenticado
    E eu acesse a tela Feedback Targets
    E clico no link "Adicionar uma nova Aplicação"
    Então eu vejo a tela "Nova Aplicação"
    E preencho o campo "Nome" com "Minha nova aplicação"
    E clico no botão "Salvar"
    Então eu vejo a tela "Minhas Aplicações"
    E vejo a mensagem de sucesso "Aplicação criada!"
