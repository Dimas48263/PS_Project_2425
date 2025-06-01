package pt.isel.ps.zcap.utils

import io.github.cdimascio.dotenv.dotenv

fun loadEnv() {
    val dotenv = dotenv()
    dotenv.entries().forEach {
        System.setProperty(it.key, it.value)
    }
}