package agencies

import grails.test.hibernate.HibernateSpec
import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class RootControllerSpec extends HibernateSpec implements ControllerUnitTest<RootController> {

    MeliService meliService
    GoogleService googleService
    def setup() {
        meliService = Mock()
        controller.meliService = meliService
        meliService.getMediosDePago() >> ["Rapipago","Pagofacil"]
        meliService.getAgencias("","","","","",) >> "err"
        meliService.getAgencias("rapipago","34.00","36.00","","",) >> [["agencia1","telefono1","direccion1"],["agencia2","telefono2","direccion2"]]


        googleService = Mock()
        controller.googleService = googleService
        googleService.getLatLng("Cervantes 621, Rio Tercero, Cordoba") >> [["lat","10.00"],["lng","10.00"]]
    }

    def cleanup() {
    }

    void "test getMediosDePago"(){
        when:
        def resp = controller.index()

        then:
        resp.size() == 2
    }

}
