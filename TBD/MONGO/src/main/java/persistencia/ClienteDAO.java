/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package persistencia;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import static com.mongodb.client.model.Filters.eq;
import com.mongodb.client.model.UpdateOptions;
import com.mongodb.client.model.Updates;
import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.InsertOneResult;
import com.mongodb.client.result.UpdateResult;
import java.util.ArrayList;
import org.bson.Document;
import static org.bson.codecs.configuration.CodecRegistries.fromProviders;
import static org.bson.codecs.configuration.CodecRegistries.fromRegistries;
import org.bson.codecs.configuration.CodecRegistry;
import org.bson.codecs.pojo.PojoCodecProvider;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;

import negocio.Cliente;
import negocio.Endereco;

/**
 *
 * @author jean
 */
public class ClienteDAO {

    private final String uri;
    private MongoCollection<Cliente> contatoCollection;
    private final String dbname;
    private final String collectionName;
    private final MongoClientSettings clientSettings;

    public ClienteDAO() {
        this.uri = "mongodb://localhost:27017";
        this.dbname = "cliente";
        this.collectionName = "clientes";
        ConnectionString connectionString = new ConnectionString(this.uri);
        CodecRegistry pojoCodecRegistry = fromProviders(PojoCodecProvider.builder().automatic(true).build());
        CodecRegistry codecRegistry = fromRegistries(MongoClientSettings.getDefaultCodecRegistry(), pojoCodecRegistry);
        this.clientSettings = MongoClientSettings.builder()
                .applyConnectionString(connectionString)
                .codecRegistry(codecRegistry)
                .build();

    }

    public ArrayList<Cliente> listar() {

        try ( MongoClient mongoClient = MongoClients.create(this.clientSettings)) {
            MongoDatabase db = mongoClient.getDatabase(this.dbname);
            this.contatoCollection = db.getCollection(this.collectionName, Cliente.class);
            ArrayList<Cliente> vetContato = new ArrayList<>();
            MongoCursor<Cliente> mongoCursor = contatoCollection.find().iterator();
            while (mongoCursor.hasNext()) {
                vetContato.add(mongoCursor.next());
            }
            return vetContato;
        }

    }

    public void inserir(Cliente contato) {

        try ( MongoClient mongoClient = MongoClients.create(this.clientSettings)) {
            MongoDatabase db = mongoClient.getDatabase(this.dbname);
            this.contatoCollection = db.getCollection(this.collectionName, Cliente.class);
            contatoCollection.insertOne(contato);
        }

    }

    public void deletarTodosContatos() {

        try ( MongoClient mongoClient = MongoClients.create(this.clientSettings)) {
            MongoDatabase db = mongoClient.getDatabase(this.dbname);
            this.contatoCollection = db.getCollection(this.collectionName, Cliente.class);
            Bson filter = new Document();
            DeleteResult deleteResult = contatoCollection.deleteMany(filter);
        }
    }

}
