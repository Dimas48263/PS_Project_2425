package pt.isel.ps.zcap.api.users.userDataProfile

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import pt.isel.ps.zcap.repository.dto.users.userDataProfile.UserDataProfileDetailInputModel
import pt.isel.ps.zcap.repository.dto.users.userDataProfile.UserDataProfileDetailOutputModel
import pt.isel.ps.zcap.repository.dto.users.userDataProfile.UserDataProfileInputModel
import pt.isel.ps.zcap.repository.dto.users.userDataProfile.UserDataProfileOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.users.userDataProfile.UserDataProfileDetailService
import pt.isel.ps.zcap.services.users.userDataProfile.UserDataProfileService
import java.time.LocalDate

@RestController
@RequestMapping("api/users/dataprofiles")
class UserDataProfilesController(
    private val userDataProfileService: UserDataProfileService,
    private val userDataProfileDetailService: UserDataProfileDetailService
) {
    /**
     **************************************************************************************
     *  User DataProfiles  *
     **************************************************************************************
     **/
    /**
     * GET all user Data Profiles
     * Returns all existing data profiles
     **/
    @GetMapping()
    fun getAllUserDataProfiles(): ResponseEntity<List<UserDataProfileOutputModel>> {
        val result = userDataProfileService.getAllUserDataProfiles()
        return ResponseEntity.status(HttpStatus.OK).body(result)
    }

    /**
     * GET all user data profiles valid in a given date (filter)
     * Returns all data profiles within criteria
     **/
    @GetMapping("valid")
    fun getValidProfilesOn(@RequestParam date: LocalDate): ResponseEntity<List<UserDataProfileOutputModel>> {
        val result = userDataProfileService.getUserDataProfilesValidOn(date)
        return ResponseEntity.status(HttpStatus.OK).body(result)
    }

    /**
     * GET specific data profile by id
     **/
    @GetMapping("{userDataProfileId}")
    fun getAllUserDataProfiles(@PathVariable userDataProfileId: Long): ResponseEntity<out Any> =
        when (val result = userDataProfileService.getUserDataProfileById(userDataProfileId = userDataProfileId)) {
            is Success -> ResponseEntity
                .status(HttpStatus.OK)
                .body(result.value)

            is Failure -> ResponseEntity(result.value.errorResponse, result.value.httpStatus)
        }

    /**
     * POST adding a new profile to the system table
     */
    @PostMapping
    fun addUserDataProfile(@RequestBody userDataProfile: UserDataProfileInputModel): ResponseEntity<Any> =
        when (val result = userDataProfileService.addUserDataProfile(userDataProfile)) {
            is Success -> ResponseEntity
                .status(HttpStatus.CREATED)
                .body(result.value)

            is Failure -> ResponseEntity(result.value.errorResponse, result.value.httpStatus)
        }

    /**
     * PUT updating an existing user data profile
     */
    @PutMapping("{userDataProfileId}")
    fun updateUserDataProfile(
        @PathVariable userDataProfileId: Long,
        @RequestBody userDataProfile: UserDataProfileInputModel
    ): ResponseEntity<out Any> =
        when (val result = userDataProfileService.updateUserDataProfile(userDataProfileId, userDataProfile)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
            is Failure -> ResponseEntity(result.value.errorResponse, result.value.httpStatus)
        }

    /**
     **************************************************************************************
     *  User DataProfileDetails  *
     **************************************************************************************
     */
    /**
     * GET all DataProfileDetails
     */
    @GetMapping("details")
    fun getUserDataProfileDetails(): ResponseEntity<List<UserDataProfileDetailOutputModel>> {
        val details = userDataProfileDetailService.getAllProfilesDetails()
        return ResponseEntity.status(HttpStatus.OK).body(details)
    }

    /**
     * GET all DataProfileDetails for a specific profile
     */
    @GetMapping("{dataProfileId}/details")
    fun getUserDataProfileDetailsById(@PathVariable dataProfileId: Long): ResponseEntity<List<UserDataProfileDetailOutputModel>> {
        val details = userDataProfileDetailService.getAllDetailsForProfile(dataProfileId)
        return ResponseEntity.status(HttpStatus.OK).body(details)
    }

    /**
     * POST new DataProfileDetail
     */
    @PostMapping("detail")
    fun addUserDataProfileDetail(@RequestBody detail: UserDataProfileDetailInputModel): ResponseEntity<Any> =
        when (val result = userDataProfileDetailService.addDetail(detail)) {
            is Success -> ResponseEntity
                .status(HttpStatus.CREATED)
                .header("Location", "/dataprofiles/${result.value.userDataProfileId}/details")
                .body(result.value)

            is Failure -> ResponseEntity(result.value.errorResponse, result.value.httpStatus)
        }

    @DeleteMapping("{userDataProfileId}/detail/{treeRecordId}")
    fun deleteUserDataProfileDetail(
        @PathVariable userDataProfileId: Long,
        @PathVariable treeRecordId: Long
    ): ResponseEntity<Any> {
        val input = UserDataProfileDetailInputModel(
            userDataProfileId = userDataProfileId,
            treeRecordId = treeRecordId,
        )
        return when (
            val result = userDataProfileDetailService.deleteDetailById(input)
        ) {
            is Success -> ResponseEntity.status(HttpStatus.NO_CONTENT).build()
            is Failure -> ResponseEntity(result.value.errorResponse, result.value.httpStatus)
        }
    }
}