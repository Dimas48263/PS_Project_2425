package pt.isel.ps.zcap.api.system

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/ping")
class PingController {

    @GetMapping
    fun ping(): ResponseEntity<String> = ResponseEntity.ok("Api is online")
}