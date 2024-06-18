// // confirmation.js

document.addEventListener('DOMContentLoaded', function() {
  // Open modal for new plan
  document.getElementById('openModal').addEventListener('click', function() {
    $('#myModal').modal('show');
  });

  // Variables to store delete URL and IDs
  let deletePlanName, deleteRoomId;

  // Open delete confirmation modal and set IDs
  const deleteButtons = document.getElementsByClassName('openModalDelete');
  Array.from(deleteButtons).forEach(function(button) {
    button.addEventListener('click', function() {
      console.log('delete button clicked');
      deletePlanName = button.getAttribute('data-plan-name');
      deleteRoomId = button.getAttribute('data-room-id');
      $('#deleteConfirmModal').modal('show');
    });
  });

  // Handle delete confirmation
  document.getElementById('confirmDelete').addEventListener('click', function() {
    if (deletePlanName && deleteRoomId) {
      fetch(`/plan/${deleteRoomId}/${deletePlanName}`, {
        method: 'DELETE',
      }).then(response => {
        if (response.ok) {
          window.location.reload();
        } else {
          alert('Failed to delete the plan.');
        }
      }).catch(error => {
        console.error('Error:', error);
        alert('An error occurred while deleting the plan.');
      });
    }
    $('#deleteConfirmModal').modal('hide');
  });
});