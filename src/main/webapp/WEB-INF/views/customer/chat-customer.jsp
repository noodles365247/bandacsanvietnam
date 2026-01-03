<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container py-4">
    <div class="row">
        <!-- List of Vendors -->
        <div class="col-md-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Danh sách Shop đã chat</h6>
                </div>
                <div class="list-group list-group-flush">
                    <c:forEach var="room" items="${rooms}">
                        <a href="${pageContext.request.contextPath}/user/chat?vendorId=${room.vendor.id}" 
                           class="list-group-item list-group-item-action ${currentRoom.id == room.id ? 'active' : ''}">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1">${room.vendor.shopName}</h6>
                            </div>
                            <small>${room.vendor.user.email}</small>
                        </a>
                    </c:forEach>
                    <c:if test="${empty rooms}">
                        <div class="p-3 text-center text-muted">
                            Chưa có cuộc hội thoại nào.
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Chat Box -->
        <div class="col-md-8">
            <c:if test="${not empty currentRoom}">
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">Chat với ${currentRoom.vendor.shopName}</h6>
                    </div>
                    <div class="card-body" style="height: 400px; overflow-y: auto;" id="chatArea">
                        <c:forEach var="msg" items="${messages}">
                            <div class="mb-2 d-flex ${msg.sender.username == pageContext.request.userPrincipal.name ? 'justify-content-end' : 'justify-content-start'}">
                                <div class="p-2 rounded ${msg.sender.username == pageContext.request.userPrincipal.name ? 'bg-primary text-white' : 'bg-light text-dark'}" style="max-width: 70%;">
                                    <div>${msg.message}</div>
                                    <small class="${msg.sender.username == pageContext.request.userPrincipal.name ? 'text-white-50' : 'text-muted'}" style="font-size: 0.7rem;">
                                        <fmt:parseDate value="${msg.timestamp}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                        <fmt:formatDate value="${parsedDate}" pattern="HH:mm dd/MM" />
                                    </small>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="card-footer">
                        <div class="input-group">
                            <input type="text" id="messageInput" class="form-control" placeholder="Nhập tin nhắn...">
                            <button class="btn btn-primary" type="button" onclick="sendMessage()">Gửi</button>
                        </div>
                    </div>
                </div>
            </c:if>
            <c:if test="${empty currentRoom}">
                <div class="alert alert-info">
                    Chọn một shop để bắt đầu chat hoặc nhắn tin từ trang chi tiết sản phẩm.
                </div>
            </c:if>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script>
    var stompClient = null;
    var roomId = '${currentRoom.id}';
    var currentUser = '${pageContext.request.userPrincipal.name}';

    function connect() {
        if (!roomId) return;
        
        var socket = new SockJS('${pageContext.request.contextPath}/ws');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function (frame) {
            console.log('Connected: ' + frame);
            stompClient.subscribe('/topic/chat/' + roomId, function (messageOutput) {
                showMessage(JSON.parse(messageOutput.body));
            });
            scrollToBottom();
        });
    }

    function sendMessage() {
        var messageContent = document.getElementById('messageInput').value;
        if(messageContent && stompClient) {
            var chatMessage = {
                sender: currentUser,
                content: messageContent,
                type: 'CHAT'
            };
            stompClient.send("/app/chat/" + roomId, {}, JSON.stringify(chatMessage));
            document.getElementById('messageInput').value = '';
        }
    }

    function showMessage(message) {
        var chatArea = document.getElementById('chatArea');
        var isMe = message.sender === currentUser;
        
        var msgDiv = document.createElement('div');
        msgDiv.className = 'mb-2 d-flex ' + (isMe ? 'justify-content-end' : 'justify-content-start');
        
        var innerDiv = document.createElement('div');
        innerDiv.className = 'p-2 rounded ' + (isMe ? 'bg-primary text-white' : 'bg-light text-dark');
        innerDiv.style.maxWidth = '70%';
        
        var contentDiv = document.createElement('div');
        contentDiv.textContent = message.message;
        
        var timeSmall = document.createElement('small');
        timeSmall.className = isMe ? 'text-white-50' : 'text-muted';
        timeSmall.style.fontSize = '0.7rem';
        var now = new Date();
        timeSmall.textContent = now.getHours() + ':' + (now.getMinutes()<10?'0':'') + now.getMinutes();
        
        innerDiv.appendChild(contentDiv);
        innerDiv.appendChild(timeSmall);
        msgDiv.appendChild(innerDiv);
        
        chatArea.appendChild(msgDiv);
        scrollToBottom();
    }
    
    function scrollToBottom() {
        var chatArea = document.getElementById('chatArea');
        if(chatArea) chatArea.scrollTop = chatArea.scrollHeight;
    }

    document.addEventListener("DOMContentLoaded", function() {
        connect();
        var input = document.getElementById("messageInput");
        if(input) {
            input.addEventListener("keypress", function(event) {
                if (event.key === "Enter") {
                    event.preventDefault();
                    sendMessage();
                }
            });
        }
    });
</script>
