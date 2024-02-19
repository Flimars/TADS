/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package src.tdb_neo4j;

import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.Driver;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import static org.neo4j.driver.Values.parameters;
import java.time.LocalDate;

/**
 *
 * @author jean
 */
public class Persistencia implements AutoCloseable {

    public final Driver driver;

    public Persistencia() {
        driver = GraphDatabase.driver("bolt://localhost:7687", AuthTokens.basic("neo4j", "password"));
    }

    public void criarCliente(String cpf, String nome, String email, String senha, LocalDate dataNascimento) {
        try ( Session session = driver.session()) {
            session.writeTransaction(tx -> {
                tx.run("CREATE (:Cliente {cpf: $cpf, nome: $nome, email: $email, senha: $senha, dataNascimento: $dataNascimento})",
                        parameters("cpf", cpf, "nome", nome, "email", email, "senha", senha, "dataNascimento", dataNascimento));
                return null;
            });
        }
    }

    public void criarDependente(String cpf, String nome) {
        try ( Session session = driver.session()) {
            session.writeTransaction(tx -> {
                tx.run("CREATE (:Dependente {cpf: $cpf, nome: $nome})",
                        parameters("cpf", cpf, "nome", nome));
                return null;
            });
        }
    }

    //cpf 1 dependente | cpf 2 titular
    public void definirTitular(String cpf1, String cpf2) {
        try ( Session session = driver.session()) {
            session.writeTransaction(tx -> {
                tx.run("MATCH (p1:Dependente {cpf: $cpf1}), (p2:Cliente {cpf: $cpf2}) CREATE (p1)-[:Dependente]->(p2)",
                        parameters("cpf1", cpf1, "cpf2", cpf2));
                return null;
            });
        }
    }

    public void limparBancoDeDados() {
        try ( Session session = driver.session()) {
            session.writeTransaction(tx -> {
                // Exclui todos os nós e relacionamentos no banco de dados
                tx.run("MATCH (n) DETACH DELETE n");
                return null;
            });
        }
    }

    @Override
    public void close() throws Exception {
        driver.close();
    }
}
