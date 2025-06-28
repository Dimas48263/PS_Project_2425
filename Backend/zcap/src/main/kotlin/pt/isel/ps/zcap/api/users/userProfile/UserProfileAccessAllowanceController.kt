package pt.isel.ps.zcap.api.users.userProfile

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import pt.isel.ps.zcap.services.users.userProfile.UserProfileAccessAllowanceService
import pt.isel.ps.zcap.repository.dto.users.userProfile.UserProfileAccessAllowanceOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.Success


@RestController
@RequestMapping("api/users/profiles/allowances")
class UserProfileAccessAllowanceController(
    private val allowanceService: UserProfileAccessAllowanceService
) {

    /**
     * GET all access allowances
     */
    @GetMapping
    fun getAllAllowances(): ResponseEntity<List<UserProfileAccessAllowanceOutputModel>> {
        val result = allowanceService.getAllAllowances()
        return ResponseEntity.ok(result)
    }

    /**
     * GET specific allowance by id
     */
    @GetMapping("{allowanceId}")
    fun getAllowanceById(@PathVariable allowanceId: Long): ResponseEntity<out Any> =
        when (val result = allowanceService.getAllAllowancesById(allowanceId)) {
            is Success -> ResponseEntity.ok(result.value)
            is Failure -> ResponseEntity.status(HttpStatus.NOT_FOUND).body("Allowance not found")
        }
}