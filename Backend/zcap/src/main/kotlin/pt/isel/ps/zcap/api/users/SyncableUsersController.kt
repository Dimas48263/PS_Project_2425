package pt.isel.ps.zcap.api.users

import org.springframework.format.annotation.DateTimeFormat
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import pt.isel.ps.zcap.repository.dto.users.UserInputModel
import pt.isel.ps.zcap.repository.dto.users.UserOutputModel
import pt.isel.ps.zcap.repository.dto.users.UserPasswordUpdateInputModel
import pt.isel.ps.zcap.repository.dto.users.UserUpdateInputModel
import pt.isel.ps.zcap.services.Failure
import pt.isel.ps.zcap.services.Success
import pt.isel.ps.zcap.services.users.SyncableUserService
import java.time.LocalDate

@RestController
@RequestMapping("api/syncable/users")
class SyncableUsersController(
    private val userService: SyncableUserService,
) {

    /**
     * GET all users
     * Returns all existing users with password for offline-first apps usage
     **/
    @GetMapping
    fun getSyncableAllUsers(): ResponseEntity<List<UserOutputModel>> {
        val result = userService.getSyncableAllUsers()
        return ResponseEntity.ok(result)
    }

    /**
     * GET all users valid in a given date (filter)
     * Returns all users within criteria
     **/
    @GetMapping("valid")
    fun getSyncableValidUsersOn(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate): ResponseEntity<List<UserOutputModel>> {
        val result = userService.getSyncableUsersValidOn(date)
        return ResponseEntity.ok(result)
    }

    /**
     * GET specific user by id
     **/
    @GetMapping("id/{userId}")
    fun getSyncableUserById(@PathVariable userId: Long): ResponseEntity<Any> =
        when (val result = userService.getSyncableUserById(userId = userId)) {
            is Success -> ResponseEntity
                .status(HttpStatus.OK)
                .body(result.value)

            is Failure -> ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body("Record not found") //TODO: Add Errors
        }

    /**
     * GET specific users by userName
     **/
    @GetMapping("user/{userName}")
    fun getSyncableUserByUserName(@PathVariable userName: String): ResponseEntity<Any> =
        when (val result = userService.getSyncableUsersByUserName(userName = userName)) {
            is Success -> ResponseEntity
                .status(HttpStatus.OK)
                .body(result.value)

            is Failure -> ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body("Record not found") //TODO: Add Errors
        }

    /**
     * POST adding a new user
     */
    @PostMapping
    fun syncableAddUser(@RequestBody user: UserInputModel): ResponseEntity<Any> =
        when (val result = userService.syncableAddUser(user)) {
            is Success -> ResponseEntity
                .status(HttpStatus.CREATED)
                .body(result.value)

            is Failure -> ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body("Invalid user input.")
        }

    /**
     * PUT updating an existing user profile
     */
    @PutMapping("{userId}")
    fun syncableUpdateUser(
        @PathVariable userId: Long,
        @RequestBody user: UserUpdateInputModel
    ): ResponseEntity<Any> =
        when (val result = userService.syncableUpdateUser(userId, user)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
            is Failure -> ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body("Record not found") //TODO: Add Errors
        }

    @PutMapping("{userId}/password")
    fun syncableUpdatePassword(
        @PathVariable userId: Long,
        @RequestBody userPasswordUpdateInputModel: UserPasswordUpdateInputModel
    ): ResponseEntity<Any> {
        val result = userService.syncableUpdatePassword(
            userId = userId,
            currentPassword = userPasswordUpdateInputModel.currentPassword,
            newPassword = userPasswordUpdateInputModel.newPassword
        )

        return when (result) {
            is Success -> ResponseEntity
                .status(HttpStatus.OK)
                .body(result.value)

            is Failure -> ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body("Invalid change") //TODO: Insert better error messages
        }
    }
}