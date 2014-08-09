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
