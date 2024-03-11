package com.example.section2.app.home.view

import android.content.Intent
import android.provider.Settings
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.Button
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.example.section2.app.home.viewModel.HomeViewModel

@Composable
fun ErrorView(errorInfo: HomeViewModel.ErrorInfo, reloadList: () -> Unit) {

    val local = LocalContext.current

    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            errorInfo.title,
            Modifier.padding(start = 40.dp, end = 40.dp),
            textAlign = TextAlign.Center
        )

        Button(
            onClick = {
                when (errorInfo.action) {
                    HomeViewModel.ErrorInfo.Action.GoSetting -> {
                        local.startActivity(Intent(Settings.ACTION_SETTINGS))
                    }
                    HomeViewModel.ErrorInfo.Action.ReloadList -> reloadList()
                }
            },
            Modifier.padding(top = 10.dp, bottom = 40.dp)
        ) {
            Text(errorInfo.buttonTitle)
        }
    }
}