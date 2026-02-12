package ec.edu.espe.ms_clientes.controllers;

import ec.edu.espe.ms_clientes.dto.requests.PersonaJuridicaRequestDTO;
import ec.edu.espe.ms_clientes.dto.requests.PersonaNaturalRequestDTO;
import ec.edu.espe.ms_clientes.dto.responses.PersonaResponseDTO;
import ec.edu.espe.ms_clientes.services.PersonaService;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/personas")
@CrossOrigin(origins = "*")
@Slf4j
public class PersonaController {
    
    @Autowired
    private PersonaService personaService;
    
    // CREAR PERSONA NATURAL
    @PostMapping("/natural")
    public ResponseEntity<PersonaResponseDTO> crearPersonaNatural(
            @Valid @RequestBody PersonaNaturalRequestDTO dto) {
        log.info("Iniciando creación de Persona Natural: identificación={}, nombre={}, email={}", 
                 dto.getIdentificacion(), dto.getNombre(), dto.getEmail());
        try {
            PersonaResponseDTO response = personaService.crearPersonaNatural(dto);
            log.info("Persona Natural creada exitosamente con id: {}", response.getId());
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            log.error("Error al crear Persona Natural: {}", e.getMessage(), e);
            throw e;
        }
    }
    
    // CREAR PERSONA JURIDICA
    @PostMapping("/juridica")
    public ResponseEntity<PersonaResponseDTO> crearPersonaJuridica(
            @Valid @RequestBody PersonaJuridicaRequestDTO dto) {
        log.info("Iniciando creación de Persona Jurídica: identificación={}, razón social={}", 
                 dto.getIdentificacion(), dto.getRazonSocial());
        try {
            PersonaResponseDTO response = personaService.crearPersonaJuridica(dto);
            log.info("Persona Jurídica creada exitosamente con id: {}", response.getId());
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            log.error("Error al crear Persona Jurídica: {}", e.getMessage(), e);
            throw e;
        }
    }
    
    // OBTENER TODAS LAS PERSONAS
    @GetMapping
    public ResponseEntity<List<PersonaResponseDTO>> obtenerTodas() {
        List<PersonaResponseDTO> personas = personaService.findAllPersona();
        return ResponseEntity.ok(personas);
    }
    
    // OBTENER SOLO PERSONAS NATURALES
    @GetMapping("/naturales")
    public ResponseEntity<List<PersonaResponseDTO>> obtenerPersonasNaturales() {
        List<PersonaResponseDTO> personas = personaService.listarPersonasNaturales();
        return ResponseEntity.ok(personas);
    }
    
    // ACTUALIZAR PERSONA NATURAL
    @PutMapping("/natural/{id}")
    public ResponseEntity<PersonaResponseDTO> actualizarPersonaNatural(
            @PathVariable UUID id,
            @RequestBody PersonaNaturalRequestDTO dto) {
        PersonaResponseDTO response = personaService.actualizarpersonanatural(id, dto);
        return ResponseEntity.ok(response);
    }
    
    // ACTUALIZAR PERSONA JURIDICA
    @PutMapping("/juridica/{id}")
    public ResponseEntity<PersonaResponseDTO> actualizarPersonaJuridica(
            @PathVariable UUID id,
            @RequestBody PersonaJuridicaRequestDTO dto) {
        PersonaResponseDTO response = personaService.actualizarpersonajuridica(id, dto);
        return ResponseEntity.ok(response);
    }
    
    // ELIMINAR PERSONA
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarPersona(@PathVariable UUID id) {
        log.info("Eliminando Persona con id: {}", id);
        try {
            personaService.eliminarPersona(id);
            log.info("Persona eliminada: {}", id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            log.error("Error al eliminar Persona: {}", e.getMessage(), e);
            throw e;
        }
    }
}

