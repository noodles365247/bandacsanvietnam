function openChat(vendorId) {
    document.getElementById('chatBox').style.display = 'block';
    // Logic: Connect WebSocket tới room (customerId_vendorId)
}

function closeChat() {
    document.getElementById('chatBox').style.display = 'none';
}