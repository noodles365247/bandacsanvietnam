package vn.edu.hcmute.springboot3_4_12.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import vn.edu.hcmute.springboot3_4_12.entity.Video;
import vn.edu.hcmute.springboot3_4_12.repository.VideoRepository;
import vn.edu.hcmute.springboot3_4_12.service.IVideoService;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class VideoService implements IVideoService {
    private final VideoRepository videoRepository;

    @Override
    public List<Video> findAll() {
        return videoRepository.findAll();
    }

    @Override
    public Optional<Video> findById(Long id) {
        return videoRepository.findById(id);
    }

    @Override
    public Video save(Video video) {
        return videoRepository.save(video);
    }

    @Override
    public void delete(Long id) {
        videoRepository.deleteById(id);
    }
}
