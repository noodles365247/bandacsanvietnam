package vn.edu.hcmute.springboot3_4_12.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.factory.Mappers;
import vn.edu.hcmute.springboot3_4_12.dto.VendorRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.VendorResponseDTO;
import vn.edu.hcmute.springboot3_4_12.entity.Vendor;

@Mapper(componentModel = "spring")
public interface VendorMapper {

    VendorMapper INSTANCE = Mappers.getMapper(VendorMapper.class);

    // Ánh xạ từ RequestDTO sang Entity
    @Mapping(target = "user.id", source = "userId")
    Vendor toEntity(VendorRequestDTO dto);

    // Ánh xạ từ Entity sang ResponseDTO
    @Mapping(target = "username", source = "user.username")
    @Mapping(target = "userEmail", source = "user.email")
    @Mapping(target = "userFullname", source = "user.fullname")
    VendorResponseDTO toResponseDTO(Vendor vendor);

    // Cập nhật Entity hiện có từ DTO (không ghi đè ID)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", ignore = true) // Thường không cho phép đổi chủ sở hữu qua update
    void updateEntityFromDto(VendorRequestDTO dto, @MappingTarget Vendor entity);
}
