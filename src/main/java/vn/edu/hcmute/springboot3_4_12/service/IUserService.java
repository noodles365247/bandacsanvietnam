package vn.edu.hcmute.springboot3_4_12.service;

import vn.edu.hcmute.springboot3_4_12.dto.LoginRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.UserRequestDTO;
import vn.edu.hcmute.springboot3_4_12.dto.UserResponseDTO;

import java.util.List;
import java.util.Set;

public interface IUserService {
    UserResponseDTO register(UserRequestDTO dto);
    UserResponseDTO findById(Long id);
    UserResponseDTO findByUsername(String username);
    List<UserResponseDTO> getAllUsers();
    UserResponseDTO update(Long id, UserRequestDTO dto);
    void deleteUser(Long id);
    long count();
}