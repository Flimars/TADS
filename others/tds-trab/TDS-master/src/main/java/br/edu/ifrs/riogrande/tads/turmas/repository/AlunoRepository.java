package br.edu.ifrs.riogrande.tads.turmas.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import br.edu.ifrs.riogrande.tads.turmas.domain.entity.Aluno;

@Repository
public interface AlunoRepository extends CrudRepository<Aluno, Integer> {
    List<Aluno> findAll();
    Aluno findByCpf(String cpf);
}