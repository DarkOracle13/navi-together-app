document.addEventListener('DOMContentLoaded', function() {
    let deleteRoomName, leaveRoomName, deleteRoomId, leaveRoomId;
  
    // Open delete confirmation modal and set IDs
    const deleteButtons = document.getElementsByClassName('openModalDelete');
    Array.from(deleteButtons).forEach(function(button) {
      button.addEventListener('click', function() {
        console.log('delete button clicked');
        deleteRoomName = button.getAttribute('data-room-name');
        deleteRoomId = button.getAttribute('data-room-id');
        $('#deleteConfirmModal').modal('show');
      });
    });
  
    // Open leave confirmation modal and set IDs
    const leaveButtons = document.getElementsByClassName('openModalLeave');
    Array.from(leaveButtons).forEach(function(button) {
      button.addEventListener('click', function() {
        console.log('leave button clicked');
        leaveRoomName = button.getAttribute('data-room-name');
        leaveRoomId = button.getAttribute('data-room-id');
        $('#leaveConfirmModal').modal('show');
      });
    });
  
    // Handle delete confirmation
    document.getElementById('confirmDelete').addEventListener('click', function() {
      if (deleteRoomName && deleteRoomId) {
        fetch(`/room/view/${deleteRoomId}/delete`, {
          method: 'DELETE',
        }).then(response => {
          if (response.ok) {
            window.location.reload();
          } else {
            alert('Failed to delete the room.');
          }
        }).catch(error => {
          console.error('Error:', error);
          alert('An error occurred while deleting the room.');
        });
      }
      $('#deleteConfirmModal').modal('hide');
    });
  
    // Handle leave confirmation
    document.getElementById('confirmLeave').addEventListener('click', function() {
      if (leaveRoomName && leaveRoomId) {
        fetch(`/room/view/${leaveRoomId}/leave`, {
          method: 'DELETE',
        }).then(response => {
          if (response.ok) {
            window.location.reload();
          } else {
            alert('Failed to leave the room.');
          }
        }).catch(error => {
          console.error('Error:', error);
          alert('An error occurred while leaving the room.');
        });
      }
      $('#leaveConfirmModal').modal('hide');
    });
  });
  