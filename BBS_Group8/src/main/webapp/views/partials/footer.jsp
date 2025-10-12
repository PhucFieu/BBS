<footer class="bg-dark text-light py-4 mt-5">
    <div class="container text-center">
        <p>&copy; 2025 Bus Ticket Management System.</p>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
    crossorigin="anonymous"></script>

<!-- Ensure Bootstrap is loaded -->
<script>
    // Check if Bootstrap is loaded
    window.addEventListener('load', function () {
        if (typeof bootstrap === 'undefined') {
            console.error('Bootstrap failed to load!');
            // Try to reload Bootstrap
            const script = document.createElement('script');
            script.src = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js';
            script.integrity = 'sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL';
            script.crossOrigin = 'anonymous';
            document.body.appendChild(script);
        } else {
        }
    });
</script>