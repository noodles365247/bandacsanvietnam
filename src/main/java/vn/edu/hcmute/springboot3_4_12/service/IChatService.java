package vn.edu.hcmute.springboot3_4_12.service;

import vn.edu.hcmute.springboot3_4_12.entity.ChatMessage;
import vn.edu.hcmute.springboot3_4_12.entity.ChatRoom;

import java.util.List;

public interface IChatService {
    ChatRoom getOrCreateRoom(Long customerId, Long vendorId);
    List<ChatMessage> getMessages(Long roomId);
    ChatMessage saveMessage(Long roomId, String senderUsername, String content);
    List<ChatRoom> getVendorRooms(Long vendorId);
    List<ChatRoom> getCustomerRooms(Long customerId);
}
