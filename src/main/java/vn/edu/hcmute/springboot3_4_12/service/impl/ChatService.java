package vn.edu.hcmute.springboot3_4_12.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.edu.hcmute.springboot3_4_12.entity.ChatMessage;
import vn.edu.hcmute.springboot3_4_12.entity.ChatRoom;
import vn.edu.hcmute.springboot3_4_12.entity.User;
import vn.edu.hcmute.springboot3_4_12.entity.Vendor;
import vn.edu.hcmute.springboot3_4_12.repository.ChatMessageRepository;
import vn.edu.hcmute.springboot3_4_12.repository.ChatRoomRepository;
import vn.edu.hcmute.springboot3_4_12.repository.UserRepository;
import vn.edu.hcmute.springboot3_4_12.repository.VendorRepository;
import vn.edu.hcmute.springboot3_4_12.service.IChatService;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatService implements IChatService {

    private final ChatRoomRepository chatRoomRepository;
    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository;
    private final VendorRepository vendorRepository;

    @Override
    @Transactional
    public ChatRoom getOrCreateRoom(Long customerId, Long vendorId) {
        return chatRoomRepository.findByCustomerIdAndVendorId(customerId, vendorId)
                .orElseGet(() -> {
                    User customer = userRepository.findById(customerId).orElseThrow(() -> new RuntimeException("Customer not found"));
                    Vendor vendor = vendorRepository.findById(vendorId).orElseThrow(() -> new RuntimeException("Vendor not found"));
                    ChatRoom room = new ChatRoom();
                    room.setCustomer(customer);
                    room.setVendor(vendor);
                    return chatRoomRepository.save(room);
                });
    }

    @Override
    public List<ChatMessage> getMessages(Long roomId) {
        return chatMessageRepository.findByRoomIdOrderByTimestampAsc(roomId);
    }

    @Override
    @Transactional
    public ChatMessage saveMessage(Long roomId, String senderUsername, String content) {
        ChatRoom room = chatRoomRepository.findById(roomId).orElseThrow(() -> new RuntimeException("Room not found"));
        User sender = userRepository.findByUsername(senderUsername).orElseThrow(() -> new RuntimeException("User not found"));
        
        ChatMessage message = new ChatMessage();
        message.setRoom(room);
        message.setSender(sender);
        message.setMessage(content);
        message.setTimestamp(LocalDateTime.now());
        
        return chatMessageRepository.save(message);
    }

    @Override
    public List<ChatRoom> getVendorRooms(Long vendorId) {
        return chatRoomRepository.findByVendorId(vendorId);
    }

    @Override
    public List<ChatRoom> getCustomerRooms(Long customerId) {
        return chatRoomRepository.findByCustomerId(customerId);
    }
}
