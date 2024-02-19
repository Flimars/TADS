package br.edu.ifrs.riogrande.tads.turmas.domain.dto;

import lombok.Data;

@Data
public class TurmaDTO {
    private String sigla;
    private String ano;
    private Integer semestre;
    private Integer maxVagas;
    private Integer minVagas;
    private String codigoTurma;
}
