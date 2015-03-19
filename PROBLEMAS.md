# Problemas

 ** Listando alguns problemas encontrados durante o projeto e as soluções que foram dadas**
#### - usando devise com mongoid 3.0.4 tive o seguinte problema:
```
application successful working with mongoid, after install devise I try to login in application but got error
  The operation: #{"_id"=>{"$oid"=>BSON::ObjectId('5333276a6d6163c871000000')}}, "$orderby"=>{:_id=>1}} @fields=nil> failed with error 10068: "invalid operator: $oid"
```

Solução:
Conforme apontado em https://github.com/plataformatec/devise/issues/2949,
adotei as seguintes medidas:
 - alterei a versão da gem devise para **3.2.4**
 - adicionei o seguinte código na classe user

    ```ruby
    class << self
      def serialize_into_session(record)
        [record.id.to_s, record.authenticatable_salt]
      end
    end
    ```
   Outras soluções apontadas em: http://stackoverflow.com/questions/23092181/mongodb-error-code-10068-or-17287-with-rails-4-1-and-devise


### Problemas com o DatabaseCleaner rodando antes do teste  Capybara/Poltergeist terminar
https://github.com/DatabaseCleaner/database_cleaner/issues/273
http://stackoverflow.com/questions/14881011/rails-rspec-capybara-and-databasecleaner-using-truncation-only-on-feature-test
http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
https://github.com/rspec/rspec-core/issues/903
https://github.com/jnicklas/capybara/issues/1089#issuecomment-18312017
https://github.com/jnicklas/capybara/issues/1089

Solução tomada: Sempre testar have_content ou have_selector ao fim do teste.
Forçando assim com que o teste aguarde o carregamento da última página navegada
