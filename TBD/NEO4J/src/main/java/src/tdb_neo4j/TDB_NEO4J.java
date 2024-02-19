/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */
package src.tdb_neo4j;

import org.neo4j.driver.*;

import static org.neo4j.driver.Values.parameters;
import java.time.LocalDate;

/**
 *
 * @author jean
 */
public class TDB_NEO4J {

    public static void main(String[] args) {
        try ( Persistencia dao = new Persistencia()) {

            // ZERANDO O BANCO DE DADOS!!
            dao.limparBancoDeDados();

            dao.criarCliente("12345678901", "João", "joao@email.com", "senha123", LocalDate.now());
            dao.criarDependente("12345678902", "Maria");
            dao.criarDependente("12345678903", "Clara");
            dao.criarDependente("12345678904", "Ana");

            dao.definirTitular("12345678902", "12345678901");
            dao.definirTitular("12345678903", "12345678901");
            dao.definirTitular("12345678904", "12345678901");
          
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
