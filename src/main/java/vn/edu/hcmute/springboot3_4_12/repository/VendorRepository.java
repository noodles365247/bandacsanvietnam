package vn.edu.hcmute.springboot3_4_12.repository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import vn.edu.hcmute.springboot3_4_12.entity.Vendor;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Set;
import java.util.Optional;

@Repository
public interface VendorRepository extends JpaRepository<Vendor, Long> {

    Optional<Vendor> findVendorByUser_Id(Long userId);
    Optional<Vendor> findByUser(vn.edu.hcmute.springboot3_4_12.entity.User user);
    @Query("SELECT v FROM Vendor v JOIN FETCH v.user")
    List<Vendor> findAllWithUser();
}
