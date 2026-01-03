package vn.edu.hcmute.springboot3_4_12.controller.common;

import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import vn.edu.hcmute.springboot3_4_12.entity.ChatMessage;
import vn.edu.hcmute.springboot3_4_12.entity.ChatRoom;
import vn.edu.hcmute.springboot3_4_12.entity.User;
import vn.edu.hcmute.springboot3_4_12.entity.Vendor;
import vn.edu.hcmute.springboot3_4_12.repository.UserRepository;
import vn.edu.hcmute.springboot3_4_12.repository.VendorRepository;
import vn.edu.hcmute.springboot3_4_12.service.IChatService;
import vn.edu.hcmute.springboot3_4_12.util.SecurityUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class ChatController {

    private final IChatService chatService;
    private final UserRepository userRepository;
    private final VendorRepository vendorRepository;
    private final SimpMessagingTemplate messagingTemplate;

    // --- View Controllers ---

    @GetMapping("/user/chat")
    public String customerChat(Model model, @RequestParam(value = "vendorId", required = false) Long vendorId) {
        String username = SecurityUtils.getCurrentUsername();
        User user = userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("User not found"));
        
        List<ChatRoom> rooms = chatService.getCustomerRooms(user.getId());
        model.addAttribute("rooms", rooms);
        
        if (vendorId != null) {
            ChatRoom currentRoom = chatService.getOrCreateRoom(user.getId(), vendorId);
            model.addAttribute("currentRoom", currentRoom);
            model.addAttribute("messages", chatService.getMessages(currentRoom.getId()));
        } else if (!rooms.isEmpty()) {
             // Default to first room
            ChatRoom currentRoom = rooms.get(0);
            model.addAttribute("currentRoom", currentRoom);
            model.addAttribute("messages", chatService.getMessages(currentRoom.getId()));
        }
        
        return "customer/chat-customer";
    }

    @GetMapping("/vendor/chat")
    @PreAuthorize("hasRole('VENDOR')")
    public String vendorChat(Model model, @RequestParam(value = "roomId", required = false) Long roomId) {
        String username = SecurityUtils.getCurrentUsername();
        User user = userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("User not found"));
        Vendor vendor = vendorRepository.findByUser(user).orElseThrow(() -> new RuntimeException("Vendor not found"));
        
        List<ChatRoom> rooms = chatService.getVendorRooms(vendor.getId());
        model.addAttribute("rooms", rooms);
        
        if (roomId != null) {
            ChatRoom currentRoom = rooms.stream().filter(r -> r.getId().equals(roomId)).findFirst().orElse(null);
            if (currentRoom != null) {
                model.addAttribute("currentRoom", currentRoom);
                model.addAttribute("messages", chatService.getMessages(roomId));
            }
        } else if (!rooms.isEmpty()) {
            ChatRoom currentRoom = rooms.get(0);
            model.addAttribute("currentRoom", currentRoom);
            model.addAttribute("messages", chatService.getMessages(currentRoom.getId()));
        }
        
        return "vendor/chat-vendor";
    }

    // --- WebSocket & API ---

    @MessageMapping("/chat/{roomId}")
    public void sendMessage(@DestinationVariable Long roomId, @Payload ChatMessageDTO messageDTO) {
        ChatMessage savedMsg = chatService.saveMessage(roomId, messageDTO.getSender(), messageDTO.getContent());
        
        // Broadcast to subscribers of /topic/chat/{roomId}
        messagingTemplate.convertAndSend("/topic/chat/" + roomId, savedMsg);
    }
    
    // Simple DTO for payload
    public static class ChatMessageDTO {
        private String sender;
        private String content;
        // getters setters
        public String getSender() { return sender; }
        public void setSender(String sender) { this.sender = sender; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
    }
}
