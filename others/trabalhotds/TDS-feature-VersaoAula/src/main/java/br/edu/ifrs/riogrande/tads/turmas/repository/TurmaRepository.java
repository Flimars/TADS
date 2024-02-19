package br.edu.ifrs.riogrande.tads.turmas.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import br.edu.ifrs.riogrande.tads.turmas.domain.entity.Turma;

@Repository
public interface TurmaRepository extends CrudRepository<Turma, String> {
    List<Turma> findAll();
    List<Turma> findByAno(String ano);
    List<Turma> findBySigla(String sigla);
    Turma findByCodigoTurma(String codigoTurma);

    
}