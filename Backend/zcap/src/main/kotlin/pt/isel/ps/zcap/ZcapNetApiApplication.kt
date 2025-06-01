package pt.isel.ps.zcap

import io.swagger.v3.oas.annotations.OpenAPIDefinition
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType
import io.swagger.v3.oas.annotations.info.Contact
import io.swagger.v3.oas.annotations.info.Info
import io.swagger.v3.oas.annotations.security.SecurityScheme
import io.swagger.v3.oas.annotations.servers.Server
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import pt.isel.ps.zcap.utils.loadEnv


@OpenAPIDefinition(
    info = Info(
        title = "API do projeto ZCAP Web - Sistema de apoio à Proteção Civil",
        version = "1.0.0",
        description = """
            Grupo 43:
                Luis Alves - 46974
                Gonçalo Dimas - 48263
            
            Esta API utiliza autenticação JWT.
            
            ➤ Para autenticar, clique em **Authorize** no topo da Swagger UI e insira o token.
            ➤ Para obter o token utilize o metodo "login" e consulte o Cookie.
        """,
    ),
    servers = [
        Server(url = "http://localhost:8080", description = "Servidor local de desenvolvimento")
    ],
)

@SecurityScheme(
    name = "BearerAuth",
    type = SecuritySchemeType.HTTP,
    scheme = "bearer",
    bearerFormat = "JWT"
)
@SpringBootApplication
class ZcapNetApiApplication

fun main(args: Array<String>) {
    loadEnv()
    runApplication<ZcapNetApiApplication>(*args)
}
