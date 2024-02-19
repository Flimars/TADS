package br.edu.ifrs.riogrande.tads.turmas.domain.entity;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.Table;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Pattern;

@Entity
@Table(name = "turmas")
@Data //gera Getter, Setter, toString
public class Turma {
    @Id
    @Column(nullable = false)
    @Pattern(regexp = "[A-Za-z]{3}-\\d{4}-[1-2]")
    private String codigoTurma;

    @Column(nullable = false)
    private String sigla;

    @Column(nullable = false)
    @Pattern(regexp = "\\d{4}")
    private String ano;

    @Column(nullable = false)
    @Min(1)
    @Max(2)
    private Integer semestre;

    @Column(nullable = false)
    @Min(1)
    @Max(100)
    private Integer maxVagas;

    @Column(nullable = false)
    @Min(1)
    @Max(100)
    private Integer minVagas;

    @ManyToMany
    private List<Aluno> alunos = new ArrayList<>();
}
