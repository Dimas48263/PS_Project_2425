package pt.isel.ps.zcap.services.users

import io.jsonwebtoken.Jwts
import org.springframework.stereotype.Service
import pt.isel.ps.zcap.domain.users.User
import pt.isel.ps.zcap.domain.users.UserDataProfile
import pt.isel.ps.zcap.domain.users.UserProfile
import pt.isel.ps.zcap.repository.dto.users.*
import pt.isel.ps.zcap.repository.models.users.UserRepository
import pt.isel.ps.zcap.services.Either
import pt.isel.ps.zcap.services.ServiceErrors
import pt.isel.ps.zcap.services.failure
import pt.isel.ps.zcap.services.success
import pt.isel.ps.zcap.utils.JwtConfig
import pt.isel.ps.zcap.utils.PasswordEncoder
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.*
import kotlin.jvm.optionals.getOrNull

@Service
class UserService(
    private val userRepository: UserRepository,
    private val userProfileService: UserProfileService,
    private val userDataProfileService: UserDataProfileService,
    private val passwordEncoder: PasswordEncoder,
    private val jwtConfig: JwtConfig
) {

    fun getAllUsers(): List<UserOutputModel> {
        val users: List<User> = userRepository.findAll()
        return users.map { toOutputModel(it) }
    }

    fun getUserById(userId: Long): Either<ServiceErrors, UserOutputModel> {
        val user: User = userRepository.findById(userId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        return success(toOutputModel(user))
    }

    fun getUsersByUserName(userName: String): Either<ServiceErrors, List<UserOutputModel>> {
        val users: List<User> = userRepository.findByUserName(userName)

        return if (users.isEmpty())
            failure(ServiceErrors.RecordNotFound)
        else
            success(users.map { toOutputModel(it) })
    }

    fun getUsersValidOn(date: LocalDate): List<UserOutputModel> {
        val validUsers = userRepository.findValidOnDate(date)
        return validUsers.map { toOutputModel(it) }
    }

    fun isUserNameValidForInterval(
        userName: String,
        newStart: LocalDate,
        newEnd: LocalDate? = null,
        excludingUserId: Long? = null
    ): Boolean {
        val existingUsers = userRepository.findByUserName(userName)

        return existingUsers.none { existingUser ->
            // Ignore self record (update)
            if (excludingUserId != null && existingUser.userId == excludingUserId) return@none true

            val existingStart = existingUser.startDate
            val existingEnd = existingUser.endDate

            // Overlap records return false
            return (newEnd == null || existingStart <= newEnd) &&
                    (existingEnd == null || existingEnd >= newStart)
        }
    }

    fun addUser(newUser: UserInputModel): Either<ServiceErrors, UserOutputModel> {

        if (!isPasswordComplex(password = newUser.password)) {
            return failure(ServiceErrors.InvalidPasswordComplexity)
        }

        if (!isUserNameValidForInterval(newUser.userName, newUser.startDate, newUser.endDate)) {
            return failure(ServiceErrors.RecordAlreadyExists)
        }

        val userProfile = userProfileService.internalGetUserProfileById(newUser.userProfileId)
        val userDataProfile = userDataProfileService.internalGetUserDataProfileById(newUser.userDataProfileId)

        if (newUser.name.isBlank()
            || newUser.startDate.isAfter(newUser.endDate ?: newUser.startDate)
            || userProfile == null
            || userDataProfile == null
        )
            return failure(ServiceErrors.InvalidDataInput)

        val user = toUser(
            inputData = newUser,
            userProfile = userProfile,
            userDataProfile = userDataProfile,
        )

        return try {
            success(toOutputModel(userRepository.save(user)))
        } catch (ex: Exception) {
            failure(ServiceErrors.InsertFailed)
        }
    }

    fun updateUser(userId: Long, user: UserUpdateInputModel): Either<ServiceErrors, UserOutputModel> {
        val existingUser = userRepository.findById(userId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        val userProfile = userProfileService.internalGetUserProfileById(user.userProfileId)
            ?: return failure(ServiceErrors.InvalidDataInput)

        val userDataProfile = userDataProfileService.internalGetUserDataProfileById(user.userDataProfileId)
            ?: return failure(ServiceErrors.InvalidDataInput)

        if (user.name.isBlank()
            || user.startDate.isAfter(user.endDate ?: user.startDate)
        ) {
            return failure(ServiceErrors.InvalidDataInput)
        }

        val updatedUser = existingUser.copy(
            userName = user.userName,
            name = user.name,
            userProfile = userProfile,
            userDataProfile = userDataProfile,
            startDate = user.startDate,
            endDate = user.endDate,
            updatedAt = LocalDateTime.now()
        )

        return try {
            val savedUser = userRepository.save(updatedUser)
            success(toOutputModel(savedUser))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun updatePassword(
        userId: Long,
        currentPassword: String,
        newPassword: String
    ): Either<ServiceErrors, UserOutputModel> {

        val user = userRepository.findById(userId).getOrNull()
            ?: return failure(ServiceErrors.RecordNotFound)

        if (!verifyPassword(user.password, currentPassword)) {
            return failure(ServiceErrors.InvalidUserNameOrPassword)
        }

        if (isPasswordComplex(password = newPassword)) {
            return failure(ServiceErrors.InvalidPasswordComplexity)
        }

        val newUser = user.copy(
            password = passwordEncoder.encrypt(newPassword),
            updatedAt = LocalDateTime.now()
        )

        return try {
            val updatedUser = userRepository.save(newUser)
            success(toOutputModel(updatedUser))
        } catch (ex: Exception) {
            failure(ServiceErrors.UpdateFailed)
        }
    }

    fun isPasswordComplex(password: String): Boolean {
        return password.length >= 8                         // length
                && password.any { it.isUpperCase() }        // has Uppercase
                && password.any { it.isLowerCase() }        // has Lowercase
                && password.any { !it.isLetterOrDigit() }   // has SpecialChar
    }

    fun verifyPassword(savedPassword: String, inputPassword: String): Boolean =
        passwordEncoder.verifyPassword(inputPassword, savedPassword)

    // Conversion from InputModel to domain Model
    private fun toUser(inputData: UserInputModel, userProfile: UserProfile, userDataProfile: UserDataProfile): User =
        User(
            userName = inputData.userName,
            name = inputData.name,
            password = passwordEncoder.encrypt(inputData.password),
            userProfile = userProfile,
            userDataProfile = userDataProfile,
            startDate = inputData.startDate,
            endDate = inputData.endDate,
            updatedAt = LocalDateTime.now()
        )

    // Conversion from domain Model to OutputModel
    private fun toOutputModel(user: User): UserOutputModel {

        return UserOutputModel(
            userId = user.userId,
            userName = user.userName,
            name = user.name,
            userProfile = userProfileService.toOutputModel(user.userProfile),
            userDataProfile = userDataProfileService.toOutputModel(user.userDataProfile),
            startDate = user.startDate,
            endDate = user.endDate,
            createdAt = user.createdAt,
            updatedAt = user.updatedAt
        )
    }

    fun getInternalUserByUserName(userName: String): User {
        return userRepository.findByUserName(userName)
            .firstOrNull { it.endDate == null || it.endDate.isAfter(LocalDate.now()) }
            ?: throw IllegalArgumentException("Username not found")

        //returns only the first record in the event of existing more than one valid on date
    }

    fun login(userLogin: LoginInputModel): LoginOutputModel {

        return try {
            val key = jwtConfig.jwtSecretKey()
            val now = Date(System.currentTimeMillis())
            val user = getInternalUserByUserName(userLogin.userName)
            if (!verifyPassword(user.password, userLogin.password)) {
                throw IllegalArgumentException("Password does not match")
            }

            LoginOutputModel(
                user = user,
                token = Jwts.builder()
                    .setIssuer(user.userId.toString())
                    .setIssuedAt(now)
                    .setExpiration(Date(now.time + 1000 * 60 * 60 * 8)) //expiration 8h
//                    .setExpiration(Date(now.time + 1000 * 60 * 3)) //expiration 3 min
                    .claim("userName", user.userName)
                    .claim("userProfile", user.userProfile.name)
                    .signWith(key)
                    .compact()
            )

        } catch (ex: Exception) {
            throw RuntimeException("Login failed: ${ex.message}")
        }
    }

    fun getAuthenticatedUser(jwt: String): Either<ServiceErrors, UserOutputModel> {

        val claims = Jwts.parserBuilder()
            .setSigningKey(jwtConfig.jwtSecretKey())
            .build()
            .parseClaimsJws(jwt)
            .body

        val userId = claims.issuer.toLong()

        return getUserById(userId)
    }
}
