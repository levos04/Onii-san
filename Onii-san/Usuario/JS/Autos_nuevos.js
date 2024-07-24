document.addEventListener('DOMContentLoaded', function () {
    // Obtener
    const marcaFilter = document.getElementById('marca-filter');
    const precioFilter = document.getElementById('precio-filter');
    const anoFilter = document.getElementById('ano-filter');
    const cards = document.querySelectorAll('.card');

    function applyFilters() {
        const selectedMarca = marcaFilter.value;
        const selectedPrecio = precioFilter.value;
        const selectedAno = anoFilter.value;

        cards.forEach(card => {
            const marca = card.getAttribute('data-marca');
            const precio = parseFloat(card.getAttribute('data-precio'));
            const ano = parseInt(card.getAttribute('data-ano'));

            let showCard = true;

            // Filtrar por el marca
            if (selectedMarca && marca !== selectedMarca) {
                showCard = false;
            }

            // Filtrar por el precio
            if (selectedPrecio === 'asc') {
                showCard = showCard && cards[0].getAttribute('data-precio') <= precio;
            } else if (selectedPrecio === 'desc') {
                showCard = showCard && cards[0].getAttribute('data-precio') >= precio;
            }

            // Filtrar por el año
            if (selectedAno && ano !== parseInt(selectedAno)) {
                showCard = false;
            }

            card.style.display = showCard ? 'block' : 'none';
        });
    }

    // Añadir a los filtros
    marcaFilter.addEventListener('change', applyFilters);
    precioFilter.addEventListener('change', applyFilters);
    anoFilter.addEventListener('change', applyFilters);
});
