package com.example.section2.app.home.view

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import com.example.section2.app.home.viewModel.HeaderViewModel
import com.example.section2.app.home.viewModel.HomeViewModel

@Composable
fun HomeView(
    viewModel: HomeViewModel,
    headerViewModel: HeaderViewModel
) {

    Column(modifier = Modifier.fillMaxSize().background(Color.White)) {
        HeaderView("iTunes Music", headerViewModel)
        if (viewModel.showError.value == null)
            TableView(vm = viewModel)
         else
            ErrorView(viewModel.showError.value!!) {
                viewModel.getList()
            }
    }
}