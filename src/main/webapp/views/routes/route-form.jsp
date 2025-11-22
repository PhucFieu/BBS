<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>${route == null ? 'Add Route' : 'Edit Route'} - Bus Booking System</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <style>
                    /* Route Form Styles */
                    .form-card {
                        background: #fff;
                        border-radius: 18px;
                        box-shadow: 0 8px 32px rgba(102, 187, 106, 0.15);
                        padding: 2.5rem 2rem 2rem 2rem;
                        margin-top: 2rem;
                        margin-bottom: 2rem;
                    }

                    .form-header {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        color: #fff;
                        border-radius: 18px 18px 0 0;
                        padding: 1.5rem 2rem;
                        margin: -2.5rem -2rem 2rem -2rem;
                        box-shadow: 0 4px 16px rgba(102, 187, 106, 0.2);
                    }

                    .form-label {
                        font-weight: 600;
                    }

                    .section-title {
                        font-weight: 600;
                        color: #66bb6a;
                        margin-top: 1.5rem;
                        margin-bottom: 1rem;
                        padding-bottom: 0.5rem;
                        border-bottom: 2px solid #e0e0e0;
                    }

                    .form-control:focus {
                        border-color: #66bb6a;
                        box-shadow: 0 0 0 0.2rem rgba(102, 187, 106, 0.25);
                    }

                    .btn-gradient {
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        color: #fff;
                        border: none;
                        border-radius: 25px;
                        padding: 0.75rem 2rem;
                        font-weight: 600;
                        transition: all 0.2s;
                    }

                    .btn-gradient:hover {
                        background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
                        color: #fff;
                        transform: translateY(-2px);
                        box-shadow: 0 4px 16px rgba(102, 187, 106, 0.25);
                    }

                    @media (max-width: 576px) {

                        .form-card,
                        .form-header {
                            padding: 1rem !important;
                        }
                    }

                    /* Station Selection Styles */
                    .station-item {
                        cursor: move;
                        transition: all 0.2s ease;
                        border-left: 3px solid #66bb6a;
                        margin-bottom: 0.5rem;
                    }

                    .station-item:hover {
                        background-color: #f8f9fa;
                        transform: translateX(5px);
                        box-shadow: 0 2px 8px rgba(102, 187, 106, 0.15);
                    }

                    .station-item.dragging {
                        opacity: 0.5;
                        border-left-color: #4caf50;
                    }

                    .station-item.drag-over {
                        border-top: 3px solid #4caf50;
                        background-color: #e8f5e9;
                    }

                    .station-number {
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        width: 28px;
                        height: 28px;
                        background: linear-gradient(135deg, #66bb6a 0%, #81c784 100%);
                        color: white;
                        border-radius: 50%;
                        font-weight: 600;
                        font-size: 0.875rem;
                        margin-right: 0.75rem;
                        flex-shrink: 0;
                    }

                    .station-info {
                        flex: 1;
                        display: flex;
                        flex-direction: column;
                    }

                    .station-name {
                        font-weight: 600;
                        color: #333;
                        margin-bottom: 0.25rem;
                    }

                    .station-city {
                        font-size: 0.875rem;
                        color: #666;
                    }

                    .station-actions {
                        display: flex;
                        gap: 0.5rem;
                        align-items: center;
                    }

                    .drag-handle {
                        color: #999;
                        cursor: grab;
                        padding: 0.25rem;
                    }

                    .drag-handle:active {
                        cursor: grabbing;
                    }

                    .drag-handle:hover {
                        color: #66bb6a;
                    }

                    #selectedStations {
                        padding: 0.5rem;
                    }

                    #selectedStations.empty {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #999;
                        font-style: italic;
                    }
                </style>
            </head>

            <body class="bg-light">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-7 col-md-9">
                            <div class="form-card">
                                <div class="form-header d-flex align-items-center gap-2">
                                    <i class="fas fa-route fa-2x me-2"></i>
                                    <div>
                                        <h4 class="mb-0">${route == null ? 'Add Route' : 'Edit Route'}</h4>
                                        <small>Manage bus route information</small>
                                    </div>
                                </div>
                                <!-- Notification Messages -->
                                <c:if test="${not empty param.message}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        <i class="fas fa-check-circle me-2"></i>
                                        <strong>Success!</strong> ${param.message}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>
                                <c:if test="${not empty param.error}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <i class="fas fa-exclamation-circle me-2"></i>
                                        <strong>Error!</strong> ${param.error}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>
                                <c:if test="${not empty param.warning}">
                                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        <strong>Warning!</strong> ${param.warning}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>
                                <c:if test="${not empty param.info}">
                                    <div class="alert alert-info alert-dismissible fade show" role="alert">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <strong>Info:</strong> ${param.info}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <form
                                    action="${pageContext.request.contextPath}/routes/${route == null ? 'add' : 'edit'}"
                                    method="post" autocomplete="off">
                                    <c:if test="${route != null}">
                                        <input type="hidden" name="routeId" value="${route.routeId}">
                                    </c:if>
                                    <c:set var="originStationId" value="" />
                                    <c:set var="destinationStationId" value="" />
                                    <c:if test="${not empty routeStations}">
                                        <c:set var="originStationId" value="${routeStations[0].stationId}" />
                                        <c:set var="destinationStationId"
                                            value="${routeStations[fn:length(routeStations) - 1].stationId}" />
                                    </c:if>
                                    <div class="section-title"><i class="fas fa-info-circle me-1"></i>Basic Information
                                    </div>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="routeName" class="form-label">Route Name *</label>
                                            <input type="text" class="form-control" id="routeName" name="routeName"
                                                value="${route.routeName}" required maxlength="100"
                                                placeholder="E.g: Hanoi - Hai Phong">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="basePrice" class="form-label">Base Price (VND) *</label>
                                            <input type="number" class="form-control" id="basePrice" name="basePrice"
                                                value="${route.basePrice}" min="0" step="1000" required
                                                placeholder="e.g., 150000">
                                        </div>
                                    </div>
                                    <div class="section-title mt-4"><i class="fas fa-landmark me-1"></i>Terminal
                                        Stations
                                    </div>
                                    <p class="text-muted small mb-3">Choose the exact departure and destination
                                        terminals.
                                        Their city names automatically populate the route metadata.</p>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="departureStationId" class="form-label">Departure Terminal
                                                *</label>
                                            <select class="form-select" id="departureStationId"
                                                name="departureStationId" required>
                                                <option value="">Select departure terminal</option>
                                                <c:forEach var="station" items="${stations}">
                                                    <option value="${station.stationId}" data-station-option="true"
                                                        data-name="${fn:escapeXml(station.stationName)}"
                                                        data-city="${fn:escapeXml(station.city)}"
                                                        data-address="${fn:escapeXml(station.address)}"
                                                        ${originStationId==station.stationId ? 'selected' : '' }>
                                                        ${station.stationName} - ${station.city}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="destinationStationId" class="form-label">Destination Terminal
                                                *</label>
                                            <select class="form-select" id="destinationStationId"
                                                name="destinationStationId" required>
                                                <option value="">Select destination terminal</option>
                                                <c:forEach var="station" items="${stations}">
                                                    <option value="${station.stationId}" data-station-option="true"
                                                        data-name="${fn:escapeXml(station.stationName)}"
                                                        data-city="${fn:escapeXml(station.city)}"
                                                        data-address="${fn:escapeXml(station.address)}"
                                                        ${destinationStationId==station.stationId ? 'selected' : '' }>
                                                        ${station.stationName} - ${station.city}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row g-3 mt-2">
                                        <div class="col-md-6">
                                            <label for="distance" class="form-label">Distance (km) *</label>
                                            <input type="number" class="form-control" id="distance" name="distance"
                                                value="${route.distance}" step="0.1" min="1" required
                                                placeholder="e.g., 105.5">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="durationHours" class="form-label">Duration (hours) *</label>
                                            <input type="number" class="form-control" id="durationHours"
                                                name="durationHours" value="${route.durationHours}" min="1" step="0.5"
                                                required placeholder="e.g., 2">
                                        </div>
                                    </div>
                                    <div class="section-title mt-4"><i class="fas fa-map-marker-alt me-1"></i>Route
                                        Stations
                                    </div>
                                    <p class="text-muted small mb-3">Terminals are locked in place based on the
                                        selections
                                        above. Use the multi-select to insert optional intermediate stops and reorder
                                        them as
                                        needed.</p>
                                    <div class="mb-3">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <label class="form-label small">Available intermediate stations</label>
                                                <select multiple class="form-select" id="availableStations" size="10"
                                                    style="min-height: 220px;">
                                                    <c:forEach var="station" items="${stations}">
                                                        <c:set var="isUsed" value="false" />
                                                        <c:forEach var="routeStation" items="${routeStations}">
                                                            <c:if test="${routeStation.stationId == station.stationId}">
                                                                <c:set var="isUsed" value="true" />
                                                            </c:if>
                                                        </c:forEach>
                                                        <option value="${station.stationId}" data-station-option="true"
                                                            data-name="${fn:escapeXml(station.stationName)}"
                                                            data-city="${fn:escapeXml(station.city)}"
                                                            data-address="${fn:escapeXml(station.address)}" ${isUsed
                                                            ? 'data-initial-used="true"' : '' } ${isUsed
                                                            ? 'disabled="disabled"' : '' }>
                                                            ${station.stationName} - ${station.city}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <div class="mt-2 d-flex gap-2 flex-wrap">
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                        id="addIntermediate">
                                                        <i class="fas fa-plus me-1"></i>Add selected stops
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-secondary"
                                                        id="clearIntermediate">
                                                        <i class="fas fa-trash me-1"></i>Clear intermediates
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label small">
                                                    <i class="fas fa-layer-group me-1"></i>Intermediate stops (ordered)
                                                </label>
                                                <div id="intermediateList" class="list-group"
                                                    style="min-height: 220px; max-height: 320px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.375rem; padding: 0.5rem;">
                                                    <c:if test="${not empty routeStations}">
                                                        <c:forEach var="routeStation" items="${routeStations}"
                                                            varStatus="status">
                                                            <c:if
                                                                test="${status.index > 0 && status.index < fn:length(routeStations) - 1}">
                                                                <div class="station-item list-group-item"
                                                                    data-station-id="${routeStation.stationId}">
                                                                    <div class="d-flex align-items-center">
                                                                        <span
                                                                            class="station-number">${status.index}</span>
                                                                        <div class="station-info flex-grow-1">
                                                                            <div class="station-name">
                                                                                ${routeStation.stationName}</div>
                                                                            <div class="station-city">
                                                                                <i
                                                                                    class="fas fa-map-marker-alt me-1"></i>${routeStation.city}
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="section-title mt-4"><i class="fas fa-route me-1"></i>Station sequence
                                        preview
                                    </div>
                                    <div class="mb-3">
                                        <div id="selectedStations" class="list-group"
                                            style="min-height: 200px; max-height: 400px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.375rem; padding: 0.5rem;">
                                            <c:choose>
                                                <c:when test="${not empty routeStations}">
                                                    <c:forEach var="routeStation" items="${routeStations}"
                                                        varStatus="status">
                                                        <div class="station-item list-group-item"
                                                            data-station-id="${routeStation.stationId}">
                                                            <div class="d-flex align-items-center">
                                                                <span class="station-number">${status.index + 1}</span>
                                                                <div class="station-info flex-grow-1">
                                                                    <div class="station-name">
                                                                        ${routeStation.stationName}
                                                                    </div>
                                                                    <div class="station-city">
                                                                        <i
                                                                            class="fas fa-map-marker-alt me-1"></i>${routeStation.city}
                                                                    </div>
                                                                </div>
                                                                <div class="station-actions">
                                                                    <span
                                                                        class="badge bg-light text-dark border">${status.index
                                                                        == 0 ? 'Departure' : (status.index ==
                                                                        fn:length(routeStations) - 1 ? 'Destination' :
                                                                        'Intermediate')}</span>
                                                                </div>
                                                                <input type="hidden" name="stationIds"
                                                                    value="${routeStation.stationId}">
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="text-center text-muted py-3">Select terminals to build
                                                        the
                                                        station chain.</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mt-4">
                                        <a href="${pageContext.request.contextPath}/routes"
                                            class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Back
                                        </a>
                                        <button type="submit" class="btn btn-gradient">
                                            <i class="fas fa-save me-2"></i>${route == null ? 'Add Route' : 'Update'}
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <%@ include file="/views/partials/footer.jsp" %>
                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            const alerts = document.querySelectorAll('.alert');
                            alerts.forEach(function (alert) {
                                setTimeout(function () {
                                    const bsAlert = new bootstrap.Alert(alert);
                                    bsAlert.close();
                                }, 5000);
                            });
                            if (alerts.length > 0) {
                                window.scrollTo({ top: 0, behavior: 'smooth' });
                            }

                            const departureSelect = document.getElementById('departureStationId');
                            const destinationSelect = document.getElementById('destinationStationId');
                            const availableStations = document.getElementById('availableStations');
                            const intermediateList = document.getElementById('intermediateList');
                            const selectedStations = document.getElementById('selectedStations');
                            const addIntermediateBtn = document.getElementById('addIntermediate');
                            const clearIntermediateBtn = document.getElementById('clearIntermediate');

                            const stationLookup = {};
                            document.querySelectorAll('option[data-station-option="true"]').forEach(option => {
                                if (!option.value) {
                                    return;
                                }
                                stationLookup[option.value] = {
                                    id: option.value,
                                    name: option.dataset.name || option.textContent.trim(),
                                    city: option.dataset.city || '',
                                    address: option.dataset.address || ''
                                };
                            });

                            let intermediateOrder = Array.from(intermediateList.querySelectorAll('[data-station-id]'))
                                .map(item => item.dataset.stationId);

                            function getStationMeta(stationId) {
                                return stationLookup[stationId] || {
                                    id: stationId,
                                    name: 'Unknown station',
                                    city: '',
                                    address: ''
                                };
                            }

                            function buildOrderedSequence() {
                                if (!departureSelect.value || !destinationSelect.value) {
                                    return [];
                                }
                                if (departureSelect.value === destinationSelect.value) {
                                    return [];
                                }
                                return [departureSelect.value, ...intermediateOrder, destinationSelect.value];
                            }

                            function renderStationPreview() {
                                const sequence = buildOrderedSequence();
                                selectedStations.innerHTML = '';
                                if (!sequence.length) {
                                    selectedStations.classList.add('empty');
                                    const placeholder = document.createElement('div');
                                    placeholder.className = 'text-center text-muted py-3';
                                    placeholder.textContent = 'Select departure and destination terminals to build the route.';
                                    selectedStations.appendChild(placeholder);
                                    return;
                                }
                                selectedStations.classList.remove('empty');
                                sequence.forEach((stationId, index) => {
                                    const meta = getStationMeta(stationId);
                                    const stationDiv = document.createElement('div');
                                    stationDiv.className = 'station-item list-group-item';
                                    stationDiv.dataset.stationId = stationId;

                                    const row = document.createElement('div');
                                    row.className = 'd-flex align-items-center';

                                    const stationNumber = document.createElement('span');
                                    stationNumber.className = 'station-number';
                                    stationNumber.textContent = index + 1;

                                    const stationInfo = document.createElement('div');
                                    stationInfo.className = 'station-info flex-grow-1';
                                    const stationName = document.createElement('div');
                                    stationName.className = 'station-name';
                                    stationName.textContent = meta.name;
                                    const stationCity = document.createElement('div');
                                    stationCity.className = 'station-city';
                                    stationCity.innerHTML = `<i class="fas fa-map-marker-alt me-1"></i>${meta.city || ''}`;
                                    stationInfo.appendChild(stationName);
                                    stationInfo.appendChild(stationCity);

                                    const stationRole = document.createElement('div');
                                    stationRole.className = 'station-actions';
                                    const badge = document.createElement('span');
                                    badge.className = 'badge bg-light text-dark border';
                                    badge.textContent = index === 0 ? 'Departure' :
                                        (index === sequence.length - 1 ? 'Destination' : 'Intermediate');
                                    stationRole.appendChild(badge);

                                    const hiddenInput = document.createElement('input');
                                    hiddenInput.type = 'hidden';
                                    hiddenInput.name = 'stationIds';
                                    hiddenInput.value = stationId;

                                    row.appendChild(stationNumber);
                                    row.appendChild(stationInfo);
                                    row.appendChild(stationRole);
                                    row.appendChild(hiddenInput);
                                    stationDiv.appendChild(row);
                                    selectedStations.appendChild(stationDiv);
                                });
                            }

                            function moveIntermediate(index, offset) {
                                const newIndex = index + offset;
                                if (newIndex < 0 || newIndex >= intermediateOrder.length) {
                                    return;
                                }
                                const [removed] = intermediateOrder.splice(index, 1);
                                intermediateOrder.splice(newIndex, 0, removed);
                                renderIntermediateList();
                                renderStationPreview();
                            }

                            function renderIntermediateList() {
                                intermediateList.innerHTML = '';
                                if (!intermediateOrder.length) {
                                    const placeholder = document.createElement('div');
                                    placeholder.className = 'text-center text-muted py-3';
                                    placeholder.textContent = 'No intermediate stops selected.';
                                    intermediateList.appendChild(placeholder);
                                    intermediateList.classList.add('empty');
                                    return;
                                }
                                intermediateList.classList.remove('empty');

                                intermediateOrder.forEach((stationId, index) => {
                                    const meta = getStationMeta(stationId);
                                    const stationDiv = document.createElement('div');
                                    stationDiv.className = 'station-item list-group-item';
                                    stationDiv.dataset.stationId = stationId;

                                    const wrapper = document.createElement('div');
                                    wrapper.className = 'd-flex align-items-center justify-content-between gap-2';

                                    const infoWrapper = document.createElement('div');
                                    infoWrapper.className = 'd-flex align-items-center gap-2 flex-grow-1';

                                    const stationNumber = document.createElement('span');
                                    stationNumber.className = 'station-number';
                                    stationNumber.textContent = index + 1;

                                    const stationInfo = document.createElement('div');
                                    stationInfo.className = 'station-info';
                                    stationInfo.innerHTML = `<div class="station-name">${meta.name}</div>
                                    <div class="station-city"><i class="fas fa-map-marker-alt me-1"></i>${meta.city || ''}</div>`;

                                    infoWrapper.appendChild(stationNumber);
                                    infoWrapper.appendChild(stationInfo);

                                    const actions = document.createElement('div');
                                    actions.className = 'station-actions d-flex align-items-center gap-1';

                                    const upBtn = document.createElement('button');
                                    upBtn.type = 'button';
                                    upBtn.className = 'btn btn-sm btn-outline-secondary';
                                    upBtn.innerHTML = '<i class="fas fa-arrow-up"></i>';
                                    upBtn.disabled = index === 0;
                                    upBtn.addEventListener('click', () => moveIntermediate(index, -1));

                                    const downBtn = document.createElement('button');
                                    downBtn.type = 'button';
                                    downBtn.className = 'btn btn-sm btn-outline-secondary';
                                    downBtn.innerHTML = '<i class="fas fa-arrow-down"></i>';
                                    downBtn.disabled = index === intermediateOrder.length - 1;
                                    downBtn.addEventListener('click', () => moveIntermediate(index, 1));

                                    const removeBtn = document.createElement('button');
                                    removeBtn.type = 'button';
                                    removeBtn.className = 'btn btn-sm btn-outline-danger';
                                    removeBtn.innerHTML = '<i class="fas fa-times"></i>';
                                    removeBtn.addEventListener('click', () => {
                                        intermediateOrder.splice(index, 1);
                                        renderIntermediateList();
                                        refreshAvailableStationOptions();
                                        renderStationPreview();
                                    });

                                    actions.appendChild(upBtn);
                                    actions.appendChild(downBtn);
                                    actions.appendChild(removeBtn);

                                    wrapper.appendChild(infoWrapper);
                                    wrapper.appendChild(actions);
                                    stationDiv.appendChild(wrapper);
                                    intermediateList.appendChild(stationDiv);
                                });
                            }

                            function refreshAvailableStationOptions() {
                                const lockedIds = new Set();
                                if (departureSelect.value) {
                                    lockedIds.add(departureSelect.value);
                                }
                                if (destinationSelect.value) {
                                    lockedIds.add(destinationSelect.value);
                                }
                                intermediateOrder.forEach(id => lockedIds.add(id));

                                Array.from(availableStations.options).forEach(option => {
                                    if (!option.value) {
                                        return;
                                    }
                                    const isLocked = lockedIds.has(option.value);
                                    option.disabled = isLocked;
                                    option.classList.toggle('text-muted', isLocked);
                                });
                            }

                            function pruneIntermediateTerminals() {
                                const locked = new Set();
                                if (departureSelect.value) {
                                    locked.add(departureSelect.value);
                                }
                                if (destinationSelect.value) {
                                    locked.add(destinationSelect.value);
                                }
                                const originalLength = intermediateOrder.length;
                                intermediateOrder = intermediateOrder.filter(id => !locked.has(id));
                                if (intermediateOrder.length !== originalLength) {
                                    renderIntermediateList();
                                }
                            }

                            departureSelect.addEventListener('change', function () {
                                if (this.value && this.value === destinationSelect.value) {
                                    alert('Departure and destination terminals must be different.');
                                    this.value = '';
                                    return;
                                }
                                pruneIntermediateTerminals();
                                refreshAvailableStationOptions();
                                renderStationPreview();
                            });

                            destinationSelect.addEventListener('change', function () {
                                if (this.value && this.value === departureSelect.value) {
                                    alert('Departure and destination terminals must be different.');
                                    this.value = '';
                                    return;
                                }
                                pruneIntermediateTerminals();
                                refreshAvailableStationOptions();
                                renderStationPreview();
                            });

                            addIntermediateBtn.addEventListener('click', function () {
                                if (!departureSelect.value || !destinationSelect.value) {
                                    alert('Please select both terminals before adding intermediate stops.');
                                    return;
                                }
                                const selections = Array.from(availableStations.selectedOptions);
                                if (!selections.length) {
                                    alert('Select at least one station to add.');
                                    return;
                                }
                                let added = false;
                                selections.forEach(option => {
                                    if (!option.value || option.disabled) {
                                        return;
                                    }
                                    if (!intermediateOrder.includes(option.value)) {
                                        intermediateOrder.push(option.value);
                                        added = true;
                                    }
                                });
                                availableStations.selectedIndex = -1;
                                if (added) {
                                    renderIntermediateList();
                                    refreshAvailableStationOptions();
                                    renderStationPreview();
                                }
                            });

                            clearIntermediateBtn.addEventListener('click', function () {
                                if (!intermediateOrder.length) {
                                    return;
                                }
                                if (!confirm('Remove all intermediate stops?')) {
                                    return;
                                }
                                intermediateOrder = [];
                                renderIntermediateList();
                                refreshAvailableStationOptions();
                                renderStationPreview();
                            });

                            document.querySelector('form').addEventListener('submit', function (e) {
                                const stationCount = selectedStations.querySelectorAll('input[name="stationIds"]').length;
                                if (stationCount < 2) {
                                    e.preventDefault();
                                    alert('Please select at least two stations (departure and destination).');
                                }
                            });

                            renderIntermediateList();
                            refreshAvailableStationOptions();
                            renderStationPreview();
                        });
                    </script>
            </body>

            </html>