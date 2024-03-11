package com.example.section2.app.home.view

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.pullrefresh.PullRefreshIndicator
import androidx.compose.material.pullrefresh.pullRefresh
import androidx.compose.material.pullrefresh.rememberPullRefreshState
import androidx.compose.material3.LocalTextStyle
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import com.example.section2.app.home.viewModel.HomeViewModel
import com.example.section2.networkApi.SongModel
import com.example.section2.ui.theme.DefaultMargin
import com.example.section2.ui.theme.LineColor

@OptIn(ExperimentalMaterialApi::class)
@Composable
fun TableView(vm: HomeViewModel) {

    val state = rememberPullRefreshState(vm.pullRefreshing.value, vm::getList)

    Box(Modifier.pullRefresh(state)) {

        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
        ) {
            items(vm.list) {

                Cell(item = it)

                Box(
                    modifier = Modifier
                        .height(0.5.dp)
                        .background(LineColor)
                        .align(Alignment.BottomCenter)
                        .fillMaxSize()
                )
            }
        }

        PullRefreshIndicator(
            refreshing = vm.pullRefreshing.value,
            state = state,
            modifier = Modifier.align(Alignment.TopCenter)
        )

    }
}


@Composable
fun Cell(item: SongModel) {
    Row(
        modifier = Modifier
            .height(80.dp)
            .fillMaxSize(),
        verticalAlignment = Alignment.CenterVertically,

        ) {
        AsyncImage(
            model = item.artworkUrl,
            contentDescription = null,
            modifier = Modifier
                .padding(start = DefaultMargin, top = 10.dp, bottom = 10.dp)
                .aspectRatio(1f),
            contentScale = ContentScale.Crop
        )

        Column(
            modifier = Modifier
                .weight(1f)
                .padding(start = 10.dp)
        ) {
            AutoSizeText(
                text = item.trackName,
                fontSize = 16.sp,
                modifier = Modifier.padding(bottom = 5.dp)
            )

            AutoSizeText(
                text = item.artistName,
                fontSize = 12.sp,
                modifier = Modifier.padding(top = 5.dp)
            )
        }

        Text(
            text = "$" + "%.2f".format(item.trackPrice),
            fontSize = 14.sp,
            modifier = Modifier
                .align(Alignment.Bottom)
                .padding(bottom = 10.dp, end = DefaultMargin)
        )
    }
}

@Composable
fun AutoSizeText(text: String, modifier: Modifier, fontSize: TextUnit = 16.sp) {

    val style = LocalTextStyle.current.copy(fontSize = fontSize)

    var multiplier by remember { mutableStateOf(1f) }

    Text(
        text,
        modifier,
        maxLines = 1, // modify to fit your need
        overflow = TextOverflow.Visible,
        style = style.copy(
            fontSize = style.fontSize * multiplier
        ),
        onTextLayout = {
            if (it.hasVisualOverflow) {
                multiplier *= 0.9f // you can tune this constant
            }
        }
    )
}