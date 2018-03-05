package agencies

import grails.gorm.transactions.Transactional
import groovy.json.JsonSlurper

@Transactional
class GoogleService {

    def getLatLng(direccion){
        if(direccion == ""){
            return "err"
        }
        def encode = URLEncoder.encode(direccion,"UTF-8")
        def url = new URL('https://maps.googleapis.com/maps/api/geocode/json?address='+ encode +'&key=AIzaSyB-LUkMd70UP8uZF8G_B8R5uEuMHCP06tQ')
        def connection = (HttpURLConnection)url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozzilla/5.0")
        JsonSlurper json = new JsonSlurper()

        try{
            def respuesta = json.parse(connection.getInputStream())

            def latitud = respuesta
                    .results[0]
                    .geometry
                    .location
                    .lat
            def longitud = respuesta
                    .results[0]
                    .geometry
                    .location
                    .lng

            def ubicacion = [:]
            ubicacion << [lat:latitud]
            ubicacion << [lng:longitud]

            return ubicacion
        }
        catch (UnknownHostException ex){
            return "err"
        }

    }
}
