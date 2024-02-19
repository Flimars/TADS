package br.edu.ifrs.riogrande.tads.turmas.domain.dto;

import java.util.List;

import br.edu.ifrs.riogrande.tads.turmas.domain.entity.Aluno;
import lombok.Data;

@Data
public class TurmaDTO {
    private String sigla;
    private String ano;
    private Integer semestre;
    private Integer maxVagas;
    private Integer minVagas;
    private String codigoTurma;
    private List<Aluno> alunos;
}
