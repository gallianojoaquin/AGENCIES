<!DOCTYPE html>
<html>
<head>
    <title>Agencias - Geolocalizacion</title>
    <!-- DATATABLE -->
    <link rel="StyleSheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" type="text/css" >
    <script src="https://code.jquery.com/jquery-1.12.4.js" type="application/javascript"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js" type="application/javascript"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js" type="application/javascript"></script>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <!-- GOOGLE MAPS API -->
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB-LUkMd70UP8uZF8G_B8R5uEuMHCP06tQ"
            async defer></script>
    <!-- Archivos Propios -->
    <script src="../assets/utils.js"></script>
    <link rel="StyleSheet" href="../assets/utils.css" type="text/css" >
    <script>
        function getAgencies(){

            if(!validarFormulario()){
                return false;
            }
            loading();

            if($("#agencias")){
                $("#agencias").remove();
            }
            if($("#map")){
                $("#map").remove();
            }

            var id = $("#agenciaId").val();
            var direccion = $("#direccionId").val();
            var distancia = $("#distanciaId").val();
            var cantidad = $("#cantidadId").val();


            $.ajax({
                type:"POST",
                url:'${createLink( controller:'root', action:'agencies')}',
                data:{
                    servicio:id,
                    direccion:direccion,
                    distancia:distancia,
                    cantidad:cantidad
                },
                success:function(resp){
                    $(document).ready(function(){
                        $("#divDer").attr('style','display:inline;');
                        $("#divDer").append("<div id='agencias' style='width: 90%; margin-left: 5%'></div>");
                        $("#divIzq").append("<div id='map' style='width: 460px; margin-left: 3%'></div>");
                        initMap();
                        $("#agencias").append("<table id='tablaAgencias' class='table table-striped table-bordered' cellspacing='0' width='100%'><thead><tr><th style='width: 30%'>Código de Agencia</th><th style='width: 50%'>Nombre</th><th style='width: 20%'>Distancia</th><th class='no-sort'></th></tr></thead><tbody></tbody></table>");
                        $.each(resp.results, function(i, item){
                            agencia = [item.description,item.address.address_line,item.address.city,item.address.state,item.address.country,item.address.zip_code,item.address.other_info,item.address.location,item.phone]
                            $("#tablaAgencias > tbody").append("<tr><td>"+ item.agency_code +"</td><td>"+ item.description +"</td><td>"+ Math.round(item.distance * 100) / 100 +" mts.</td><td><button type='button' id='verMas' class='btn btn-default' onclick='abirModal(agencia)'><span class=\"glyphicon glyphicon-search\" aria-hidden=\"true\"></span></button></td></tr>");
                            dibujaMarkers(item.description, item.address.location, agencia);
                        });
                        $('#tablaAgencias').DataTable({
                            "order": [],
                            "columnDefs": [ {
                                "targets": 'no-sort',
                                "orderable": false
                            } ]
                        });
                        loading();
                    });
                }
            });
        }
    </script>
</head>
<body>
    <div id="header">
        <span>BÚSQUEDA DE AGENCIAS</span>
    </div>
    <div class="row">
        <div id="divIzq" class="col-md-5">
            <div id="formulario" class="formulario">
                <div class="interno" >
                    <label>Medio de pago:</label>
                    <g:select name="agenciaId" id="agenciaId" from="${lista}" optionValue="${{it.name}}" optionKey="${{it.id}}"
                              noSelection="['':'-Seleccione un medio de pago-']" class="form-control"/>
                    <br/>
                    <label>Dirección:</label>
                    <input type="text" id="direccionId" size="50" value="Cervantes 621, Rio Tercero, Cordoba, Argentina" class="form-control input-sm"/>
                    <br/>
                    <label>Distancia (En metros):</label><input type="text" id="distanciaId" size="10" value="" class="form-control input-sm"/>
                    <br/>
                    <label>Cantidad:</label><input type="text" id="cantidadId"  size="5" value="" class="form-control input-sm"/>
                    <br/>
                    <button type="button" onclick="getAgencies()" class="btn btn-primary">Buscar</button>
                </div>
            </div>
        </div>
        <div id="divDer" class="col-md-7"></div>
    </div>
    <!-- MODAL PARA DETALLE DE AGENCIAS -->
    <div class="modal fade" id="detalleModal" tabindex="-1" role="dialog" aria-labelledby="detalleModalLabel" >
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="detalleModalLabel">Agencia: <label id="lblAgency"></label></h4>
                </div>
                <div class="modal-body" style="width: 90%; margin-left: 5%;">
                    <div id="miniMap"></div><br/>
                    <label id="lblDetalle"></label><br/>
                    <label id="lblPhone"></label><br/>
                    <label id="lblZipCode"></label><br/>
                    <label id="lblOther"></label>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <!-- MODAL PARA ERRORES -->
    <div class="modal fade" id="errorMessage" tabindex="-1" role="dialog" aria-labelledby="errorMessageLabel" >
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="errorMessageLabel">Advertencia!</h4>
                </div>
                <div class="modal-body" style="width: 90%; margin-left: 5%;">
                    <label id="lblMessage"></label>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <!-- MODAL CARGANDO -->
    <div class="modal fade" id="loading" tabindex="-1" role="dialog" aria-labelledby="loadingLabel" >
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-body" style="width: 90%; margin-left: 5%; text-align: center;">
                    <img src="../assets/spinner.gif">
                </div>
            </div>
        </div>
    </div>

</body>
</html>