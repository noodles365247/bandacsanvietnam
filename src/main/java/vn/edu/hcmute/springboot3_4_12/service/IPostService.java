package vn.edu.hcmute.springboot3_4_12.service;

import vn.edu.hcmute.springboot3_4_12.entity.Post;
import java.util.Optional;

public interface IPostService {
    void save(Post post);
    Optional<Post> findById(Long id);
    java.util.List<Post> findAll();
    void delete(Long id);
}
