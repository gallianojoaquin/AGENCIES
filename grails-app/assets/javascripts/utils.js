var map;
var miniMap;
var limites;
var marcadores = [];
function initMap() {
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 6
    });
    limites = new google.maps.LatLngBounds();
}
function dibujaMarkers(nombre,location, agencia){
    var coordenadas = location.split(',');
    var marker = new google.maps.Marker({
        position: {lat:parseFloat(coordenadas[0]), lng:parseFloat(coordenadas[1])},
        title: nombre
    });
    marker.addListener('click', function() {
        abirModal(agencia);
    });
    marker.setMap(map);

    marcadores.push(marker);
    limites.extend(marker.position);
    map.fitBounds(limites);
}

function dibujarMiniMapa(lat, lng) {
    miniMap = new google.maps.Map(document.getElementById('miniMap'), {
        center: {lat:parseFloat(lat), lng:parseFloat(lng)},
        zoom: 15
    });
    var marker = new google.maps.Marker({
        position: {lat:parseFloat(lat), lng:parseFloat(lng)}
    });
    marker.setMap(miniMap);
}

function abirModal(agencia){
    var coord = agencia[7].split(',');
    dibujarMiniMapa(coord[0], coord[1]);
    $("#lblAgency").text(agencia[0]);
    $("#lblDetalle").text("Dirección: " + agencia[1] + ", " + agencia[2] + ", " + agencia[3] + ", " + agencia[4] + ".");
    $("#lblPhone").text("Teléfono: " + agencia[8]);
    $("#lblZipCode").text("Código Postal: " + agencia[5]);
    $("#lblOther").text("Otra información: " + agencia[6]);
    $('#detalleModal').modal();
}

function validarFormulario(){
    var mensaje = "";
    var elemento;
    if($("#agenciaId").val() == ""){
        mensaje = "Debe seleccionar un medio de pago.";
        elemento = "agenciaId";
    }
    else if($("#direccionId").val() == ""){
        mensaje = "Debe ingresar una dirección.";
        elemento = "direccionId";
    }
    else if(isNaN($("#distanciaId").val())){
        mensaje = "La distancia debe ser un valor numérico.";
        elemento = "distanciaId";
    }
    else if(isNaN($("#cantidadId").val())){
        mensaje = "La cantidad debe ser un valor numérico.";
        elemento = "cantidadId";
    }

    if(mensaje != ""){
        $("#lblMessage").text(mensaje);
        $('#errorMessage').modal();
        $("#" + elemento).focus();
        return false;
    }

    return true;
}

function loading(){
    $('#loading').modal('toggle');
}