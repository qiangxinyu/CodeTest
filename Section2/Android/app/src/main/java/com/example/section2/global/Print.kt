
import android.util.Log
import com.example.section2.BuildConfig

private const val maxLength = 4000
private const val tag = "Print"

public fun Print(vararg value: Any?) {
    if (!BuildConfig.DEBUG) {
        return
    }
    val logStr = getResult(*value)
    if (logStr.length > maxLength) {
        Log.d(tag, logStr.substring(0, maxLength))
        Print(logStr.substring(maxLength))
    } else  Log.d(tag, logStr)
}


private fun getResult(vararg value: Any?): String {
    var result = ""
    for (v in value) {
        result += "   $v"
    }
    return result
}