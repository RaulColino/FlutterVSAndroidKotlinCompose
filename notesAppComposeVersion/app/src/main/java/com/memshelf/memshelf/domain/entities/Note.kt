package com.memshelf.memshelf.domain.entities

import androidx.compose.ui.graphics.Color
import androidx.room.Entity
import androidx.room.PrimaryKey
import com.memshelf.memshelf.ui.theme.MemBlue
import com.memshelf.memshelf.ui.theme.MemGreen
import com.memshelf.memshelf.ui.theme.MemOrange
import com.memshelf.memshelf.ui.theme.MemPurple
import java.lang.Exception

@Entity
data class Note (
    @PrimaryKey(autoGenerate = true) val id:Int? = null,
    val title : String,
    val body: String,
    val color : String,

    ) {

    companion object {
        val noteColors = listOf<Color>(MemOrange, MemGreen, MemPurple, MemBlue)
    }
}

class InvalidNoteException(message:String): Exception(message)

