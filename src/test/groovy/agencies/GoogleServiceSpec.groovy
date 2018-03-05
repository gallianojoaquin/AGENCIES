package agencies

import grails.test.hibernate.HibernateSpec
import grails.testing.services.ServiceUnitTest
import spock.lang.Specification

class GoogleServiceSpec extends HibernateSpec implements ServiceUnitTest<GoogleService>{

    def setup() {
    }

    def cleanup() {
    }

    void "test direccion vacia"(){
        when:
        def response = service.getLatLng("")

        then:
        assert response == "err"

    }

    void "test direccion ok"(){
        when:
        def response = service.getLatLng("Cervantes 621, Rio Tercero, Cordoba")

        then:
        assert response.size() == 2
    }

}
