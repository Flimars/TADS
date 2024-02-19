package br.edu.ifrs.riogrande.tads.turmas.domain.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import br.edu.ifrs.riogrande.tads.turmas.domain.dto.AlunoDTO;
import br.edu.ifrs.riogrande.tads.turmas.domain.entity.Aluno;
import br.edu.ifrs.riogrande.tads.turmas.repository.AlunoRepository;

@Service
public class AlunoService {

  private final AlunoRepository alunoRepository;

  public AlunoService(AlunoRepository alunoRepository) {
    this.alunoRepository = alunoRepository;
  }

  private AlunoDTO converteDTO(Aluno aluno) {
    AlunoDTO dto = new AlunoDTO();
    BeanUtils.copyProperties(aluno, dto);
    return dto;
  }

  private Aluno converteEntity(AlunoDTO dto) {
    Aluno aluno = new Aluno();
    BeanUtils.copyProperties(dto, aluno);
    return aluno;
  }

  public List<AlunoDTO> findAll() {
    return alunoRepository.findAll().stream()
        .map(this::converteDTO)
        .collect(Collectors.toList());
  }

  public AlunoDTO save(AlunoDTO alunoDTO) {
    Aluno aluno = converteEntity(alunoDTO);
    return converteDTO(alunoRepository.save(aluno));
  }
  

  public Aluno listarAlunosPorCpf(String cpf) {
    return alunoRepository.findByCpf(cpf);
  }
}
