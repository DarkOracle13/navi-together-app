// confirmation.js

document.addEventListener('DOMContentLoaded', function() {
  // Open modal for new plan
  document.getElementById('openModal').addEventListener('click', function() {
    $('#myModal').modal('show');
  });

  // Variables to store delete URL and IDs
  let deletePlanId, deleteRoomId;

  // Open delete confirmation modal and set IDs
  document.querySelectorAll('.openModalDelete').forEach(function(button) {
    button.addEventListener('click', function() {
      deletePlanId = button.getAttribute('data-plan-id');
      deleteRoomId = button.getAttribute('data-room-id');
      $('#deleteConfirmModal').modal('show');
    });
  });

  // Handle delete confirmation
  document.getElementById('confirmDelete').addEventListener('click', function() {
    if (deletePlanId && deleteRoomId) {
      fetch(`/plan/${deleteRoomId}/${deletePlanId}`, {
        method: 'POST',
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
