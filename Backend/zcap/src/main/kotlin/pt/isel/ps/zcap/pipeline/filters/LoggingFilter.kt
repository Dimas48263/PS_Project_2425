package pt.isel.ps.zcap.pipeline.filters

import jakarta.servlet.Filter
import jakarta.servlet.FilterChain
import jakarta.servlet.ServletRequest
import jakarta.servlet.ServletResponse
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Component
import org.springframework.util.StopWatch

private val logger = LoggerFactory.getLogger(LoggingFilter::class.java)

@Component
class LoggingFilter : Filter {
    override fun doFilter(
        request: ServletRequest, response: ServletResponse, chain: FilterChain
    ) {

        val httpRequest = request as HttpServletRequest
        val httpResponse = response as HttpServletResponse
        val sw = StopWatch()
        sw.start()

        try {
            chain.doFilter(request, response)
            //ex: httpResponse.status = 403 //exemplo, rejeitar para controlo de acessos
            sw.stop()
            logger.info(
                "Request processed:\n\tMethod={}\tPath={}\tStatus={}\tDuration={}",
                httpRequest.method,
                httpRequest.requestURI,
                httpResponse.status,
                sw.totalTimeMillis,
            )
        } catch (th: Throwable) {
            sw.stop()
            logger.error(
                "Request processed with exception:\tError={}\tDuration={}",
                th.message,
                sw.totalTimeMillis,
            )
            throw th
        }
    }
}