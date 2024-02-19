package br.edu.ifrs.riogrande.tads.turmas.controller;

import java.util.List;
import java.util.Objects;

import javax.validation.Valid;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import br.edu.ifrs.riogrande.tads.turmas.domain.dto.AlunoDTO;
import br.edu.ifrs.riogrande.tads.turmas.domain.dto.TurmaDTO;
import br.edu.ifrs.riogrande.tads.turmas.domain.entity.Aluno;
import br.edu.ifrs.riogrande.tads.turmas.domain.service.AlunoService;
import br.edu.ifrs.riogrande.tads.turmas.repository.TurmaRepository;

@Validated
@RequestMapping("/api/v1/alunos")
@RestController
public class AlunoController {
  private AlunoService alunoService;

  public AlunoController(AlunoService alunoService) {
    this.alunoService = alunoService;
  }

  @GetMapping
  public ResponseEntity<List<AlunoDTO>> findAll() {
    return ResponseEntity.ok(alunoService.findAll());
  }

  @PostMapping
  public AlunoDTO save(@Valid @RequestBody AlunoDTO alunoDTO) {
    return alunoService.save(alunoDTO);
  }

  @GetMapping(params = "cpf")
  public Aluno filtrarPorAno(@RequestParam String cpf) {
      return alunoService.listarAlunosPorCpf(cpf);
  }

  @GetMapping(path = "/{cpf}/turmas")
  public List<TurmaDTO> listarTurmas(@PathVariable("cpf") String cpf) {
      return alunoService.listarTurmas(cpf);
  }

}
