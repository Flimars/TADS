/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */
package apresentacao;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import com.mongodb.client.result.InsertOneResult;
import java.time.LocalDate;
import java.util.ArrayList;
import negocio.Cliente;
import negocio.Endereco;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;
import persistencia.ClienteDAO;
import java.util.List;

/**
 *
 * @author jean
 */
public class Main {

    public static void main(String[] args) {
        ClienteDAO clienteDAO = new ClienteDAO();
        clienteDAO.deletarTodosContatos(); // Limpa a base de dados para realizar os testes

        // Dados de Testes
        Cliente cliente1 = new Cliente("Contato 1b", "111111", LocalDate.now(), "loginTeste", "senhaTeste", new Endereco("RIO GRANDE", "rua1", "bairro1", "11", "compl1"));

        clienteDAO.inserir(cliente1); // teste criar cliente

        System.out.println("\nImprimindo os Cliente após INSERIR");
        clienteDAO.listar().forEach(d -> System.out.println(d));

    }
}
