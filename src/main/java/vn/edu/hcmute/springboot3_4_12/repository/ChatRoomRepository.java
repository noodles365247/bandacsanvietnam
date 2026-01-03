package vn.edu.hcmute.springboot3_4_12.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.edu.hcmute.springboot3_4_12.entity.ChatRoom;

import java.util.List;
import java.util.Optional;

@Repository
public interface ChatRoomRepository extends JpaRepository<ChatRoom, Long> {
    Optional<ChatRoom> findByCustomerIdAndVendorId(Long customerId, Long vendorId);
    List<ChatRoom> findByVendorId(Long vendorId);
    List<ChatRoom> findByCustomerId(Long customerId);
}
