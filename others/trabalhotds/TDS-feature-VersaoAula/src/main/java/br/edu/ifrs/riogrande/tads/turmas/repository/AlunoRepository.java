package br.edu.ifrs.riogrande.tads.turmas.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import br.edu.ifrs.riogrande.tads.turmas.domain.entity.Aluno;

@Repository
public interface AlunoRepository extends CrudRepository<Aluno, String> {
    List<Aluno> findAll();
    Aluno findByCpf(String cpf);

    @Query("SELECT a FROM Aluno a JOIN FETCH a.turmas WHERE a.cpf = :cpf")
    Aluno findByCpfWithTurmas(@Param("cpf") String cpf);
}