class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nome
      t.string :email
      t.string :cliente
      t.string :uf
      t.string :telefone

      t.timestamps
    end
  end
end
