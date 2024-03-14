// Get the form element
const form = document.querySelector('form');

// Add an event listener for form submission
form.addEventListener('submit', function(event) {
  event.preventDefault(); // Prevent the default form submission

  // Get the input field values
  const emailInput = document.querySelector('input[type="email"]').value;
  const addressInput = document.querySelector('input[type="text"]').value;
  const notesInput = document.querySelector('textarea').value;

  // Regular expression pattern for email validation
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  // Validate the email field
  if (!emailPattern.test(emailInput)) {
    alert('Please enter a valid email address.');
    return;
  }

  // Validate the address field
  if (addressInput.trim() === '') {
    alert('Please enter an address.');
    return;
  }

  // If all validations pass, send the form data to the server
  const formData = {
    email: emailInput,
    address: addressInput,
    notes: notesInput
  };

  fetch('/submit', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(formData)
  })
    .then(response => response.text())
    .then(data => {
      console.log(data); // Handle the server response
      // Reset the form
      form.reset();
    })
    .catch(error => {
      console.error('Error:', error);
    });
});
