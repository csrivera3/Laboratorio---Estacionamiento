package ec.edu.espe.zone_core.zone_core.services;

import ec.edu.espe.zone_core.zone_core.dto.SpaceResponseDTO;
import ec.edu.espe.zone_core.zone_core.dto.SpaceRequestDTO;

import java.util.List;
import java.util.UUID;

public interface SpaceService {
    SpaceResponseDTO createSpace(SpaceRequestDTO dto);
    SpaceResponseDTO updateSpace(UUID id, SpaceRequestDTO dto);
    List<SpaceResponseDTO> getSpaces();
    void deleteSpace(UUID id);
    SpaceResponseDTO getSpace(UUID id);
}