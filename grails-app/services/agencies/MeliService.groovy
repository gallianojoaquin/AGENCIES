package agencies

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import groovy.json.JsonSlurper

@Transactional
class MeliService {

    def getMediosDePago(){
        def url = new URL('https://api.mercadolibre.com/sites/MLA/payment_methods')
        def connection = (HttpURLConnection)url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozzilla/5.0")
        JsonSlurper json = new JsonSlurper()

        try{
            [lista: json.parse(connection.getInputStream()).findAll{x -> x.payment_type_id == "ticket"}]
        }
        catch (UnknownHostException ex){
            return "err"
        }
    }

    def getAgencias(servicio,lat, lng, distancia, cantidad){
        if(servicio == "" || lat == "" || lng == ""){
            return "err"
        }
        def stringURL = "https://api.mercadolibre.com/sites/MLA/payment_methods/"+ servicio+"/agencies?near_to=" + lat + "," + lng
        if(distancia != ""){
            stringURL += "," + distancia
        }
        if(cantidad != ""){
            stringURL += "&limit=" + cantidad
        }
        stringURL += "&sort_by=distance,asc"
        def url = new URL(stringURL)
        def connection = (HttpURLConnection)url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozzilla/5.0")
        JsonSlurper json = new JsonSlurper()

        try{
            return json.parse(connection.getInputStream())
        }
        catch (UnknownHostException ex){
            return "err"
        }
    }
}
