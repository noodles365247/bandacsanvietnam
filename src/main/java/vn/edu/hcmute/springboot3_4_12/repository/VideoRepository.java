package vn.edu.hcmute.springboot3_4_12.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.edu.hcmute.springboot3_4_12.entity.Video;

@Repository
public interface VideoRepository extends JpaRepository<Video, Long> {
}
