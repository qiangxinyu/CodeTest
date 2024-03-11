package com.example.section2.app.home.view

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Icon
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.section2.app.home.viewModel.HeaderViewModel
import com.example.section2.ui.theme.DefaultMargin


@Composable
fun HeaderView(title: String, vm: HeaderViewModel) {

    val focusManager = LocalFocusManager.current

    Column(
        modifier = Modifier
            .height(190.dp)
            .fillMaxSize()
    ) {
        Text(
            text = title,
            fontSize = 20.sp,
            modifier = Modifier
                .align(Alignment.CenterHorizontally)
                .padding(top = DefaultMargin)
        )


        TextField(
            value = vm.keyword.value ?: "",
            onValueChange = vm::onSearchTextChange,
            placeholder = { Text(text = "Search Artist Or Song Name") },
            trailingIcon = {
                Icon(imageVector = Icons.Default.Search, contentDescription = null)
            },
            shape = CircleShape,
            colors = TextFieldDefaults.colors(
                disabledTextColor = Color.Transparent,
                focusedIndicatorColor = Color.Transparent,
                unfocusedIndicatorColor = Color.Transparent,
                disabledIndicatorColor = Color.Transparent
            ),
            keyboardOptions = KeyboardOptions(imeAction = ImeAction.Search),
            keyboardActions = KeyboardActions( onSearch = { focusManager.clearFocus() }),
            modifier = Modifier
                .padding(DefaultMargin)
                .fillMaxWidth()
        )

        Text(
            text = "Sorting option",
            modifier = Modifier.padding(start = DefaultMargin)
        )

        Row(modifier = Modifier.padding(top = 5.dp)) {
            listOf(
                HeaderViewModel.SortType.Artist,
                HeaderViewModel.SortType.Price
            ).forEach {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.Center,
                    modifier = Modifier.weight(1f)
                ) {
                    RadioButton(
                        selected = it == vm.sortType.value,
                        onClick = {  vm.changeSortType(it)  }
                    )
                    Text(text = it.text)
                }
            }
        }

    }
}