package com.example.section2.app.home.viewModel

import androidx.compose.runtime.mutableStateOf
import io.reactivex.rxjava3.core.Observable
import io.reactivex.rxjava3.core.ObservableEmitter


class HeaderViewModel {

    data class Output(
        var value: Any?,
        var action: Action
    ) {
        enum class Action {
            KeywordChange,
            SortChange
        }
    }

    var outputEmitter: ObservableEmitter<Output>? = null

    var output = Observable.create { outputEmitter = it }

    var keyword = mutableStateOf<String?>("")

    fun onSearchTextChange(text: String?) {
        keyword.value = text
        outputEmitter?.onNext(Output(text?.uppercase(), Output.Action.KeywordChange))
    }

    var sortType = mutableStateOf(SortType.Artist)

    fun changeSortType(newType: SortType) {
        sortType.value = newType
        outputEmitter?.onNext(Output(newType, Output.Action.SortChange))
    }


    enum class SortType {
        Artist, Price;

        val text: String
            get() = when (this) {
                Artist -> "Off"
                Price -> "Sort by Price"
            }
    }

}