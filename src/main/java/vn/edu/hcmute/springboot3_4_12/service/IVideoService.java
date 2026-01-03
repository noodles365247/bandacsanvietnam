package vn.edu.hcmute.springboot3_4_12.service;

import vn.edu.hcmute.springboot3_4_12.entity.Video;
import java.util.List;
import java.util.Optional;

public interface IVideoService {
    List<Video> findAll();
    Optional<Video> findById(Long id);
    Video save(Video video);
    void delete(Long id);
}
