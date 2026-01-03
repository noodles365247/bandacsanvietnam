package vn.edu.hcmute.springboot3_4_12.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import vn.edu.hcmute.springboot3_4_12.entity.Post;
import vn.edu.hcmute.springboot3_4_12.repository.PostRepository;
import vn.edu.hcmute.springboot3_4_12.service.IPostService;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class PostService implements IPostService {
    private final PostRepository postRepository;

    @Override
    public void save(Post post) {
        postRepository.save(post);
    }

    @Override
    public Optional<Post> findById(Long id) {
        return postRepository.findById(id);
    }

    @Override
    public java.util.List<Post> findAll() {
        return postRepository.findAll();
    }

    @Override
    public void delete(Long id) {
        postRepository.deleteById(id);
    }
}
