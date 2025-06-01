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
import pt.isel.ps.zcap.services.users.UserService
import java.time.LocalDate

@RestController
@RequestMapping("api/users")
class UsersController(
    private val userService: UserService,
) {

    /**
     **************************************************************************************
     *  Users  *
     **************************************************************************************
     **/

    /**
     * GET all users
     * Returns all existing users
     **/
    @GetMapping
    fun getAllUsers(): ResponseEntity<List<UserOutputModel>> {
        val result = userService.getAllUsers()
        return ResponseEntity.ok(result)
    }

    /**
     * GET all users valid in a given date (filter)
     * Returns all users within criteria
     **/
    @GetMapping("valid")
    fun getValidUsersOn(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate): ResponseEntity<List<UserOutputModel>> {
        val result = userService.getUsersValidOn(date)
        return ResponseEntity.ok(result)
    }

    /**
     * GET specific user by id
     **/
    @GetMapping("id/{userId}")
    fun getUserById(@PathVariable userId: Long): ResponseEntity<Any> =
        when (val result = userService.getUserById(userId = userId)) {
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
    fun getUserByUserName(@PathVariable userName: String): ResponseEntity<Any> =
        when (val result = userService.getUsersByUserName(userName = userName)) {
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
    fun addUser(@RequestBody user: UserInputModel): ResponseEntity<Any> =
        when (val result = userService.addUser(user)) {
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
    fun updateUser(
        @PathVariable userId: Long,
        @RequestBody user: UserUpdateInputModel
    ): ResponseEntity<Any> =
        when (val result = userService.updateUser(userId, user)) {
            is Success -> ResponseEntity.status(HttpStatus.OK).body(result.value)
            is Failure -> ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body("Record not found") //TODO: Add Errors
        }

    @PutMapping("{userId}/password")
    fun updatePassword(
        @PathVariable userId: Long,
        @RequestBody userPasswordUpdateInputModel: UserPasswordUpdateInputModel
    ): ResponseEntity<Any> {
        val result = userService.updatePassword(
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