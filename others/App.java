import java.math.BigInteger;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.security.MessageDigest;
import java.util.Random;

public class App {
    public static void main(String[] args) throws Exception {
        String MARVEL_PUBLIC_API_KEY= "3bb285e82024ac3ae2bfbc12604d7a14";
        String MARVEL_PRIVATE_API_KEY ="c06300d11e31dda72e89d99fd7d462a20c478219";
        int ts = new Random().nextInt();
        String hash = ts + MARVEL_PRIVATE_API_KEY + MARVEL_PUBLIC_API_KEY;

        MessageDigest m = MessageDigest.getInstance("MD5");
        m.update(hash.getBytes(),0,hash.length());
        //System.out.println("MD5: "+new BigInteger(1,m.digest()).toString(16));
        String md5Hash = new BigInteger(1,m.digest()).toString(16);
        System.out.println("MD5: "+md5Hash);
        
        var url = "https://gateway.marvel.com/v1/public/comics?ts="+ts+"&apikey="+MARVEL_PUBLIC_API_KEY+"&hash="+md5Hash;

        HttpRequest request = HttpRequest.newBuilder(URI.create(url)).GET().build();
        HttpClient client = HttpClient.newHttpClient();
        var response = client.send(request, HttpResponse.BodyHandlers.ofString());
        
        System.out.println(response.body());
    }
}
