package pt.isel.ps.zcap.api.users.userProfile

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import pt.isel.ps.zcap.repository.dto.users.userProfile.UserProfileInputModel
import pt.isel.ps.zcap.repository.dto.users.userProfile.UserProfileOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.users.userProfile.UserProfileService
import pt.isel.ps.zcap.services.users.userProfile.UserProfileServiceV1
import java.time.LocalDate

@RestController
@RequestMapping("api/users/profiles")
class UserProfilesController(
    private val userProfileService: UserProfileService,
) {
    /**
     **************************************************************************************
     *  User Profiles  *
     **************************************************************************************
     **/

    /**
     * GET all user profiles
     * Returns all existing profiles and the list of allowances associated to the profile
     **/
    @GetMapping
    fun getAllUserProfiles(): ResponseEntity<List<UserProfileOutputModel>> {
        val result = userProfileService.getAllUserProfiles()
        return ResponseEntity.ok(result)
    }

    /**
     * GET all user profiles valid in a given date (filter)
     * Returns all profiles within criteria
     **/
    @GetMapping("valid")
    fun getValidProfilesOn(@RequestParam date: LocalDate): ResponseEntity<List<UserProfileOutputModel>> {
        val result = userProfileService.getUserProfilesValidOn(date)
        return ResponseEntity.ok(result)
    }

    /**
     * GET specific profile by id
     **/
    @GetMapping("{userProfileId}")
    fun getUserProfilesById(@PathVariable userProfileId: Long): ResponseEntity<out Any> =
        when (val result = userProfileService.getUserProfileById(userProfileId = userProfileId)) {
            is Success -> ResponseEntity
                .status(HttpStatus.OK)
                .body(result.value)

            is Failure -> ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body("Record not found") //TODO: Add Errors
        }

    /**
     * POST adding a new profile to the system table
     */
    @PostMapping
    fun addUserProfile(@RequestBody userProfile: UserProfileInputModel): ResponseEntity<Any> =
        when (val result = userProfileService.addUserProfile(userProfile)) {
            is Success -> ResponseEntity
                .status(HttpStatus.CREATED)
                .body(result.value)

            is Failure -> ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body("Invalid user profile input.")
        }

    /**
     * PUT updating an existing user profile
     */
    @PutMapping("{userProfileId}")
    fun updateUserProfile(
        @PathVariable userProfileId: Long,
        @RequestBody userProfile: UserProfileInputModel
    ): ResponseEntity<out Any> =
        when (val result = userProfileService.updateUserProfile(userProfileId, userProfile)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
            is Failure -> ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body("Record not found") //TODO: Add Errors
        }
}