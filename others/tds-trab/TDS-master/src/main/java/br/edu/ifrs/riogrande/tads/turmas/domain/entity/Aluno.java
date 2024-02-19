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
@Table(name = "alunos")
@Data //gera Getter, Setter, toString
public class Aluno {
    @Column(nullable = false)
    private String nome;

    @Id
    @Column(nullable = false)
    private String cpf;

    @ManyToMany
    private List<Turma> turmas = new ArrayList<>();
}
