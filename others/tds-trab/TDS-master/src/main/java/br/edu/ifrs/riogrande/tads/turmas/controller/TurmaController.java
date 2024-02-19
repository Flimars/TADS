package br.edu.ifrs.riogrande.tads.turmas.controller;

import java.util.List;
import java.util.Objects;

import javax.validation.Valid;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import br.edu.ifrs.riogrande.tads.turmas.domain.dto.TurmaDTO;
import br.edu.ifrs.riogrande.tads.turmas.domain.entity.Turma;
import br.edu.ifrs.riogrande.tads.turmas.domain.service.TurmaService;
import br.edu.ifrs.riogrande.tads.turmas.repository.TurmaRepository;

@Validated
@RequestMapping("/api/v1/turmas")
@RestController
public class TurmaController {
  private TurmaService turmaService;

  public TurmaController(TurmaService turmaService) {
    this.turmaService = turmaService;
  }

  @GetMapping
  public ResponseEntity<List<TurmaDTO>> findAll() {
    return ResponseEntity.ok(turmaService.findAll());
  }

  @PostMapping
  public TurmaDTO save(@Valid @RequestBody TurmaDTO turmaDTO) {
    return turmaService.save(turmaDTO);
  }

  @GetMapping(params = "ano")
  public List<Turma> filtrarPorAno(@RequestParam String ano) {
      return turmaService.listarTurmasPorAno(ano);
  }

  @GetMapping(params = "sigla")
  public List<Turma> filtrarPorSigla(@RequestParam String sigla) {
      return turmaService.listarTurmasPorSigla(sigla);
  }

  @GetMapping(params = "codigoTurma")
  public Turma filtrarPorCodigoTurma(@RequestParam String codigoTurma) {
      return turmaService.listarTurmasPorCodigo(codigoTurma);
  }
}
