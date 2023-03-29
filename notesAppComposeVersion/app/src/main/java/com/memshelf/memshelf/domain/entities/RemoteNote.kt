package com.memshelf.memshelf.domain.entities

import androidx.compose.ui.graphics.Color
import com.memshelf.memshelf.ui.theme.MemBlue
import com.memshelf.memshelf.ui.theme.MemGreen
import com.memshelf.memshelf.ui.theme.MemOrange
import com.memshelf.memshelf.ui.theme.MemPurple

data class RemoteNote (
    val title : String,
    val color : String,
    val category : String,
    val body: String,

    ) {

    constructor() : this("","","","")

    companion object {
        val noteColors = listOf<Color>(MemOrange, MemGreen, MemPurple, MemBlue)
    }
}
