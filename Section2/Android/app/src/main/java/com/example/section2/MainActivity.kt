package com.example.section2

import android.annotation.SuppressLint
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.example.section2.app.home.view.HomeView
import com.example.section2.app.home.viewModel.HeaderViewModel
import com.example.section2.app.home.viewModel.HomeViewModel
import com.example.section2.networkApi.NetworkStatus

class MainActivity : ComponentActivity() {
    private val headerViewModel = HeaderViewModel()
    private val viewModel = HomeViewModel()

    @SuppressLint("ResourceAsColor")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        NetworkStatus.registerNetworkStatusListener(this)

        viewModel.registerObserver(headerViewModel.output)

        setContent {
            HomeView(viewModel, headerViewModel)
        }
    }
}
