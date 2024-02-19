package br.edu.ifrs.riogrande.tads.turmas.domain.service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import br.edu.ifrs.riogrande.tads.turmas.domain.dto.AlunoDTO;
import br.edu.ifrs.riogrande.tads.turmas.domain.dto.TurmaDTO;
import br.edu.ifrs.riogrande.tads.turmas.domain.entity.Aluno;
import br.edu.ifrs.riogrande.tads.turmas.domain.entity.Turma;
import br.edu.ifrs.riogrande.tads.turmas.repository.AlunoRepository;
import br.edu.ifrs.riogrande.tads.turmas.repository.TurmaRepository;

@Service
public class TurmaService {

  private final TurmaRepository turmaRepository;
  private final AlunoRepository alunoRepository;

  public TurmaService(TurmaRepository turmaRepository, AlunoRepository alunoRepository) {
    this.turmaRepository = turmaRepository;
    this.alunoRepository = alunoRepository;
  }

  private TurmaDTO converteDTO(Turma turma) {
    TurmaDTO dto = new TurmaDTO();
    BeanUtils.copyProperties(turma, dto);
    return dto;
  }

  private Turma converteEntity(TurmaDTO dto) {
    Turma turma = new Turma();
    BeanUtils.copyProperties(dto, turma);
    return turma;
  }

  public TurmaDTO save(TurmaDTO turmaDTO) {
    Turma turma = converteEntity(turmaDTO);
    return converteDTO(turmaRepository.save(turma));
  }
  
  public List<TurmaDTO> findAll() {
    return turmaRepository.findAll().stream()
        .map(this::converteDTO)
        .collect(Collectors.toList());
  }

  public List<Turma> listarTurmasPorSigla(String sigla) {
    return turmaRepository.findBySigla(sigla);
  }

  public Turma listarTurmasPorCodigo(String codigoTurma) {
    return turmaRepository.findByCodigoTurma(codigoTurma);
  }

  public List<Turma> listarTurmasPorAno(String ano) {
    return turmaRepository.findByAno(ano);
  }

  public TurmaDTO adicionarAluno(String codigoTurma, AlunoDTO alunoDTO) {
    Turma turma = turmaRepository.findByCodigoTurma(codigoTurma);
    Aluno aluno = alunoRepository.findByCpf(alunoDTO.getCpf());

    if(turma.getAlunos().size() > 0){
      turma.getAlunos().add(aluno);
    }else{
      List<Aluno> alunos = new ArrayList<Aluno>();
      alunos.add(aluno);
      turma.setAlunos(alunos);
    }
    turmaRepository.save(turma);    
    return converteDTO(turma);
  }
}
