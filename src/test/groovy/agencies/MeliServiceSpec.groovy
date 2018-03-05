package agencies

import grails.test.hibernate.HibernateSpec
import grails.testing.services.ServiceUnitTest
import spock.lang.Specification

class MeliServiceSpec extends HibernateSpec implements ServiceUnitTest<MeliService>{

    def setup() {
    }

    def cleanup() {
    }

    void "test getMediosDePago"(){
        when:
        def response = service.getAgencias("","","","","")

        then:
        response == "err"
    }

    void "test getMediosDePago valido"(){
        when:
        def response = service.getAgencias("rapipago","-32.1833","-64.1","","")

        then:
        response.size() > 0
    }

}
