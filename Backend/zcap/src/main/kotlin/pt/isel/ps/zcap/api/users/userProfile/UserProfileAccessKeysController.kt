package pt.isel.ps.zcap.api.users.userProfile


import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import pt.isel.ps.zcap.repository.dto.users.userProfile.UserProfileAccessKeyInputModel
import pt.isel.ps.zcap.repository.dto.users.userProfile.UserProfileAccessKeyOutputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.users.userProfile.UserProfileAccessKeysService

@Controller
@RequestMapping("api/users/access-keys")
class UserProfileAccessKeysController(
    private val userProfileAccessKeysService: UserProfileAccessKeysService
) {

    /**
     **************************************************************************************
     *  User Profile Access Keys  *
     **************************************************************************************
     **/

    /**
     * GET all user profile access keys
     * Returns all existing profile access keys. These keys are to be used to manage access to specific parts of the api/frontend
     **/
    @GetMapping
    fun getAllUserProfileAccessKeys(): ResponseEntity<List<UserProfileAccessKeyOutputModel>> {
        val result = userProfileAccessKeysService.getAllAccessKeys()
        return ResponseEntity.ok(result)
    }

    /**
     * GET specific access keys by id
     * @param userProfileAccessKeyId the record unique identifier
     * @return 200 Updated and the output model:
     *  - userProfileAccessKeyId: record unique identifier
     *  - accessKey: unique string identifier for the access.
     *  - description: a human-readable description.
     * @return 404 Not found if fails.
     **/
    @GetMapping("{userProfileAccessKeyId}")
    fun getAccessKeyById(@PathVariable userProfileAccessKeyId: Long): ResponseEntity<out Any> =
        when (val result = userProfileAccessKeysService.getAccessKeyById(accessKeyId = userProfileAccessKeyId)) {
            is Success -> ResponseEntity
                .status(HttpStatus.OK)
                .body(result.value)

            is Failure -> ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body("Record not found") //TODO: Add Errors
        }

    /**
     * POST adding a new access Key to the system.
     * @param accessKey the input model containing:
     *  - accessKey: unique string identifier for the access.
     *  - description: a human-readable description.
     * @return 201 Created and the output model:
     * - userProfileAccessKeyId: record unique identifier
     * - accessKey: unique string identifier for the access.
     * - description: a human-readable description.
     * @return 400 Bad Request if fails.
     */
    @PostMapping
    fun addAccessKey(@RequestBody accessKey: UserProfileAccessKeyInputModel): ResponseEntity<Any> {
        return when (val result = userProfileAccessKeysService.addAccessKey(accessKey)) {
            is Success -> ResponseEntity.status(HttpStatus.CREATED).body(result.value)
            is Failure -> ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid accessKey input.")
        }
    }

    /**
     * PUT updating an existing access Key
     * @param userProfileAccessKeyId the record unique identifier
     * @param accessKey the input model containing:
     *  - accessKey: unique string identifier for the access.
     *  - description: a human-readable description.
     * @return 200 Updated and the output model:
     *  - userProfileAccessKeyId: record unique identifier
     *  - accessKey: unique string identifier for the access.
     *  - description: a human-readable description.
     * @return 404 Not found if fails.
     */
    @PutMapping("{userProfileAccessKeyId}")
    fun updateAccessKey(
        @PathVariable userProfileAccessKeyId: Long,
        @RequestBody accessKey: UserProfileAccessKeyInputModel
    ): ResponseEntity<Any> {
        return when (val result = userProfileAccessKeysService.updateAccessKey(userProfileAccessKeyId, accessKey)) {
            is Success -> ResponseEntity.ok(result.value)
            is Failure -> ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body("Record not found") //TODO: Add Errors
        }
    }
}