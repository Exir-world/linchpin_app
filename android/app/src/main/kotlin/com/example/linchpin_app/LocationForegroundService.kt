package com.example.app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.location.Location
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.*
import okhttp3.*
import org.json.JSONObject
import java.io.IOException
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody

class LocationForegroundService : Service() {

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private val client = OkHttpClient()

    private val handler = Handler(Looper.getMainLooper())
    private val interval = 15 * 60 * 1000L  // 15 دقیقه

    private val locationRunnable = object : Runnable {
        override fun run() {
            checkAndSendLocation()
            handler.postDelayed(this, interval)  // اجرا دوباره بعد 15 دقیقه
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        startForegroundService()

        handler.post(locationRunnable)  // شروع اجرا دوره‌ای

        return START_STICKY
    }

    private fun startForegroundService() {
        val channelId = "location_channel"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Location Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }

        val notification: Notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Location Tracking Active")
            .setContentText("Getting your location in background...")
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .build()

        startForeground(1, notification)
    }

    private fun checkAndSendLocation() {
        val sharedPref = getSharedPreferences("my_prefs", Context.MODE_PRIVATE)
        val token = sharedPref.getString("jwtToken", null)
        val language = sharedPref.getString("selectedLanguageCode", "fa")
        val startTime = sharedPref.getString("startTime", null) // مثلا "09:00"
        val endTime = sharedPref.getString("endTime", null)     // مثلا "18:00"

        if (token == null || startTime == null || endTime == null) {
            Log.e("LocationService", "Missing required prefs")
            stopSelf()
            return
        }

        val now = java.util.Calendar.getInstance()

        val startParts = startTime.split(":").map { it.toInt() }
        val endParts = endTime.split(":").map { it.toInt() }

        val startCal = java.util.Calendar.getInstance().apply {
            set(java.util.Calendar.HOUR_OF_DAY, startParts[0])
            set(java.util.Calendar.MINUTE, startParts[1])
            set(java.util.Calendar.SECOND, 0)
            set(java.util.Calendar.MILLISECOND, 0)
        }

        val endCal = java.util.Calendar.getInstance().apply {
            set(java.util.Calendar.HOUR_OF_DAY, endParts[0])
            set(java.util.Calendar.MINUTE, endParts[1])
            set(java.util.Calendar.SECOND, 0)
            set(java.util.Calendar.MILLISECOND, 0)
        }

        if (now.timeInMillis in startCal.timeInMillis..endCal.timeInMillis) {
            Log.i("LocationService", "Inside work hours. Getting location...")
            getAndSendLocation(token, language ?: "fa")
        } else {
            Log.i("LocationService", "Outside work hours. Not sending location.")
            // اگر بیرون بازه‌زمانی بودیم، می‌خوایم همچنان سرویس رو نگه داریم که بتونیم ۱۵ دقیقه بعد دوباره چک کنیم
            // پس stopSelf نکنیم، فقط صدا زدن دوباره توسط handler انجام میشه.
        }
    }

    private fun getAndSendLocation(token: String, language: String) {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as android.location.LocationManager
        val gpsEnabled = locationManager.isProviderEnabled(android.location.LocationManager.GPS_PROVIDER)

        if (!gpsEnabled) {
            Log.i("LocationService", "GPS is disabled. Sending gpsIsOn=false")
            sendLocationToServer(0.0, 0.0, false, token, language)
            return
        }

        if (checkSelfPermission(android.Manifest.permission.ACCESS_FINE_LOCATION) != android.content.pm.PackageManager.PERMISSION_GRANTED
            && checkSelfPermission(android.Manifest.permission.ACCESS_COARSE_LOCATION) != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            Log.e("LocationService", "Location permission not granted")
            return
        }

        fusedLocationClient.lastLocation.addOnSuccessListener { location: Location? ->
            if (location != null) {
                Log.i("LocationService", "Got location: ${location.latitude}, ${location.longitude}")
                sendLocationToServer(location.latitude, location.longitude, true, token, language)
            } else {
                Log.w("LocationService", "No last known location available.")
                sendLocationToServer(0.0, 0.0, false, token, language)
            }
        }.addOnFailureListener {
            Log.e("LocationService", "Failed to get location: ${it.message}")
            sendLocationToServer(0.0, 0.0, false, token, language)
        }
    }

    private fun sendLocationToServer(lat: Double, lng: Double, gpsIsOn: Boolean, token: String, language: String) {
        val json = JSONObject()
        json.put("lat", lat)
        json.put("lng", lng)
        json.put("gpsIsOn", gpsIsOn)

        val mediaType = "application/json; charset=utf-8".toMediaType()
        val body = json.toString().toRequestBody(mediaType)
        val request = Request.Builder()
            .url("https://linchpin.ex.pro/api/attendance/check-location")
            .addHeader("Authorization", "Bearer $token")
            .addHeader("Accept-Language", language)
            .addHeader("Content-Type", "application/json")
            .post(body)
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e("LocationService", "Failed to send location: ${e.message}")
            }

            override fun onResponse(call: Call, response: Response) {
                response.use {
                    if (response.isSuccessful) {
                        Log.i("LocationService", "Location sent successfully.")
                    } else {
                        Log.e("LocationService", "Failed to send location: ${response.code}")
                    }
                }
            }
        })
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(locationRunnable)  // قطع اجرای دوره‌ای هنگام توقف سرویس
    }
}
