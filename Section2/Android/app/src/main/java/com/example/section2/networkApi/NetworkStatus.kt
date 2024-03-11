package com.example.section2.networkApi

import Print
import android.Manifest.permission.INTERNET
import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest

typealias StateChange = (NetworkStatus.Status) -> Unit

object NetworkStatus {

    enum class Status {
        Normal, NotNetwork, NotPermission;
    }

    private var callbacks = mutableListOf<StateChange?>()

    fun subscribe(callback: StateChange) {
        callbacks.add(callback)
    }

    var status = Status.NotNetwork
        private set(value) {
            field = value
            Print("send status", value)
            callbacks.removeIf { it == null }
            callbacks.forEach { it?.invoke(value) }
        }

    fun registerNetworkStatusListener(context: Context) {
        status = Status.NotNetwork
        if (!hasNetworkPermission(context)) {
            status = Status.NotPermission
        }
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        val networkCallback = object : ConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: Network) {
                super.onAvailable(network)
                if (status != Status.NotPermission) {
                    status = Status.Normal
                }
            }

            override fun onLost(network: Network) {
                super.onLost(network)
                if (status != Status.NotPermission) {
                    status = Status.NotNetwork
                }
            }
        }

        val builder = NetworkRequest.Builder()
            .addTransportType(NetworkCapabilities.TRANSPORT_CELLULAR)
            .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)

        connectivityManager.registerNetworkCallback(builder.build(), networkCallback)
    }

    private fun hasNetworkPermission(context: Context): Boolean {
        return context.checkSelfPermission(INTERNET) == PackageManager.PERMISSION_GRANTED
    }

}


