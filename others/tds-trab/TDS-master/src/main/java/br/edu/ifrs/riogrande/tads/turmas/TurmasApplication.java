package br.edu.ifrs.riogrande.tads.turmas;

import java.sql.Connection;
import java.sql.DriverManager;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.zaxxer.hikari.HikariDataSource;

// import br.edu.ifrs.riogrande.tads.turmas.controller.TurmaController;
// import br.edu.ifrs.riogrande.tads.turmas.domain.entity.Turma;
// import br.edu.ifrs.riogrande.tads.turmas.repository.TurmaRepository;

@SpringBootApplication
public class TurmasApplication {

	public static void main(String[] args) {
		SpringApplication.run(TurmasApplication.class, args);
	}

	@PreDestroy
	void limpar() {
		System.out.println("Rodando o Pre Destroy");
	}

	@PostConstruct
	void popularBanco() {
		System.out.println("Rodando o Post Construct");
	}	
}
