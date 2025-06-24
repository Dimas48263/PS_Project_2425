package pt.isel.ps.zcap.domain.supportTables

import com.fasterxml.jackson.annotation.JsonCreator

enum class DataTypes {
    BOOLEAN,
    INT,
    STRING,
    DOUBLE,
    CHAR,
    FLOAT;

    companion object {
        @JsonCreator
        @JvmStatic
        fun from(value: String): DataTypes {
            return values().firstOrNull { it.name.equals(value, ignoreCase = true) }
                ?: throw IllegalArgumentException("Invalid data type: $value")
        }
    }
}

