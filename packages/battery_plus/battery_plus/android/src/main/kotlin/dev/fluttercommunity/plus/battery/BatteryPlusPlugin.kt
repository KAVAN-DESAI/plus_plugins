import android.annotation.SuppressLint
import android.content.Context
import android.content.BroadcastReceiver
import android.os.Build.VERSION_CODES
import android.content.IntentFilter
import android.content.Intent
import android.os.BatteryManager
import android.os.Build.VERSION
import android.content.ContextWrapper
import android.os.Build
import java.util.Locale
import android.os.PowerManager
import android.provider.Settings
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import androidx.core.content.ContextCompat.RECEIVER_NOT_EXPORTED
import android.app.Activity

class BatteryPlusPlugin{
    var applicationContext: Activity? = null

    constructor(activity: Activity){
        this.applicationContext = activity
    }

    public fun getBatteryLevel(): String {
        var currentBatteryLevel =0
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            currentBatteryLevel = getBatteryProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        }
        else {
            val intent = this.applicationContext!!.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            val level = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            currentBatteryLevel = (level * 100 / scale)
        }
        if (currentBatteryLevel != -1) {
            return currentBatteryLevel.toString()
        }
        else {
            return "Battery level not available."
        }
    }

    public fun getBatteryStatus(): String? {
        val status: Int = if (VERSION.SDK_INT >= VERSION_CODES.O) {
            getBatteryProperty(BatteryManager.BATTERY_PROPERTY_STATUS)
        } else {
            val intent = ContextWrapper(this.applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        }
        var currentBatteryStatus = convertBatteryStatus(status)
        if (currentBatteryStatus != null) {
            return currentBatteryStatus
        }
        else {
            return  "Charging status not available."
        }
    }

    @RequiresApi(api = VERSION_CODES.LOLLIPOP)
    private fun getBatteryProperty(property: Int): Int {
        val batteryManager = this.applicationContext!!.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(property)
    }

    private fun convertBatteryStatus(status: Int): String? {
        return when (status) {
            BatteryManager.BATTERY_STATUS_CHARGING -> "charging"
            BatteryManager.BATTERY_STATUS_FULL -> "full"
            BatteryManager.BATTERY_STATUS_DISCHARGING, BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "discharging"
            BatteryManager.BATTERY_STATUS_UNKNOWN -> "unknown"
            else -> null
        }
    }

    public fun isInPowerSaveMode(): Boolean? {
        val deviceManufacturer = Build.MANUFACTURER.lowercase(Locale.getDefault())
        val isInPowerSaveMode: Boolean?
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            isInPowerSaveMode = when (deviceManufacturer) {
                "xiaomi" -> isXiaomiPowerSaveModeActive()
                "huawei" -> isHuaweiPowerSaveModeActive()
                "samsung" -> isSamsungPowerSaveModeActive()
                else -> checkPowerServiceSaveMode()
            }
        } else {
            isInPowerSaveMode = null
        }
        if (isInPowerSaveMode != null) {
            return isInPowerSaveMode
        } else {
            return false
        }
    }

    private fun isSamsungPowerSaveModeActive(): Boolean {
        val mode = Settings.System.getString(this.applicationContext!!.contentResolver, POWER_SAVE_MODE_SAMSUNG_NAME)
        return if (mode == null && VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            checkPowerServiceSaveMode()
        } else {
            mode == POWER_SAVE_MODE_SAMSUNG_VALUE
        }
    }

    @RequiresApi(VERSION_CODES.LOLLIPOP)
    private fun isHuaweiPowerSaveModeActive(): Boolean {
        val mode = Settings.System.getInt(this.applicationContext!!.contentResolver, POWER_SAVE_MODE_HUAWEI_NAME, -1)
        return if (mode != -1) {
            mode == POWER_SAVE_MODE_HUAWEI_VALUE
        } else {
            // On Devices like the P30 lite, we always get an -1 result code.
            // Stackoverflow issue: https://stackoverflow.com/a/70500770
            checkPowerServiceSaveMode()
        }
    }

    private fun isXiaomiPowerSaveModeActive(): Boolean? {
        val mode = Settings.System.getInt(this.applicationContext!!.contentResolver, POWER_SAVE_MODE_XIAOMI_NAME, -1)
        return if (mode != -1) {
            mode == POWER_SAVE_MODE_XIAOMI_VALUE
        } else {
            null
        }
    }

    @RequiresApi(api = VERSION_CODES.LOLLIPOP)
    private fun checkPowerServiceSaveMode(): Boolean {
        val powerManager =
            this.applicationContext!!.getSystemService(Context.POWER_SERVICE) as PowerManager
        return powerManager.isPowerSaveMode
    }

    companion object {
        private const val POWER_SAVE_MODE_SAMSUNG_NAME = "psm_switch"
        private const val POWER_SAVE_MODE_SAMSUNG_VALUE = "1"

        private const val POWER_SAVE_MODE_XIAOMI_NAME = "POWER_SAVE_MODE_OPEN"
        private const val POWER_SAVE_MODE_XIAOMI_VALUE = 1

        private const val POWER_SAVE_MODE_HUAWEI_NAME = "SmartModeStatus"
        private const val POWER_SAVE_MODE_HUAWEI_VALUE = 4
    }

}
