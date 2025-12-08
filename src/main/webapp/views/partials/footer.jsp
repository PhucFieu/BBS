<footer class="py-4 mt-auto">
    <div class="container text-center">
        <p>&copy; 2025 Bus Booking System. All rights reserved.</p>
    </div>
</footer>

<!-- jQuery (must be loaded before Bootstrap and other scripts) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
    integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
    crossorigin="anonymous"></script>

<!-- Ensure jQuery and Bootstrap are loaded -->
<script>
    // Check if jQuery and Bootstrap are loaded
    window.addEventListener('load', function () {
        if (typeof $ === 'undefined') {
            console.error('jQuery failed to load!');
            // Try to reload jQuery
            const jqueryScript = document.createElement('script');
            jqueryScript.src = 'https://code.jquery.com/jquery-3.7.1.min.js';
            jqueryScript.integrity = 'sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=';
            jqueryScript.crossOrigin = 'anonymous';
            document.head.appendChild(jqueryScript);
        }

        if (typeof bootstrap === 'undefined') {
            console.error('Bootstrap failed to load!');
            // Try to reload Bootstrap
            const bootstrapScript = document.createElement('script');
            bootstrapScript.src = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js';
            bootstrapScript.integrity = 'sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL';
            bootstrapScript.crossOrigin = 'anonymous';
            document.body.appendChild(bootstrapScript);
        } else {
            console.log('Bootstrap loaded successfully');
        }
    });
</script>