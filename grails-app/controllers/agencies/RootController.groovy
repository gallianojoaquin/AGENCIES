package agencies

import grails.converters.JSON

class RootController {

    MeliService meliService
    GoogleService googleService

    def index() {
        return meliService.getMediosDePago()
    }

    def agencies(){

        if(params.direccion == ""){
            return ""
        }
        def ubicacion = googleService.getLatLng(params.direccion)

        if(ubicacion == "err"){
            return ""
        }

        if(params.servicio == "" || ubicacion.lat == "" || ubicacion.lng == ""){
            return ""
        }
        def agencias = meliService.getAgencias(params.servicio, ubicacion.lat, ubicacion.lng, params.distancia, params.cantidad)

        if(agencias == "err"){
            return ""
        }

        render agencias as JSON

    }

}
