package pt.isel.ps.zcap.domain.users.userProfile

enum class AccessType(val value: Int) {
    READ_WRITE(0),
    READ_ONLY(1),
    NO_ACCESS(2);
}